{ overlay }:
{ config, lib, pkgs, inputs, ... }: with lib; let
  cfg = config.services.zeusAudio;
  aiohttpSocket = "/run/audio-recorder/audio-recorder.sock";
in {

  options.services.zeusAudio = {
    enable = mkEnableOption "Zeus synchronized audio recording server";

    virtualHost = mkOption {
      type = types.str;
      description = "Name of the nginx virtual host";
    };

    audioDir = mkOption {
      type = types.str;
      default = "audio";
      description = "Path to save recorded files (relative to /var/lib)";
    };

    cardIndex = mkOption {
      type = types.int;
      default = 0;
      description = "ALSA card index";
    };

    control = mkOption {
      type = types.str;
      default = "Capture";
      description = "Name of the capture volume control";
    };

    devices = mkOption {
      type = types.listOf types.str;
      default = [ "" ];
      description = "Addresses of devices to display in the web interface";
    };

    clockMaster = mkOption {
      type = types.bool;
      default = false;
      description = "If true, this device serves time to the others";
    };
  };

  config = mkIf cfg.enable {
    nixpkgs.overlays = [ overlay ];
  
    users = {
      users.audio-server = {
        isSystemUser = true;
        group = "audio-recorder";
        extraGroups = [ "audio" ];
      };
      groups.audio-recorder = {};
    };

    systemd.services.audio-server = {
      path = [ "/run/wrappers" pkgs.systemd ];
      environment = {
        RUST_LOG = "info";
        AUDIO_SERVER_SETTINGS = pkgs.writeText "audio-server-settings.yaml" (builtins.toJSON {
          systemd_logging = true;
          audio_dir = "/var/lib/${cfg.audioDir}";
          mixer_control = cfg.control;
          mixer_enums = [ {
            control = "Capture Mux";
            value = "LINE_IN";
          } ];
          clock_master = cfg.clockMaster;
        });
      };
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        User = "audio-server";
        Group = "audio-recorder";
        ExecStart = "${pkgs.audio-recorder.audio-server}/bin/audio_server";
        AmbientCapabilities = "CAP_SYS_TIME";
        StateDirectory = cfg.audioDir;
        StateDirectoryMode = "0770";
      };
    };

    security.sudo = {
      enable = true;
      extraConfig = with pkgs; ''
        Defaults:nginx secure_path="${systemd}/bin"
        nginx ALL=(root) NOPASSWD: ${systemd}/bin/poweroff

        Defaults:audio-server secure_path="${systemd}/bin:${chrony}/bin"
        audio-server ALL=(root) NOPASSWD: ${systemd}/bin/systemctl start chronyd
        audio-server ALL=(chrony) NOPASSWD: ${chrony}/bin/chronyc *
      '';
    };

    systemd.services.audio-recorder = {
      path = [ "/run/wrappers" ];
      wantedBy = [ "nginx.service" ];
      serviceConfig = {
        User = "nginx";
        Group = "nginx";
        ExecStart = let
          env = pkgs.python3.withPackages (p: [ pkgs.audio-recorder.web-interface ]);
        in escapeShellArgs ([ env.interpreter "-m" "aiohttp.web"
          "--path" aiohttpSocket
          "audio_recorder.web_interface:init"
        ] ++ concatMap (d: [ "--device" d ]) cfg.devices);
        RuntimeDirectory = "audio-recorder";
      };
    };

    services.nginx = {
      enable = true;
      virtualHosts.audio-recorder = {
        locations = {
          "/" = {
            tryFiles = "$uri @audio_recorder";
          };

          "/levels" = {
            tryFiles = "$uri @audio_recorder";
            extraConfig = ''
              chunked_transfer_encoding off;
            '';
          };

          "@audio_recorder" = {
            extraConfig = ''
              proxy_set_header Host $host;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_pass http://unix:${aiohttpSocket};
            '';
          };

          "/static/" = {
            root = "${pkgs.audio-recorder.web-interface}/${pkgs.python3.sitePackages}/audio_recorder/web_interface";
            extraConfig = ''
              expires 300;
            '';
          };
        };
      };
    };
  };
}
