{ lib, buildRustCrate, buildRustCrateHelpers }:
with buildRustCrateHelpers;
let inherit (lib.lists) fold;
    inherit (lib.attrsets) recursiveUpdate;
in
rec {

# aho-corasick-0.7.10

  crates.aho_corasick."0.7.10" = deps: { features?(features_.aho_corasick."0.7.10" deps {}) }: buildRustCrate {
    crateName = "aho-corasick";
    version = "0.7.10";
    description = "Fast multiple substring searching.";
    authors = [ "Andrew Gallant <jamslam@gmail.com>" ];
    sha256 = "0mmhg2dsz8b2iphdhdx24kzgr2ga9p879w30y1529kcsqv26mfwv";
    libName = "aho_corasick";
    dependencies = mapFeatures features ([
      (crates."memchr"."${deps."aho_corasick"."0.7.10"."memchr"}" deps)
    ]);
    features = mkFeatures (features."aho_corasick"."0.7.10" or {});
  };
  features_.aho_corasick."0.7.10" = deps: f: updateFeatures f (rec {
    aho_corasick = fold recursiveUpdate {} [
      { "0.7.10"."std" =
        (f.aho_corasick."0.7.10"."std" or false) ||
        (f.aho_corasick."0.7.10".default or false) ||
        (aho_corasick."0.7.10"."default" or false); }
      { "0.7.10".default = (f.aho_corasick."0.7.10".default or true); }
    ];
    memchr = fold recursiveUpdate {} [
      { "${deps.aho_corasick."0.7.10".memchr}"."use_std" =
        (f.memchr."${deps.aho_corasick."0.7.10".memchr}"."use_std" or false) ||
        (aho_corasick."0.7.10"."std" or false) ||
        (f."aho_corasick"."0.7.10"."std" or false); }
      { "${deps.aho_corasick."0.7.10".memchr}".default = (f.memchr."${deps.aho_corasick."0.7.10".memchr}".default or false); }
    ];
  }) [
    (features_.memchr."${deps."aho_corasick"."0.7.10"."memchr"}" deps)
  ];


# end
# anyhow-1.0.27

  crates.anyhow."1.0.27" = deps: { features?(features_.anyhow."1.0.27" deps {}) }: buildRustCrate {
    crateName = "anyhow";
    version = "1.0.27";
    description = "Flexible concrete Error type built on std::error::Error";
    authors = [ "David Tolnay <dtolnay@gmail.com>" ];
    edition = "2018";
    sha256 = "1q8hij7rnrsj5cvz2gfkqkn5w09bsf09rpaa75lsr58qs059rgyz";
    features = mkFeatures (features."anyhow"."1.0.27" or {});
  };
  features_.anyhow."1.0.27" = deps: f: updateFeatures f (rec {
    anyhow = fold recursiveUpdate {} [
      { "1.0.27"."std" =
        (f.anyhow."1.0.27"."std" or false) ||
        (f.anyhow."1.0.27".default or false) ||
        (anyhow."1.0.27"."default" or false); }
      { "1.0.27".default = (f.anyhow."1.0.27".default or true); }
    ];
  }) [];


# end
# arc-swap-0.4.5

  crates.arc_swap."0.4.5" = deps: { features?(features_.arc_swap."0.4.5" deps {}) }: buildRustCrate {
    crateName = "arc-swap";
    version = "0.4.5";
    description = "Atomically swappable Arc";
    authors = [ "Michal 'vorner' Vaner <vorner@vorner.cz>" ];
    sha256 = "0y82993jh2c71qsrqwdr8h4w7bpmjm6v5ndygqnqc3w8nklgzfg7";
    features = mkFeatures (features."arc_swap"."0.4.5" or {});
  };
  features_.arc_swap."0.4.5" = deps: f: updateFeatures f (rec {
    arc_swap."0.4.5".default = (f.arc_swap."0.4.5".default or true);
  }) [];


# end
# async-stream-0.2.1

  crates.async_stream."0.2.1" = deps: { features?(features_.async_stream."0.2.1" deps {}) }: buildRustCrate {
    crateName = "async-stream";
    version = "0.2.1";
    description = "Asynchronous streams using async & await notation";
    authors = [ "Carl Lerche <me@carllerche.com>" ];
    edition = "2018";
    sha256 = "1m14xhhhl6l5lk0fppah7dyb2v7g7xg876539l6dz6snx8ghay28";
    dependencies = mapFeatures features ([
      (crates."async_stream_impl"."${deps."async_stream"."0.2.1"."async_stream_impl"}" deps)
      (crates."futures_core"."${deps."async_stream"."0.2.1"."futures_core"}" deps)
    ]);
  };
  features_.async_stream."0.2.1" = deps: f: updateFeatures f (rec {
    async_stream."0.2.1".default = (f.async_stream."0.2.1".default or true);
    async_stream_impl."${deps.async_stream."0.2.1".async_stream_impl}".default = true;
    futures_core."${deps.async_stream."0.2.1".futures_core}".default = true;
  }) [
    (features_.async_stream_impl."${deps."async_stream"."0.2.1"."async_stream_impl"}" deps)
    (features_.futures_core."${deps."async_stream"."0.2.1"."futures_core"}" deps)
  ];


# end
# async-stream-impl-0.2.1

  crates.async_stream_impl."0.2.1" = deps: { features?(features_.async_stream_impl."0.2.1" deps {}) }: buildRustCrate {
    crateName = "async-stream-impl";
    version = "0.2.1";
    description = "proc macros for async-stream crate";
    authors = [ "Carl Lerche <me@carllerche.com>" ];
    edition = "2018";
    sha256 = "0x3r9mspq214niwhx67fkn0rhszysqrxig9nizly505wghar7zwp";
    procMacro = true;
    dependencies = mapFeatures features ([
      (crates."proc_macro2"."${deps."async_stream_impl"."0.2.1"."proc_macro2"}" deps)
      (crates."quote"."${deps."async_stream_impl"."0.2.1"."quote"}" deps)
      (crates."syn"."${deps."async_stream_impl"."0.2.1"."syn"}" deps)
    ]);
  };
  features_.async_stream_impl."0.2.1" = deps: f: updateFeatures f (rec {
    async_stream_impl."0.2.1".default = (f.async_stream_impl."0.2.1".default or true);
    proc_macro2."${deps.async_stream_impl."0.2.1".proc_macro2}".default = true;
    quote."${deps.async_stream_impl."0.2.1".quote}".default = true;
    syn = fold recursiveUpdate {} [
      { "${deps.async_stream_impl."0.2.1".syn}"."extra-traits" = true; }
      { "${deps.async_stream_impl."0.2.1".syn}"."full" = true; }
      { "${deps.async_stream_impl."0.2.1".syn}"."visit-mut" = true; }
      { "${deps.async_stream_impl."0.2.1".syn}".default = true; }
    ];
  }) [
    (features_.proc_macro2."${deps."async_stream_impl"."0.2.1"."proc_macro2"}" deps)
    (features_.quote."${deps."async_stream_impl"."0.2.1"."quote"}" deps)
    (features_.syn."${deps."async_stream_impl"."0.2.1"."syn"}" deps)
  ];


# end
# async-trait-0.1.26

  crates.async_trait."0.1.26" = deps: { features?(features_.async_trait."0.1.26" deps {}) }: buildRustCrate {
    crateName = "async-trait";
    version = "0.1.26";
    description = "Type erasure for async trait methods";
    authors = [ "David Tolnay <dtolnay@gmail.com>" ];
    edition = "2018";
    sha256 = "100jymkpc7a7i5snhqngpnq1lmiywmhqf4gf36f8kz1a24xijbr6";
    procMacro = true;
    dependencies = mapFeatures features ([
      (crates."proc_macro2"."${deps."async_trait"."0.1.26"."proc_macro2"}" deps)
      (crates."quote"."${deps."async_trait"."0.1.26"."quote"}" deps)
      (crates."syn"."${deps."async_trait"."0.1.26"."syn"}" deps)
    ]);
    features = mkFeatures (features."async_trait"."0.1.26" or {});
  };
  features_.async_trait."0.1.26" = deps: f: updateFeatures f (rec {
    async_trait."0.1.26".default = (f.async_trait."0.1.26".default or true);
    proc_macro2."${deps.async_trait."0.1.26".proc_macro2}".default = true;
    quote."${deps.async_trait."0.1.26".quote}".default = true;
    syn = fold recursiveUpdate {} [
      { "${deps.async_trait."0.1.26".syn}"."full" = true; }
      { "${deps.async_trait."0.1.26".syn}"."visit-mut" = true; }
      { "${deps.async_trait."0.1.26".syn}".default = true; }
    ];
  }) [
    (features_.proc_macro2."${deps."async_trait"."0.1.26"."proc_macro2"}" deps)
    (features_.quote."${deps."async_trait"."0.1.26"."quote"}" deps)
    (features_.syn."${deps."async_trait"."0.1.26"."syn"}" deps)
  ];


# end
# atty-0.2.14

  crates.atty."0.2.14" = deps: { features?(features_.atty."0.2.14" deps {}) }: buildRustCrate {
    crateName = "atty";
    version = "0.2.14";
    description = "A simple interface for querying atty";
    authors = [ "softprops <d.tangren@gmail.com>" ];
    sha256 = "18x3dv3clg1qyf0skj16b9zd9679dav2r81in85zdmb5aqd25564";
    dependencies = (if kernel == "hermit" then mapFeatures features ([
      (crates."hermit_abi"."${deps."atty"."0.2.14"."hermit_abi"}" deps)
    ]) else [])
      ++ (if (kernel == "linux" || kernel == "darwin") then mapFeatures features ([
      (crates."libc"."${deps."atty"."0.2.14"."libc"}" deps)
    ]) else [])
      ++ (if kernel == "windows" then mapFeatures features ([
      (crates."winapi"."${deps."atty"."0.2.14"."winapi"}" deps)
    ]) else []);
  };
  features_.atty."0.2.14" = deps: f: updateFeatures f (rec {
    atty."0.2.14".default = (f.atty."0.2.14".default or true);
    hermit_abi."${deps.atty."0.2.14".hermit_abi}".default = true;
    libc."${deps.atty."0.2.14".libc}".default = (f.libc."${deps.atty."0.2.14".libc}".default or false);
    winapi = fold recursiveUpdate {} [
      { "${deps.atty."0.2.14".winapi}"."consoleapi" = true; }
      { "${deps.atty."0.2.14".winapi}"."minwinbase" = true; }
      { "${deps.atty."0.2.14".winapi}"."minwindef" = true; }
      { "${deps.atty."0.2.14".winapi}"."processenv" = true; }
      { "${deps.atty."0.2.14".winapi}"."winbase" = true; }
      { "${deps.atty."0.2.14".winapi}".default = true; }
    ];
  }) [
    (features_.hermit_abi."${deps."atty"."0.2.14"."hermit_abi"}" deps)
    (features_.libc."${deps."atty"."0.2.14"."libc"}" deps)
    (features_.winapi."${deps."atty"."0.2.14"."winapi"}" deps)
  ];


# end
# autocfg-1.0.0

  crates.autocfg."1.0.0" = deps: { features?(features_.autocfg."1.0.0" deps {}) }: buildRustCrate {
    crateName = "autocfg";
    version = "1.0.0";
    description = "Automatic cfg for Rust compiler features";
    authors = [ "Josh Stone <cuviper@gmail.com>" ];
    sha256 = "1hhgqh551gmws22z9rxbnsvlppwxvlj0nszj7n1x56pqa3j3swy7";
  };
  features_.autocfg."1.0.0" = deps: f: updateFeatures f (rec {
    autocfg."1.0.0".default = (f.autocfg."1.0.0".default or true);
  }) [];


# end
# backtrace-0.3.46

  crates.backtrace."0.3.46" = deps: { features?(features_.backtrace."0.3.46" deps {}) }: buildRustCrate {
    crateName = "backtrace";
    version = "0.3.46";
    description = "A library to acquire a stack trace (backtrace) at runtime in a Rust program.\n";
    authors = [ "The Rust Project Developers" ];
    edition = "2018";
    sha256 = "11bh4zlmngc405zmcyakm8lzx0lvb2b6fscn3af8l662n4k8qyi0";
    dependencies = mapFeatures features ([
      (crates."cfg_if"."${deps."backtrace"."0.3.46"."cfg_if"}" deps)
      (crates."libc"."${deps."backtrace"."0.3.46"."libc"}" deps)
      (crates."rustc_demangle"."${deps."backtrace"."0.3.46"."rustc_demangle"}" deps)
    ]
      ++ (if features.backtrace."0.3.46".backtrace-sys or false then [ (crates.backtrace_sys."${deps."backtrace"."0.3.46".backtrace_sys}" deps) ] else []))
      ++ (if kernel == "windows" then mapFeatures features ([
]) else []);
    features = mkFeatures (features."backtrace"."0.3.46" or {});
  };
  features_.backtrace."0.3.46" = deps: f: updateFeatures f (rec {
    backtrace = fold recursiveUpdate {} [
      { "0.3.46"."addr2line" =
        (f.backtrace."0.3.46"."addr2line" or false) ||
        (f.backtrace."0.3.46".gimli-symbolize or false) ||
        (backtrace."0.3.46"."gimli-symbolize" or false); }
      { "0.3.46"."compiler_builtins" =
        (f.backtrace."0.3.46"."compiler_builtins" or false) ||
        (f.backtrace."0.3.46".rustc-dep-of-std or false) ||
        (backtrace."0.3.46"."rustc-dep-of-std" or false); }
      { "0.3.46"."core" =
        (f.backtrace."0.3.46"."core" or false) ||
        (f.backtrace."0.3.46".rustc-dep-of-std or false) ||
        (backtrace."0.3.46"."rustc-dep-of-std" or false); }
      { "0.3.46"."dbghelp" =
        (f.backtrace."0.3.46"."dbghelp" or false) ||
        (f.backtrace."0.3.46".default or false) ||
        (backtrace."0.3.46"."default" or false); }
      { "0.3.46"."dladdr" =
        (f.backtrace."0.3.46"."dladdr" or false) ||
        (f.backtrace."0.3.46".default or false) ||
        (backtrace."0.3.46"."default" or false); }
      { "0.3.46"."findshlibs" =
        (f.backtrace."0.3.46"."findshlibs" or false) ||
        (f.backtrace."0.3.46".gimli-symbolize or false) ||
        (backtrace."0.3.46"."gimli-symbolize" or false); }
      { "0.3.46"."goblin" =
        (f.backtrace."0.3.46"."goblin" or false) ||
        (f.backtrace."0.3.46".gimli-symbolize or false) ||
        (backtrace."0.3.46"."gimli-symbolize" or false); }
      { "0.3.46"."libbacktrace" =
        (f.backtrace."0.3.46"."libbacktrace" or false) ||
        (f.backtrace."0.3.46".default or false) ||
        (backtrace."0.3.46"."default" or false); }
      { "0.3.46"."libunwind" =
        (f.backtrace."0.3.46"."libunwind" or false) ||
        (f.backtrace."0.3.46".default or false) ||
        (backtrace."0.3.46"."default" or false); }
      { "0.3.46"."memmap" =
        (f.backtrace."0.3.46"."memmap" or false) ||
        (f.backtrace."0.3.46".gimli-symbolize or false) ||
        (backtrace."0.3.46"."gimli-symbolize" or false); }
      { "0.3.46"."rustc-serialize" =
        (f.backtrace."0.3.46"."rustc-serialize" or false) ||
        (f.backtrace."0.3.46".serialize-rustc or false) ||
        (backtrace."0.3.46"."serialize-rustc" or false); }
      { "0.3.46"."serde" =
        (f.backtrace."0.3.46"."serde" or false) ||
        (f.backtrace."0.3.46".serialize-serde or false) ||
        (backtrace."0.3.46"."serialize-serde" or false); }
      { "0.3.46"."std" =
        (f.backtrace."0.3.46"."std" or false) ||
        (f.backtrace."0.3.46".default or false) ||
        (backtrace."0.3.46"."default" or false); }
      { "0.3.46".default = (f.backtrace."0.3.46".default or true); }
    ];
    backtrace_sys = fold recursiveUpdate {} [
      { "${deps.backtrace."0.3.46".backtrace_sys}"."backtrace-sys" =
        (f.backtrace_sys."${deps.backtrace."0.3.46".backtrace_sys}"."backtrace-sys" or false) ||
        (backtrace."0.3.46"."libbacktrace" or false) ||
        (f."backtrace"."0.3.46"."libbacktrace" or false); }
      { "${deps.backtrace."0.3.46".backtrace_sys}"."rustc-dep-of-std" =
        (f.backtrace_sys."${deps.backtrace."0.3.46".backtrace_sys}"."rustc-dep-of-std" or false) ||
        (backtrace."0.3.46"."rustc-dep-of-std" or false) ||
        (f."backtrace"."0.3.46"."rustc-dep-of-std" or false); }
      { "${deps.backtrace."0.3.46".backtrace_sys}".default = true; }
    ];
    cfg_if = fold recursiveUpdate {} [
      { "${deps.backtrace."0.3.46".cfg_if}"."rustc-dep-of-std" =
        (f.cfg_if."${deps.backtrace."0.3.46".cfg_if}"."rustc-dep-of-std" or false) ||
        (backtrace."0.3.46"."rustc-dep-of-std" or false) ||
        (f."backtrace"."0.3.46"."rustc-dep-of-std" or false); }
      { "${deps.backtrace."0.3.46".cfg_if}".default = true; }
    ];
    libc = fold recursiveUpdate {} [
      { "${deps.backtrace."0.3.46".libc}"."rustc-dep-of-std" =
        (f.libc."${deps.backtrace."0.3.46".libc}"."rustc-dep-of-std" or false) ||
        (backtrace."0.3.46"."rustc-dep-of-std" or false) ||
        (f."backtrace"."0.3.46"."rustc-dep-of-std" or false); }
      { "${deps.backtrace."0.3.46".libc}".default = (f.libc."${deps.backtrace."0.3.46".libc}".default or false); }
    ];
    rustc_demangle = fold recursiveUpdate {} [
      { "${deps.backtrace."0.3.46".rustc_demangle}"."rustc-dep-of-std" =
        (f.rustc_demangle."${deps.backtrace."0.3.46".rustc_demangle}"."rustc-dep-of-std" or false) ||
        (backtrace."0.3.46"."rustc-dep-of-std" or false) ||
        (f."backtrace"."0.3.46"."rustc-dep-of-std" or false); }
      { "${deps.backtrace."0.3.46".rustc_demangle}".default = true; }
    ];
  }) [
    (features_.backtrace_sys."${deps."backtrace"."0.3.46"."backtrace_sys"}" deps)
    (features_.cfg_if."${deps."backtrace"."0.3.46"."cfg_if"}" deps)
    (features_.libc."${deps."backtrace"."0.3.46"."libc"}" deps)
    (features_.rustc_demangle."${deps."backtrace"."0.3.46"."rustc_demangle"}" deps)
  ];


# end
# backtrace-sys-0.1.35

  crates.backtrace_sys."0.1.35" = deps: { features?(features_.backtrace_sys."0.1.35" deps {}) }: buildRustCrate {
    crateName = "backtrace-sys";
    version = "0.1.35";
    description = "Bindings to the libbacktrace gcc library\n";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "0ipr3zppz25fyblzmb9xfg7g4zrqwnfbq1b10banfghydgg6qccj";
    build = "build.rs";
    dependencies = mapFeatures features ([
      (crates."libc"."${deps."backtrace_sys"."0.1.35"."libc"}" deps)
    ]);

    buildDependencies = mapFeatures features ([
      (crates."cc"."${deps."backtrace_sys"."0.1.35"."cc"}" deps)
    ]);
    features = mkFeatures (features."backtrace_sys"."0.1.35" or {});
  };
  features_.backtrace_sys."0.1.35" = deps: f: updateFeatures f (rec {
    backtrace_sys = fold recursiveUpdate {} [
      { "0.1.35"."backtrace-sys" =
        (f.backtrace_sys."0.1.35"."backtrace-sys" or false) ||
        (f.backtrace_sys."0.1.35".default or false) ||
        (backtrace_sys."0.1.35"."default" or false); }
      { "0.1.35"."compiler_builtins" =
        (f.backtrace_sys."0.1.35"."compiler_builtins" or false) ||
        (f.backtrace_sys."0.1.35".rustc-dep-of-std or false) ||
        (backtrace_sys."0.1.35"."rustc-dep-of-std" or false); }
      { "0.1.35"."core" =
        (f.backtrace_sys."0.1.35"."core" or false) ||
        (f.backtrace_sys."0.1.35".rustc-dep-of-std or false) ||
        (backtrace_sys."0.1.35"."rustc-dep-of-std" or false); }
      { "0.1.35".default = (f.backtrace_sys."0.1.35".default or true); }
    ];
    cc."${deps.backtrace_sys."0.1.35".cc}".default = true;
    libc."${deps.backtrace_sys."0.1.35".libc}".default = (f.libc."${deps.backtrace_sys."0.1.35".libc}".default or false);
  }) [
    (features_.libc."${deps."backtrace_sys"."0.1.35"."libc"}" deps)
    (features_.cc."${deps."backtrace_sys"."0.1.35"."cc"}" deps)
  ];


# end
# base64-0.10.1

  crates.base64."0.10.1" = deps: { features?(features_.base64."0.10.1" deps {}) }: buildRustCrate {
    crateName = "base64";
    version = "0.10.1";
    description = "encodes and decodes base64 as bytes or utf8";
    authors = [ "Alice Maz <alice@alicemaz.com>" "Marshall Pierce <marshall@mpierce.org>" ];
    sha256 = "1zz3jq619hahla1f70ra38818b5n8cp4iilij81i90jq6z7hlfhg";
    dependencies = mapFeatures features ([
      (crates."byteorder"."${deps."base64"."0.10.1"."byteorder"}" deps)
    ]);
  };
  features_.base64."0.10.1" = deps: f: updateFeatures f (rec {
    base64."0.10.1".default = (f.base64."0.10.1".default or true);
    byteorder."${deps.base64."0.10.1".byteorder}".default = true;
  }) [
    (features_.byteorder."${deps."base64"."0.10.1"."byteorder"}" deps)
  ];


# end
# bitflags-1.2.1

  crates.bitflags."1.2.1" = deps: { features?(features_.bitflags."1.2.1" deps {}) }: buildRustCrate {
    crateName = "bitflags";
    version = "1.2.1";
    description = "A macro to generate structures which behave like bitflags.\n";
    authors = [ "The Rust Project Developers" ];
    sha256 = "0b77awhpn7yaqjjibm69ginfn996azx5vkzfjj39g3wbsqs7mkxg";
    build = "build.rs";
    features = mkFeatures (features."bitflags"."1.2.1" or {});
  };
  features_.bitflags."1.2.1" = deps: f: updateFeatures f (rec {
    bitflags."1.2.1".default = (f.bitflags."1.2.1".default or true);
  }) [];


# end
# byteorder-1.3.4

  crates.byteorder."1.3.4" = deps: { features?(features_.byteorder."1.3.4" deps {}) }: buildRustCrate {
    crateName = "byteorder";
    version = "1.3.4";
    description = "Library for reading/writing numbers in big-endian and little-endian.";
    authors = [ "Andrew Gallant <jamslam@gmail.com>" ];
    sha256 = "1hi7ixdls5qssw39wgp1gm8d20yjghgawc3m4xr2wkxmxsv08krz";
    build = "build.rs";
    features = mkFeatures (features."byteorder"."1.3.4" or {});
  };
  features_.byteorder."1.3.4" = deps: f: updateFeatures f (rec {
    byteorder = fold recursiveUpdate {} [
      { "1.3.4"."std" =
        (f.byteorder."1.3.4"."std" or false) ||
        (f.byteorder."1.3.4".default or false) ||
        (byteorder."1.3.4"."default" or false); }
      { "1.3.4".default = (f.byteorder."1.3.4".default or true); }
    ];
  }) [];


# end
# bytes-0.5.4

  crates.bytes."0.5.4" = deps: { features?(features_.bytes."0.5.4" deps {}) }: buildRustCrate {
    crateName = "bytes";
    version = "0.5.4";
    description = "Types and traits for working with bytes";
    authors = [ "Carl Lerche <me@carllerche.com>" "Sean McArthur <sean@seanmonstar.com>" ];
    edition = "2018";
    sha256 = "0v7dcwfzya64c65haqydhyhkjk0czfrma14lrm7wkqmz4j4skpwh";
    dependencies = mapFeatures features ([
])
      ++ (if !(kernel == "windows") then mapFeatures features ([
]) else []);
    features = mkFeatures (features."bytes"."0.5.4" or {});
  };
  features_.bytes."0.5.4" = deps: f: updateFeatures f (rec {
    bytes = fold recursiveUpdate {} [
      { "0.5.4"."std" =
        (f.bytes."0.5.4"."std" or false) ||
        (f.bytes."0.5.4".default or false) ||
        (bytes."0.5.4"."default" or false); }
      { "0.5.4".default = (f.bytes."0.5.4".default or true); }
    ];
  }) [];


# end
# cc-1.0.50

  crates.cc."1.0.50" = deps: { features?(features_.cc."1.0.50" deps {}) }: buildRustCrate {
    crateName = "cc";
    version = "1.0.50";
    description = "A build-time dependency for Cargo build scripts to assist in invoking the native\nC compiler to compile native C code into a static archive to be linked into Rust\ncode.\n";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    edition = "2018";
    sha256 = "1di84m338b9c42vfq86g5lyq5s03i0zfvvf59dvb6mr37z063h1d";
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."cc"."1.0.50" or {});
  };
  features_.cc."1.0.50" = deps: f: updateFeatures f (rec {
    cc = fold recursiveUpdate {} [
      { "1.0.50"."jobserver" =
        (f.cc."1.0.50"."jobserver" or false) ||
        (f.cc."1.0.50".parallel or false) ||
        (cc."1.0.50"."parallel" or false); }
      { "1.0.50".default = (f.cc."1.0.50".default or true); }
    ];
  }) [];


# end
# cfg-if-0.1.10

  crates.cfg_if."0.1.10" = deps: { features?(features_.cfg_if."0.1.10" deps {}) }: buildRustCrate {
    crateName = "cfg-if";
    version = "0.1.10";
    description = "A macro to ergonomically define an item depending on a large number of #[cfg]\nparameters. Structured like an if-else chain, the first matching branch is the\nitem that gets emitted.\n";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    edition = "2018";
    sha256 = "0x52qzpbyl2f2jqs7kkqzgfki2cpq99gpfjjigdp8pwwfqk01007";
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."cfg_if"."0.1.10" or {});
  };
  features_.cfg_if."0.1.10" = deps: f: updateFeatures f (rec {
    cfg_if = fold recursiveUpdate {} [
      { "0.1.10"."compiler_builtins" =
        (f.cfg_if."0.1.10"."compiler_builtins" or false) ||
        (f.cfg_if."0.1.10".rustc-dep-of-std or false) ||
        (cfg_if."0.1.10"."rustc-dep-of-std" or false); }
      { "0.1.10"."core" =
        (f.cfg_if."0.1.10"."core" or false) ||
        (f.cfg_if."0.1.10".rustc-dep-of-std or false) ||
        (cfg_if."0.1.10"."rustc-dep-of-std" or false); }
      { "0.1.10".default = (f.cfg_if."0.1.10".default or true); }
    ];
  }) [];


# end
# dtoa-0.4.5

  crates.dtoa."0.4.5" = deps: { features?(features_.dtoa."0.4.5" deps {}) }: buildRustCrate {
    crateName = "dtoa";
    version = "0.4.5";
    description = "Fast functions for printing floating-point primitives to an io::Write";
    authors = [ "David Tolnay <dtolnay@gmail.com>" ];
    sha256 = "15npcbjlkd9wm82x7gf1al7sn4rfd3jqzq5ysiy4qz1wsbrlsghv";
  };
  features_.dtoa."0.4.5" = deps: f: updateFeatures f (rec {
    dtoa."0.4.5".default = (f.dtoa."0.4.5".default or true);
  }) [];


# end
# either-1.5.3

  crates.either."1.5.3" = deps: { features?(features_.either."1.5.3" deps {}) }: buildRustCrate {
    crateName = "either";
    version = "1.5.3";
    description = "The enum `Either` with variants `Left` and `Right` is a general purpose sum type with two cases.\n";
    authors = [ "bluss" ];
    sha256 = "040fgh0jahqra9ascwb986zgll1ss88ky9bfvn0zfay42zsyz83n";
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."either"."1.5.3" or {});
  };
  features_.either."1.5.3" = deps: f: updateFeatures f (rec {
    either = fold recursiveUpdate {} [
      { "1.5.3"."use_std" =
        (f.either."1.5.3"."use_std" or false) ||
        (f.either."1.5.3".default or false) ||
        (either."1.5.3"."default" or false); }
      { "1.5.3".default = (f.either."1.5.3".default or true); }
    ];
  }) [];


# end
# env_logger-0.7.1

  crates.env_logger."0.7.1" = deps: { features?(features_.env_logger."0.7.1" deps {}) }: buildRustCrate {
    crateName = "env_logger";
    version = "0.7.1";
    description = "A logging implementation for `log` which is configured via an environment\nvariable.\n";
    authors = [ "The Rust Project Developers" ];
    edition = "2018";
    sha256 = "1l2ln6l21z2zs4s93svysq3bq0mj9npbwgkwm4540y6dl5chhpak";
    dependencies = mapFeatures features ([
      (crates."log"."${deps."env_logger"."0.7.1"."log"}" deps)
    ]
      ++ (if features.env_logger."0.7.1".atty or false then [ (crates.atty."${deps."env_logger"."0.7.1".atty}" deps) ] else [])
      ++ (if features.env_logger."0.7.1".humantime or false then [ (crates.humantime."${deps."env_logger"."0.7.1".humantime}" deps) ] else [])
      ++ (if features.env_logger."0.7.1".regex or false then [ (crates.regex."${deps."env_logger"."0.7.1".regex}" deps) ] else [])
      ++ (if features.env_logger."0.7.1".termcolor or false then [ (crates.termcolor."${deps."env_logger"."0.7.1".termcolor}" deps) ] else []));
    features = mkFeatures (features."env_logger"."0.7.1" or {});
  };
  features_.env_logger."0.7.1" = deps: f: updateFeatures f (rec {
    atty."${deps.env_logger."0.7.1".atty}".default = true;
    env_logger = fold recursiveUpdate {} [
      { "0.7.1"."atty" =
        (f.env_logger."0.7.1"."atty" or false) ||
        (f.env_logger."0.7.1".default or false) ||
        (env_logger."0.7.1"."default" or false); }
      { "0.7.1"."humantime" =
        (f.env_logger."0.7.1"."humantime" or false) ||
        (f.env_logger."0.7.1".default or false) ||
        (env_logger."0.7.1"."default" or false); }
      { "0.7.1"."regex" =
        (f.env_logger."0.7.1"."regex" or false) ||
        (f.env_logger."0.7.1".default or false) ||
        (env_logger."0.7.1"."default" or false); }
      { "0.7.1"."termcolor" =
        (f.env_logger."0.7.1"."termcolor" or false) ||
        (f.env_logger."0.7.1".default or false) ||
        (env_logger."0.7.1"."default" or false); }
      { "0.7.1".default = (f.env_logger."0.7.1".default or true); }
    ];
    humantime."${deps.env_logger."0.7.1".humantime}".default = true;
    log = fold recursiveUpdate {} [
      { "${deps.env_logger."0.7.1".log}"."std" = true; }
      { "${deps.env_logger."0.7.1".log}".default = true; }
    ];
    regex."${deps.env_logger."0.7.1".regex}".default = true;
    termcolor."${deps.env_logger."0.7.1".termcolor}".default = true;
  }) [
    (features_.atty."${deps."env_logger"."0.7.1"."atty"}" deps)
    (features_.humantime."${deps."env_logger"."0.7.1"."humantime"}" deps)
    (features_.log."${deps."env_logger"."0.7.1"."log"}" deps)
    (features_.regex."${deps."env_logger"."0.7.1"."regex"}" deps)
    (features_.termcolor."${deps."env_logger"."0.7.1"."termcolor"}" deps)
  ];


# end
# failure-0.1.7

  crates.failure."0.1.7" = deps: { features?(features_.failure."0.1.7" deps {}) }: buildRustCrate {
    crateName = "failure";
    version = "0.1.7";
    description = "Experimental error handling abstraction.";
    authors = [ "Without Boats <boats@mozilla.com>" ];
    sha256 = "019ky26smn3fb1k791yx907vh7cjrrl5rfwpwq0jilscivcfcn4i";
    dependencies = mapFeatures features ([
    ]
      ++ (if features.failure."0.1.7".backtrace or false then [ (crates.backtrace."${deps."failure"."0.1.7".backtrace}" deps) ] else [])
      ++ (if features.failure."0.1.7".failure_derive or false then [ (crates.failure_derive."${deps."failure"."0.1.7".failure_derive}" deps) ] else []));
    features = mkFeatures (features."failure"."0.1.7" or {});
  };
  features_.failure."0.1.7" = deps: f: updateFeatures f (rec {
    backtrace."${deps.failure."0.1.7".backtrace}".default = true;
    failure = fold recursiveUpdate {} [
      { "0.1.7"."backtrace" =
        (f.failure."0.1.7"."backtrace" or false) ||
        (f.failure."0.1.7".std or false) ||
        (failure."0.1.7"."std" or false); }
      { "0.1.7"."derive" =
        (f.failure."0.1.7"."derive" or false) ||
        (f.failure."0.1.7".default or false) ||
        (failure."0.1.7"."default" or false); }
      { "0.1.7"."failure_derive" =
        (f.failure."0.1.7"."failure_derive" or false) ||
        (f.failure."0.1.7".derive or false) ||
        (failure."0.1.7"."derive" or false); }
      { "0.1.7"."std" =
        (f.failure."0.1.7"."std" or false) ||
        (f.failure."0.1.7".default or false) ||
        (failure."0.1.7"."default" or false); }
      { "0.1.7".default = (f.failure."0.1.7".default or true); }
    ];
    failure_derive."${deps.failure."0.1.7".failure_derive}".default = true;
  }) [
    (features_.backtrace."${deps."failure"."0.1.7"."backtrace"}" deps)
    (features_.failure_derive."${deps."failure"."0.1.7"."failure_derive"}" deps)
  ];


# end
# failure_derive-0.1.7

  crates.failure_derive."0.1.7" = deps: { features?(features_.failure_derive."0.1.7" deps {}) }: buildRustCrate {
    crateName = "failure_derive";
    version = "0.1.7";
    description = "derives for the failure crate";
    authors = [ "Without Boats <woboats@gmail.com>" ];
    sha256 = "0jmxv0i4f4vkmpk13anqnxf3z0jf69yhaz5s9y375g4cgb5p2vvs";
    procMacro = true;
    build = "build.rs";
    dependencies = mapFeatures features ([
      (crates."proc_macro2"."${deps."failure_derive"."0.1.7"."proc_macro2"}" deps)
      (crates."quote"."${deps."failure_derive"."0.1.7"."quote"}" deps)
      (crates."syn"."${deps."failure_derive"."0.1.7"."syn"}" deps)
      (crates."synstructure"."${deps."failure_derive"."0.1.7"."synstructure"}" deps)
    ]);
    features = mkFeatures (features."failure_derive"."0.1.7" or {});
  };
  features_.failure_derive."0.1.7" = deps: f: updateFeatures f (rec {
    failure_derive."0.1.7".default = (f.failure_derive."0.1.7".default or true);
    proc_macro2."${deps.failure_derive."0.1.7".proc_macro2}".default = true;
    quote."${deps.failure_derive."0.1.7".quote}".default = true;
    syn."${deps.failure_derive."0.1.7".syn}".default = true;
    synstructure."${deps.failure_derive."0.1.7".synstructure}".default = true;
  }) [
    (features_.proc_macro2."${deps."failure_derive"."0.1.7"."proc_macro2"}" deps)
    (features_.quote."${deps."failure_derive"."0.1.7"."quote"}" deps)
    (features_.syn."${deps."failure_derive"."0.1.7"."syn"}" deps)
    (features_.synstructure."${deps."failure_derive"."0.1.7"."synstructure"}" deps)
  ];


# end
# fixedbitset-0.2.0

  crates.fixedbitset."0.2.0" = deps: { features?(features_.fixedbitset."0.2.0" deps {}) }: buildRustCrate {
    crateName = "fixedbitset";
    version = "0.2.0";
    description = "FixedBitSet is a simple bitset collection";
    authors = [ "bluss" ];
    sha256 = "1anwrijr4z3n1l1629c6l9l870pmjhwvwihzady34n6wr706iqf1";
    features = mkFeatures (features."fixedbitset"."0.2.0" or {});
  };
  features_.fixedbitset."0.2.0" = deps: f: updateFeatures f (rec {
    fixedbitset = fold recursiveUpdate {} [
      { "0.2.0"."std" =
        (f.fixedbitset."0.2.0"."std" or false) ||
        (f.fixedbitset."0.2.0".default or false) ||
        (fixedbitset."0.2.0"."default" or false); }
      { "0.2.0".default = (f.fixedbitset."0.2.0".default or true); }
    ];
  }) [];


# end
# fnv-1.0.6

  crates.fnv."1.0.6" = deps: { features?(features_.fnv."1.0.6" deps {}) }: buildRustCrate {
    crateName = "fnv";
    version = "1.0.6";
    description = "Fowler–Noll–Vo hash function";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "128mlh23y3gg6ag5h8iiqlcbl59smisdzraqy88ldrf75kbw27ip";
    libPath = "lib.rs";
  };
  features_.fnv."1.0.6" = deps: f: updateFeatures f (rec {
    fnv."1.0.6".default = (f.fnv."1.0.6".default or true);
  }) [];


# end
# fuchsia-zircon-0.3.3

  crates.fuchsia_zircon."0.3.3" = deps: { features?(features_.fuchsia_zircon."0.3.3" deps {}) }: buildRustCrate {
    crateName = "fuchsia-zircon";
    version = "0.3.3";
    description = "Rust bindings for the Zircon kernel";
    authors = [ "Raph Levien <raph@google.com>" ];
    sha256 = "0jrf4shb1699r4la8z358vri8318w4mdi6qzfqy30p2ymjlca4gk";
    dependencies = mapFeatures features ([
      (crates."bitflags"."${deps."fuchsia_zircon"."0.3.3"."bitflags"}" deps)
      (crates."fuchsia_zircon_sys"."${deps."fuchsia_zircon"."0.3.3"."fuchsia_zircon_sys"}" deps)
    ]);
  };
  features_.fuchsia_zircon."0.3.3" = deps: f: updateFeatures f (rec {
    bitflags."${deps.fuchsia_zircon."0.3.3".bitflags}".default = true;
    fuchsia_zircon."0.3.3".default = (f.fuchsia_zircon."0.3.3".default or true);
    fuchsia_zircon_sys."${deps.fuchsia_zircon."0.3.3".fuchsia_zircon_sys}".default = true;
  }) [
    (features_.bitflags."${deps."fuchsia_zircon"."0.3.3"."bitflags"}" deps)
    (features_.fuchsia_zircon_sys."${deps."fuchsia_zircon"."0.3.3"."fuchsia_zircon_sys"}" deps)
  ];


# end
# fuchsia-zircon-sys-0.3.3

  crates.fuchsia_zircon_sys."0.3.3" = deps: { features?(features_.fuchsia_zircon_sys."0.3.3" deps {}) }: buildRustCrate {
    crateName = "fuchsia-zircon-sys";
    version = "0.3.3";
    description = "Low-level Rust bindings for the Zircon kernel";
    authors = [ "Raph Levien <raph@google.com>" ];
    sha256 = "08jp1zxrm9jbrr6l26bjal4dbm8bxfy57ickdgibsqxr1n9j3hf5";
  };
  features_.fuchsia_zircon_sys."0.3.3" = deps: f: updateFeatures f (rec {
    fuchsia_zircon_sys."0.3.3".default = (f.fuchsia_zircon_sys."0.3.3".default or true);
  }) [];


# end
# futures-0.1.29

  crates.futures."0.1.29" = deps: { features?(features_.futures."0.1.29" deps {}) }: buildRustCrate {
    crateName = "futures";
    version = "0.1.29";
    description = "An implementation of futures and streams featuring zero allocations,\ncomposability, and iterator-like interfaces.\n";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "0zq7ysf5qvdchh3hjrvvv3sx4bflq6mb7b1wzaqsn2c8bbcvjgmp";
    features = mkFeatures (features."futures"."0.1.29" or {});
  };
  features_.futures."0.1.29" = deps: f: updateFeatures f (rec {
    futures = fold recursiveUpdate {} [
      { "0.1.29"."use_std" =
        (f.futures."0.1.29"."use_std" or false) ||
        (f.futures."0.1.29".default or false) ||
        (futures."0.1.29"."default" or false); }
      { "0.1.29"."with-deprecated" =
        (f.futures."0.1.29"."with-deprecated" or false) ||
        (f.futures."0.1.29".default or false) ||
        (futures."0.1.29"."default" or false); }
      { "0.1.29".default = (f.futures."0.1.29".default or true); }
    ];
  }) [];


# end
# futures-0.3.4

  crates.futures."0.3.4" = deps: { features?(features_.futures."0.3.4" deps {}) }: buildRustCrate {
    crateName = "futures";
    version = "0.3.4";
    description = "An implementation of futures and streams featuring zero allocations,\ncomposability, and iterator-like interfaces.\n";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    edition = "2018";
    sha256 = "0x84abzfq22q2n91ki0qxnxj2234vz2l8wriqppw6ycc4p8a0990";
    dependencies = mapFeatures features ([
      (crates."futures_channel"."${deps."futures"."0.3.4"."futures_channel"}" deps)
      (crates."futures_core"."${deps."futures"."0.3.4"."futures_core"}" deps)
      (crates."futures_io"."${deps."futures"."0.3.4"."futures_io"}" deps)
      (crates."futures_sink"."${deps."futures"."0.3.4"."futures_sink"}" deps)
      (crates."futures_task"."${deps."futures"."0.3.4"."futures_task"}" deps)
      (crates."futures_util"."${deps."futures"."0.3.4"."futures_util"}" deps)
    ]
      ++ (if features.futures."0.3.4".futures-executor or false then [ (crates.futures_executor."${deps."futures"."0.3.4".futures_executor}" deps) ] else []));
    features = mkFeatures (features."futures"."0.3.4" or {});
  };
  features_.futures."0.3.4" = deps: f: updateFeatures f (rec {
    futures = fold recursiveUpdate {} [
      { "0.3.4"."alloc" =
        (f.futures."0.3.4"."alloc" or false) ||
        (f.futures."0.3.4".std or false) ||
        (futures."0.3.4"."std" or false); }
      { "0.3.4"."async-await" =
        (f.futures."0.3.4"."async-await" or false) ||
        (f.futures."0.3.4".default or false) ||
        (futures."0.3.4"."default" or false); }
      { "0.3.4"."compat" =
        (f.futures."0.3.4"."compat" or false) ||
        (f.futures."0.3.4".io-compat or false) ||
        (futures."0.3.4"."io-compat" or false); }
      { "0.3.4"."executor" =
        (f.futures."0.3.4"."executor" or false) ||
        (f.futures."0.3.4".default or false) ||
        (futures."0.3.4"."default" or false) ||
        (f.futures."0.3.4".thread-pool or false) ||
        (futures."0.3.4"."thread-pool" or false); }
      { "0.3.4"."std" =
        (f.futures."0.3.4"."std" or false) ||
        (f.futures."0.3.4".compat or false) ||
        (futures."0.3.4"."compat" or false) ||
        (f.futures."0.3.4".default or false) ||
        (futures."0.3.4"."default" or false) ||
        (f.futures."0.3.4".executor or false) ||
        (futures."0.3.4"."executor" or false); }
      { "0.3.4".default = (f.futures."0.3.4".default or true); }
    ];
    futures_channel = fold recursiveUpdate {} [
      { "${deps.futures."0.3.4".futures_channel}"."alloc" =
        (f.futures_channel."${deps.futures."0.3.4".futures_channel}"."alloc" or false) ||
        (futures."0.3.4"."alloc" or false) ||
        (f."futures"."0.3.4"."alloc" or false); }
      { "${deps.futures."0.3.4".futures_channel}"."cfg-target-has-atomic" =
        (f.futures_channel."${deps.futures."0.3.4".futures_channel}"."cfg-target-has-atomic" or false) ||
        (futures."0.3.4"."cfg-target-has-atomic" or false) ||
        (f."futures"."0.3.4"."cfg-target-has-atomic" or false); }
      { "${deps.futures."0.3.4".futures_channel}"."sink" = true; }
      { "${deps.futures."0.3.4".futures_channel}"."unstable" =
        (f.futures_channel."${deps.futures."0.3.4".futures_channel}"."unstable" or false) ||
        (futures."0.3.4"."unstable" or false) ||
        (f."futures"."0.3.4"."unstable" or false); }
      { "${deps.futures."0.3.4".futures_channel}".default = (f.futures_channel."${deps.futures."0.3.4".futures_channel}".default or false); }
    ];
    futures_core = fold recursiveUpdate {} [
      { "${deps.futures."0.3.4".futures_core}"."alloc" =
        (f.futures_core."${deps.futures."0.3.4".futures_core}"."alloc" or false) ||
        (futures."0.3.4"."alloc" or false) ||
        (f."futures"."0.3.4"."alloc" or false); }
      { "${deps.futures."0.3.4".futures_core}"."cfg-target-has-atomic" =
        (f.futures_core."${deps.futures."0.3.4".futures_core}"."cfg-target-has-atomic" or false) ||
        (futures."0.3.4"."cfg-target-has-atomic" or false) ||
        (f."futures"."0.3.4"."cfg-target-has-atomic" or false); }
      { "${deps.futures."0.3.4".futures_core}"."std" =
        (f.futures_core."${deps.futures."0.3.4".futures_core}"."std" or false) ||
        (futures."0.3.4"."std" or false) ||
        (f."futures"."0.3.4"."std" or false); }
      { "${deps.futures."0.3.4".futures_core}"."unstable" =
        (f.futures_core."${deps.futures."0.3.4".futures_core}"."unstable" or false) ||
        (futures."0.3.4"."unstable" or false) ||
        (f."futures"."0.3.4"."unstable" or false); }
      { "${deps.futures."0.3.4".futures_core}".default = (f.futures_core."${deps.futures."0.3.4".futures_core}".default or false); }
    ];
    futures_executor = fold recursiveUpdate {} [
      { "${deps.futures."0.3.4".futures_executor}"."std" =
        (f.futures_executor."${deps.futures."0.3.4".futures_executor}"."std" or false) ||
        (futures."0.3.4"."executor" or false) ||
        (f."futures"."0.3.4"."executor" or false); }
      { "${deps.futures."0.3.4".futures_executor}"."thread-pool" =
        (f.futures_executor."${deps.futures."0.3.4".futures_executor}"."thread-pool" or false) ||
        (futures."0.3.4"."thread-pool" or false) ||
        (f."futures"."0.3.4"."thread-pool" or false); }
      { "${deps.futures."0.3.4".futures_executor}".default = (f.futures_executor."${deps.futures."0.3.4".futures_executor}".default or false); }
    ];
    futures_io = fold recursiveUpdate {} [
      { "${deps.futures."0.3.4".futures_io}"."read-initializer" =
        (f.futures_io."${deps.futures."0.3.4".futures_io}"."read-initializer" or false) ||
        (futures."0.3.4"."read-initializer" or false) ||
        (f."futures"."0.3.4"."read-initializer" or false); }
      { "${deps.futures."0.3.4".futures_io}"."std" =
        (f.futures_io."${deps.futures."0.3.4".futures_io}"."std" or false) ||
        (futures."0.3.4"."std" or false) ||
        (f."futures"."0.3.4"."std" or false); }
      { "${deps.futures."0.3.4".futures_io}"."unstable" =
        (f.futures_io."${deps.futures."0.3.4".futures_io}"."unstable" or false) ||
        (futures."0.3.4"."unstable" or false) ||
        (f."futures"."0.3.4"."unstable" or false); }
      { "${deps.futures."0.3.4".futures_io}".default = (f.futures_io."${deps.futures."0.3.4".futures_io}".default or false); }
    ];
    futures_sink = fold recursiveUpdate {} [
      { "${deps.futures."0.3.4".futures_sink}"."alloc" =
        (f.futures_sink."${deps.futures."0.3.4".futures_sink}"."alloc" or false) ||
        (futures."0.3.4"."alloc" or false) ||
        (f."futures"."0.3.4"."alloc" or false); }
      { "${deps.futures."0.3.4".futures_sink}"."std" =
        (f.futures_sink."${deps.futures."0.3.4".futures_sink}"."std" or false) ||
        (futures."0.3.4"."std" or false) ||
        (f."futures"."0.3.4"."std" or false); }
      { "${deps.futures."0.3.4".futures_sink}".default = (f.futures_sink."${deps.futures."0.3.4".futures_sink}".default or false); }
    ];
    futures_task = fold recursiveUpdate {} [
      { "${deps.futures."0.3.4".futures_task}"."alloc" =
        (f.futures_task."${deps.futures."0.3.4".futures_task}"."alloc" or false) ||
        (futures."0.3.4"."alloc" or false) ||
        (f."futures"."0.3.4"."alloc" or false); }
      { "${deps.futures."0.3.4".futures_task}"."cfg-target-has-atomic" =
        (f.futures_task."${deps.futures."0.3.4".futures_task}"."cfg-target-has-atomic" or false) ||
        (futures."0.3.4"."cfg-target-has-atomic" or false) ||
        (f."futures"."0.3.4"."cfg-target-has-atomic" or false); }
      { "${deps.futures."0.3.4".futures_task}"."std" =
        (f.futures_task."${deps.futures."0.3.4".futures_task}"."std" or false) ||
        (futures."0.3.4"."std" or false) ||
        (f."futures"."0.3.4"."std" or false); }
      { "${deps.futures."0.3.4".futures_task}"."unstable" =
        (f.futures_task."${deps.futures."0.3.4".futures_task}"."unstable" or false) ||
        (futures."0.3.4"."unstable" or false) ||
        (f."futures"."0.3.4"."unstable" or false); }
      { "${deps.futures."0.3.4".futures_task}".default = (f.futures_task."${deps.futures."0.3.4".futures_task}".default or false); }
    ];
    futures_util = fold recursiveUpdate {} [
      { "${deps.futures."0.3.4".futures_util}"."alloc" =
        (f.futures_util."${deps.futures."0.3.4".futures_util}"."alloc" or false) ||
        (futures."0.3.4"."alloc" or false) ||
        (f."futures"."0.3.4"."alloc" or false); }
      { "${deps.futures."0.3.4".futures_util}"."async-await" =
        (f.futures_util."${deps.futures."0.3.4".futures_util}"."async-await" or false) ||
        (futures."0.3.4"."async-await" or false) ||
        (f."futures"."0.3.4"."async-await" or false); }
      { "${deps.futures."0.3.4".futures_util}"."bilock" =
        (f.futures_util."${deps.futures."0.3.4".futures_util}"."bilock" or false) ||
        (futures."0.3.4"."bilock" or false) ||
        (f."futures"."0.3.4"."bilock" or false); }
      { "${deps.futures."0.3.4".futures_util}"."cfg-target-has-atomic" =
        (f.futures_util."${deps.futures."0.3.4".futures_util}"."cfg-target-has-atomic" or false) ||
        (futures."0.3.4"."cfg-target-has-atomic" or false) ||
        (f."futures"."0.3.4"."cfg-target-has-atomic" or false); }
      { "${deps.futures."0.3.4".futures_util}"."compat" =
        (f.futures_util."${deps.futures."0.3.4".futures_util}"."compat" or false) ||
        (futures."0.3.4"."compat" or false) ||
        (f."futures"."0.3.4"."compat" or false); }
      { "${deps.futures."0.3.4".futures_util}"."io-compat" =
        (f.futures_util."${deps.futures."0.3.4".futures_util}"."io-compat" or false) ||
        (futures."0.3.4"."io-compat" or false) ||
        (f."futures"."0.3.4"."io-compat" or false); }
      { "${deps.futures."0.3.4".futures_util}"."read-initializer" =
        (f.futures_util."${deps.futures."0.3.4".futures_util}"."read-initializer" or false) ||
        (futures."0.3.4"."read-initializer" or false) ||
        (f."futures"."0.3.4"."read-initializer" or false); }
      { "${deps.futures."0.3.4".futures_util}"."sink" = true; }
      { "${deps.futures."0.3.4".futures_util}"."std" =
        (f.futures_util."${deps.futures."0.3.4".futures_util}"."std" or false) ||
        (futures."0.3.4"."std" or false) ||
        (f."futures"."0.3.4"."std" or false); }
      { "${deps.futures."0.3.4".futures_util}"."unstable" =
        (f.futures_util."${deps.futures."0.3.4".futures_util}"."unstable" or false) ||
        (futures."0.3.4"."unstable" or false) ||
        (f."futures"."0.3.4"."unstable" or false); }
      { "${deps.futures."0.3.4".futures_util}".default = (f.futures_util."${deps.futures."0.3.4".futures_util}".default or false); }
    ];
  }) [
    (features_.futures_channel."${deps."futures"."0.3.4"."futures_channel"}" deps)
    (features_.futures_core."${deps."futures"."0.3.4"."futures_core"}" deps)
    (features_.futures_executor."${deps."futures"."0.3.4"."futures_executor"}" deps)
    (features_.futures_io."${deps."futures"."0.3.4"."futures_io"}" deps)
    (features_.futures_sink."${deps."futures"."0.3.4"."futures_sink"}" deps)
    (features_.futures_task."${deps."futures"."0.3.4"."futures_task"}" deps)
    (features_.futures_util."${deps."futures"."0.3.4"."futures_util"}" deps)
  ];


# end
# futures-channel-0.3.4

  crates.futures_channel."0.3.4" = deps: { features?(features_.futures_channel."0.3.4" deps {}) }: buildRustCrate {
    crateName = "futures-channel";
    version = "0.3.4";
    description = "Channels for asynchronous communication using futures-rs.\n";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    edition = "2018";
    sha256 = "0y193rdyniid2nzad1mhwhp5a9lplb5my25yw8lwhcfaddqzcfhz";
    dependencies = mapFeatures features ([
      (crates."futures_core"."${deps."futures_channel"."0.3.4"."futures_core"}" deps)
    ]
      ++ (if features.futures_channel."0.3.4".futures-sink or false then [ (crates.futures_sink."${deps."futures_channel"."0.3.4".futures_sink}" deps) ] else []));
    features = mkFeatures (features."futures_channel"."0.3.4" or {});
  };
  features_.futures_channel."0.3.4" = deps: f: updateFeatures f (rec {
    futures_channel = fold recursiveUpdate {} [
      { "0.3.4"."alloc" =
        (f.futures_channel."0.3.4"."alloc" or false) ||
        (f.futures_channel."0.3.4".std or false) ||
        (futures_channel."0.3.4"."std" or false); }
      { "0.3.4"."futures-sink" =
        (f.futures_channel."0.3.4"."futures-sink" or false) ||
        (f.futures_channel."0.3.4".sink or false) ||
        (futures_channel."0.3.4"."sink" or false); }
      { "0.3.4"."std" =
        (f.futures_channel."0.3.4"."std" or false) ||
        (f.futures_channel."0.3.4".default or false) ||
        (futures_channel."0.3.4"."default" or false); }
      { "0.3.4".default = (f.futures_channel."0.3.4".default or true); }
    ];
    futures_core = fold recursiveUpdate {} [
      { "${deps.futures_channel."0.3.4".futures_core}"."alloc" =
        (f.futures_core."${deps.futures_channel."0.3.4".futures_core}"."alloc" or false) ||
        (futures_channel."0.3.4"."alloc" or false) ||
        (f."futures_channel"."0.3.4"."alloc" or false); }
      { "${deps.futures_channel."0.3.4".futures_core}"."cfg-target-has-atomic" =
        (f.futures_core."${deps.futures_channel."0.3.4".futures_core}"."cfg-target-has-atomic" or false) ||
        (futures_channel."0.3.4"."cfg-target-has-atomic" or false) ||
        (f."futures_channel"."0.3.4"."cfg-target-has-atomic" or false); }
      { "${deps.futures_channel."0.3.4".futures_core}"."std" =
        (f.futures_core."${deps.futures_channel."0.3.4".futures_core}"."std" or false) ||
        (futures_channel."0.3.4"."std" or false) ||
        (f."futures_channel"."0.3.4"."std" or false); }
      { "${deps.futures_channel."0.3.4".futures_core}"."unstable" =
        (f.futures_core."${deps.futures_channel."0.3.4".futures_core}"."unstable" or false) ||
        (futures_channel."0.3.4"."unstable" or false) ||
        (f."futures_channel"."0.3.4"."unstable" or false); }
      { "${deps.futures_channel."0.3.4".futures_core}".default = (f.futures_core."${deps.futures_channel."0.3.4".futures_core}".default or false); }
    ];
    futures_sink."${deps.futures_channel."0.3.4".futures_sink}".default = (f.futures_sink."${deps.futures_channel."0.3.4".futures_sink}".default or false);
  }) [
    (features_.futures_core."${deps."futures_channel"."0.3.4"."futures_core"}" deps)
    (features_.futures_sink."${deps."futures_channel"."0.3.4"."futures_sink"}" deps)
  ];


# end
# futures-core-0.3.4

  crates.futures_core."0.3.4" = deps: { features?(features_.futures_core."0.3.4" deps {}) }: buildRustCrate {
    crateName = "futures-core";
    version = "0.3.4";
    description = "The core traits and types in for the `futures` library.\n";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    edition = "2018";
    sha256 = "03046fyq5s9qyfsary392jc1h65vdw4piya5ksnajd21g8ma6kdz";
    features = mkFeatures (features."futures_core"."0.3.4" or {});
  };
  features_.futures_core."0.3.4" = deps: f: updateFeatures f (rec {
    futures_core = fold recursiveUpdate {} [
      { "0.3.4"."alloc" =
        (f.futures_core."0.3.4"."alloc" or false) ||
        (f.futures_core."0.3.4".std or false) ||
        (futures_core."0.3.4"."std" or false); }
      { "0.3.4"."std" =
        (f.futures_core."0.3.4"."std" or false) ||
        (f.futures_core."0.3.4".default or false) ||
        (futures_core."0.3.4"."default" or false); }
      { "0.3.4".default = (f.futures_core."0.3.4".default or true); }
    ];
  }) [];


# end
# futures-executor-0.3.4

  crates.futures_executor."0.3.4" = deps: { features?(features_.futures_executor."0.3.4" deps {}) }: buildRustCrate {
    crateName = "futures-executor";
    version = "0.3.4";
    description = "Executors for asynchronous tasks based on the futures-rs library.\n";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    edition = "2018";
    sha256 = "0q6jf2caqbccpj54041zmziz5ap1l5zvwhq4q46yygpvn8hwkwp9";
    dependencies = mapFeatures features ([
      (crates."futures_core"."${deps."futures_executor"."0.3.4"."futures_core"}" deps)
      (crates."futures_task"."${deps."futures_executor"."0.3.4"."futures_task"}" deps)
      (crates."futures_util"."${deps."futures_executor"."0.3.4"."futures_util"}" deps)
    ]);
    features = mkFeatures (features."futures_executor"."0.3.4" or {});
  };
  features_.futures_executor."0.3.4" = deps: f: updateFeatures f (rec {
    futures_core = fold recursiveUpdate {} [
      { "${deps.futures_executor."0.3.4".futures_core}"."std" =
        (f.futures_core."${deps.futures_executor."0.3.4".futures_core}"."std" or false) ||
        (futures_executor."0.3.4"."std" or false) ||
        (f."futures_executor"."0.3.4"."std" or false); }
      { "${deps.futures_executor."0.3.4".futures_core}".default = (f.futures_core."${deps.futures_executor."0.3.4".futures_core}".default or false); }
    ];
    futures_executor = fold recursiveUpdate {} [
      { "0.3.4"."num_cpus" =
        (f.futures_executor."0.3.4"."num_cpus" or false) ||
        (f.futures_executor."0.3.4".thread-pool or false) ||
        (futures_executor."0.3.4"."thread-pool" or false); }
      { "0.3.4"."std" =
        (f.futures_executor."0.3.4"."std" or false) ||
        (f.futures_executor."0.3.4".default or false) ||
        (futures_executor."0.3.4"."default" or false) ||
        (f.futures_executor."0.3.4".thread-pool or false) ||
        (futures_executor."0.3.4"."thread-pool" or false); }
      { "0.3.4".default = (f.futures_executor."0.3.4".default or true); }
    ];
    futures_task = fold recursiveUpdate {} [
      { "${deps.futures_executor."0.3.4".futures_task}"."std" =
        (f.futures_task."${deps.futures_executor."0.3.4".futures_task}"."std" or false) ||
        (futures_executor."0.3.4"."std" or false) ||
        (f."futures_executor"."0.3.4"."std" or false); }
      { "${deps.futures_executor."0.3.4".futures_task}".default = (f.futures_task."${deps.futures_executor."0.3.4".futures_task}".default or false); }
    ];
    futures_util = fold recursiveUpdate {} [
      { "${deps.futures_executor."0.3.4".futures_util}"."std" =
        (f.futures_util."${deps.futures_executor."0.3.4".futures_util}"."std" or false) ||
        (futures_executor."0.3.4"."std" or false) ||
        (f."futures_executor"."0.3.4"."std" or false); }
      { "${deps.futures_executor."0.3.4".futures_util}".default = (f.futures_util."${deps.futures_executor."0.3.4".futures_util}".default or false); }
    ];
  }) [
    (features_.futures_core."${deps."futures_executor"."0.3.4"."futures_core"}" deps)
    (features_.futures_task."${deps."futures_executor"."0.3.4"."futures_task"}" deps)
    (features_.futures_util."${deps."futures_executor"."0.3.4"."futures_util"}" deps)
  ];


# end
# futures-io-0.3.4

  crates.futures_io."0.3.4" = deps: { features?(features_.futures_io."0.3.4" deps {}) }: buildRustCrate {
    crateName = "futures-io";
    version = "0.3.4";
    description = "The `AsyncRead`, `AsyncWrite`, `AsyncSeek`, and `AsyncBufRead` traits for the futures-rs library.\n";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    edition = "2018";
    sha256 = "0nmhb0lfw5h79qfkklr1hrrvpzz1cdnjq7xqq60qbii71b5mp7qk";
    features = mkFeatures (features."futures_io"."0.3.4" or {});
  };
  features_.futures_io."0.3.4" = deps: f: updateFeatures f (rec {
    futures_io = fold recursiveUpdate {} [
      { "0.3.4"."std" =
        (f.futures_io."0.3.4"."std" or false) ||
        (f.futures_io."0.3.4".default or false) ||
        (futures_io."0.3.4"."default" or false); }
      { "0.3.4".default = (f.futures_io."0.3.4".default or true); }
    ];
  }) [];


# end
# futures-macro-0.3.4

  crates.futures_macro."0.3.4" = deps: { features?(features_.futures_macro."0.3.4" deps {}) }: buildRustCrate {
    crateName = "futures-macro";
    version = "0.3.4";
    description = "The futures-rs procedural macro implementations.\n";
    authors = [ "Taylor Cramer <cramertj@google.com>" "Taiki Endo <te316e89@gmail.com>" ];
    edition = "2018";
    sha256 = "1b2hvhvl5f0haky329kwdlak6rcfinvnv33nxh1p3qczqqk97fqy";
    procMacro = true;
    dependencies = mapFeatures features ([
      (crates."proc_macro_hack"."${deps."futures_macro"."0.3.4"."proc_macro_hack"}" deps)
      (crates."proc_macro2"."${deps."futures_macro"."0.3.4"."proc_macro2"}" deps)
      (crates."quote"."${deps."futures_macro"."0.3.4"."quote"}" deps)
      (crates."syn"."${deps."futures_macro"."0.3.4"."syn"}" deps)
    ]);
  };
  features_.futures_macro."0.3.4" = deps: f: updateFeatures f (rec {
    futures_macro."0.3.4".default = (f.futures_macro."0.3.4".default or true);
    proc_macro2."${deps.futures_macro."0.3.4".proc_macro2}".default = true;
    proc_macro_hack."${deps.futures_macro."0.3.4".proc_macro_hack}".default = true;
    quote."${deps.futures_macro."0.3.4".quote}".default = true;
    syn = fold recursiveUpdate {} [
      { "${deps.futures_macro."0.3.4".syn}"."full" = true; }
      { "${deps.futures_macro."0.3.4".syn}".default = true; }
    ];
  }) [
    (features_.proc_macro_hack."${deps."futures_macro"."0.3.4"."proc_macro_hack"}" deps)
    (features_.proc_macro2."${deps."futures_macro"."0.3.4"."proc_macro2"}" deps)
    (features_.quote."${deps."futures_macro"."0.3.4"."quote"}" deps)
    (features_.syn."${deps."futures_macro"."0.3.4"."syn"}" deps)
  ];


# end
# futures-sink-0.3.4

  crates.futures_sink."0.3.4" = deps: { features?(features_.futures_sink."0.3.4" deps {}) }: buildRustCrate {
    crateName = "futures-sink";
    version = "0.3.4";
    description = "The asynchronous `Sink` trait for the futures-rs library.\n";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    edition = "2018";
    sha256 = "0363cl3srph7xzd01lq8vigh8vyx8g15ha3hv95k3vzcn4nsqdvr";
    features = mkFeatures (features."futures_sink"."0.3.4" or {});
  };
  features_.futures_sink."0.3.4" = deps: f: updateFeatures f (rec {
    futures_sink = fold recursiveUpdate {} [
      { "0.3.4"."alloc" =
        (f.futures_sink."0.3.4"."alloc" or false) ||
        (f.futures_sink."0.3.4".std or false) ||
        (futures_sink."0.3.4"."std" or false); }
      { "0.3.4"."std" =
        (f.futures_sink."0.3.4"."std" or false) ||
        (f.futures_sink."0.3.4".default or false) ||
        (futures_sink."0.3.4"."default" or false); }
      { "0.3.4".default = (f.futures_sink."0.3.4".default or true); }
    ];
  }) [];


# end
# futures-task-0.3.4

  crates.futures_task."0.3.4" = deps: { features?(features_.futures_task."0.3.4" deps {}) }: buildRustCrate {
    crateName = "futures-task";
    version = "0.3.4";
    description = "Tools for working with tasks.\n";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    edition = "2018";
    sha256 = "0xh5apdfk9kna15yiax57601n21x7qrmbqzmf86acv6qwp474z11";
    features = mkFeatures (features."futures_task"."0.3.4" or {});
  };
  features_.futures_task."0.3.4" = deps: f: updateFeatures f (rec {
    futures_task = fold recursiveUpdate {} [
      { "0.3.4"."alloc" =
        (f.futures_task."0.3.4"."alloc" or false) ||
        (f.futures_task."0.3.4".std or false) ||
        (futures_task."0.3.4"."std" or false); }
      { "0.3.4"."std" =
        (f.futures_task."0.3.4"."std" or false) ||
        (f.futures_task."0.3.4".default or false) ||
        (futures_task."0.3.4"."default" or false); }
      { "0.3.4".default = (f.futures_task."0.3.4".default or true); }
    ];
  }) [];


# end
# futures-util-0.3.4

  crates.futures_util."0.3.4" = deps: { features?(features_.futures_util."0.3.4" deps {}) }: buildRustCrate {
    crateName = "futures-util";
    version = "0.3.4";
    description = "Common utilities and extension traits for the futures-rs library.\n";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    edition = "2018";
    sha256 = "0dbra0yqszrp8rfhqr87gayyy5zskikn42sxfsargxzxwa06id4m";
    dependencies = mapFeatures features ([
      (crates."futures_core"."${deps."futures_util"."0.3.4"."futures_core"}" deps)
      (crates."futures_task"."${deps."futures_util"."0.3.4"."futures_task"}" deps)
      (crates."pin_utils"."${deps."futures_util"."0.3.4"."pin_utils"}" deps)
    ]
      ++ (if features.futures_util."0.3.4".futures-channel or false then [ (crates.futures_channel."${deps."futures_util"."0.3.4".futures_channel}" deps) ] else [])
      ++ (if features.futures_util."0.3.4".futures-io or false then [ (crates.futures_io."${deps."futures_util"."0.3.4".futures_io}" deps) ] else [])
      ++ (if features.futures_util."0.3.4".futures-macro or false then [ (crates.futures_macro."${deps."futures_util"."0.3.4".futures_macro}" deps) ] else [])
      ++ (if features.futures_util."0.3.4".futures-sink or false then [ (crates.futures_sink."${deps."futures_util"."0.3.4".futures_sink}" deps) ] else [])
      ++ (if features.futures_util."0.3.4".memchr or false then [ (crates.memchr."${deps."futures_util"."0.3.4".memchr}" deps) ] else [])
      ++ (if features.futures_util."0.3.4".proc-macro-hack or false then [ (crates.proc_macro_hack."${deps."futures_util"."0.3.4".proc_macro_hack}" deps) ] else [])
      ++ (if features.futures_util."0.3.4".proc-macro-nested or false then [ (crates.proc_macro_nested."${deps."futures_util"."0.3.4".proc_macro_nested}" deps) ] else [])
      ++ (if features.futures_util."0.3.4".slab or false then [ (crates.slab."${deps."futures_util"."0.3.4".slab}" deps) ] else []));
    features = mkFeatures (features."futures_util"."0.3.4" or {});
  };
  features_.futures_util."0.3.4" = deps: f: updateFeatures f (rec {
    futures_channel = fold recursiveUpdate {} [
      { "${deps.futures_util."0.3.4".futures_channel}"."std" = true; }
      { "${deps.futures_util."0.3.4".futures_channel}".default = (f.futures_channel."${deps.futures_util."0.3.4".futures_channel}".default or false); }
    ];
    futures_core = fold recursiveUpdate {} [
      { "${deps.futures_util."0.3.4".futures_core}"."alloc" =
        (f.futures_core."${deps.futures_util."0.3.4".futures_core}"."alloc" or false) ||
        (futures_util."0.3.4"."alloc" or false) ||
        (f."futures_util"."0.3.4"."alloc" or false); }
      { "${deps.futures_util."0.3.4".futures_core}"."cfg-target-has-atomic" =
        (f.futures_core."${deps.futures_util."0.3.4".futures_core}"."cfg-target-has-atomic" or false) ||
        (futures_util."0.3.4"."cfg-target-has-atomic" or false) ||
        (f."futures_util"."0.3.4"."cfg-target-has-atomic" or false); }
      { "${deps.futures_util."0.3.4".futures_core}"."std" =
        (f.futures_core."${deps.futures_util."0.3.4".futures_core}"."std" or false) ||
        (futures_util."0.3.4"."std" or false) ||
        (f."futures_util"."0.3.4"."std" or false); }
      { "${deps.futures_util."0.3.4".futures_core}"."unstable" =
        (f.futures_core."${deps.futures_util."0.3.4".futures_core}"."unstable" or false) ||
        (futures_util."0.3.4"."unstable" or false) ||
        (f."futures_util"."0.3.4"."unstable" or false); }
      { "${deps.futures_util."0.3.4".futures_core}".default = (f.futures_core."${deps.futures_util."0.3.4".futures_core}".default or false); }
    ];
    futures_io = fold recursiveUpdate {} [
      { "${deps.futures_util."0.3.4".futures_io}"."read-initializer" =
        (f.futures_io."${deps.futures_util."0.3.4".futures_io}"."read-initializer" or false) ||
        (futures_util."0.3.4"."read-initializer" or false) ||
        (f."futures_util"."0.3.4"."read-initializer" or false); }
      { "${deps.futures_util."0.3.4".futures_io}"."std" = true; }
      { "${deps.futures_util."0.3.4".futures_io}".default = (f.futures_io."${deps.futures_util."0.3.4".futures_io}".default or false); }
    ];
    futures_macro."${deps.futures_util."0.3.4".futures_macro}".default = (f.futures_macro."${deps.futures_util."0.3.4".futures_macro}".default or false);
    futures_sink."${deps.futures_util."0.3.4".futures_sink}".default = (f.futures_sink."${deps.futures_util."0.3.4".futures_sink}".default or false);
    futures_task = fold recursiveUpdate {} [
      { "${deps.futures_util."0.3.4".futures_task}"."alloc" =
        (f.futures_task."${deps.futures_util."0.3.4".futures_task}"."alloc" or false) ||
        (futures_util."0.3.4"."alloc" or false) ||
        (f."futures_util"."0.3.4"."alloc" or false); }
      { "${deps.futures_util."0.3.4".futures_task}"."cfg-target-has-atomic" =
        (f.futures_task."${deps.futures_util."0.3.4".futures_task}"."cfg-target-has-atomic" or false) ||
        (futures_util."0.3.4"."cfg-target-has-atomic" or false) ||
        (f."futures_util"."0.3.4"."cfg-target-has-atomic" or false); }
      { "${deps.futures_util."0.3.4".futures_task}"."std" =
        (f.futures_task."${deps.futures_util."0.3.4".futures_task}"."std" or false) ||
        (futures_util."0.3.4"."std" or false) ||
        (f."futures_util"."0.3.4"."std" or false); }
      { "${deps.futures_util."0.3.4".futures_task}"."unstable" =
        (f.futures_task."${deps.futures_util."0.3.4".futures_task}"."unstable" or false) ||
        (futures_util."0.3.4"."unstable" or false) ||
        (f."futures_util"."0.3.4"."unstable" or false); }
      { "${deps.futures_util."0.3.4".futures_task}".default = (f.futures_task."${deps.futures_util."0.3.4".futures_task}".default or false); }
    ];
    futures_util = fold recursiveUpdate {} [
      { "0.3.4"."alloc" =
        (f.futures_util."0.3.4"."alloc" or false) ||
        (f.futures_util."0.3.4".std or false) ||
        (futures_util."0.3.4"."std" or false); }
      { "0.3.4"."async-await" =
        (f.futures_util."0.3.4"."async-await" or false) ||
        (f.futures_util."0.3.4".async-await-macro or false) ||
        (futures_util."0.3.4"."async-await-macro" or false) ||
        (f.futures_util."0.3.4".default or false) ||
        (futures_util."0.3.4"."default" or false); }
      { "0.3.4"."async-await-macro" =
        (f.futures_util."0.3.4"."async-await-macro" or false) ||
        (f.futures_util."0.3.4".default or false) ||
        (futures_util."0.3.4"."default" or false); }
      { "0.3.4"."compat" =
        (f.futures_util."0.3.4"."compat" or false) ||
        (f.futures_util."0.3.4".io-compat or false) ||
        (futures_util."0.3.4"."io-compat" or false); }
      { "0.3.4"."futures-channel" =
        (f.futures_util."0.3.4"."futures-channel" or false) ||
        (f.futures_util."0.3.4".channel or false) ||
        (futures_util."0.3.4"."channel" or false); }
      { "0.3.4"."futures-io" =
        (f.futures_util."0.3.4"."futures-io" or false) ||
        (f.futures_util."0.3.4".io or false) ||
        (futures_util."0.3.4"."io" or false); }
      { "0.3.4"."futures-macro" =
        (f.futures_util."0.3.4"."futures-macro" or false) ||
        (f.futures_util."0.3.4".async-await-macro or false) ||
        (futures_util."0.3.4"."async-await-macro" or false); }
      { "0.3.4"."futures-sink" =
        (f.futures_util."0.3.4"."futures-sink" or false) ||
        (f.futures_util."0.3.4".sink or false) ||
        (futures_util."0.3.4"."sink" or false); }
      { "0.3.4"."futures_01" =
        (f.futures_util."0.3.4"."futures_01" or false) ||
        (f.futures_util."0.3.4".compat or false) ||
        (futures_util."0.3.4"."compat" or false); }
      { "0.3.4"."io" =
        (f.futures_util."0.3.4"."io" or false) ||
        (f.futures_util."0.3.4".io-compat or false) ||
        (futures_util."0.3.4"."io-compat" or false) ||
        (f.futures_util."0.3.4".read-initializer or false) ||
        (futures_util."0.3.4"."read-initializer" or false); }
      { "0.3.4"."memchr" =
        (f.futures_util."0.3.4"."memchr" or false) ||
        (f.futures_util."0.3.4".io or false) ||
        (futures_util."0.3.4"."io" or false); }
      { "0.3.4"."proc-macro-hack" =
        (f.futures_util."0.3.4"."proc-macro-hack" or false) ||
        (f.futures_util."0.3.4".async-await-macro or false) ||
        (futures_util."0.3.4"."async-await-macro" or false); }
      { "0.3.4"."proc-macro-nested" =
        (f.futures_util."0.3.4"."proc-macro-nested" or false) ||
        (f.futures_util."0.3.4".async-await-macro or false) ||
        (futures_util."0.3.4"."async-await-macro" or false); }
      { "0.3.4"."slab" =
        (f.futures_util."0.3.4"."slab" or false) ||
        (f.futures_util."0.3.4".std or false) ||
        (futures_util."0.3.4"."std" or false); }
      { "0.3.4"."std" =
        (f.futures_util."0.3.4"."std" or false) ||
        (f.futures_util."0.3.4".channel or false) ||
        (futures_util."0.3.4"."channel" or false) ||
        (f.futures_util."0.3.4".compat or false) ||
        (futures_util."0.3.4"."compat" or false) ||
        (f.futures_util."0.3.4".default or false) ||
        (futures_util."0.3.4"."default" or false) ||
        (f.futures_util."0.3.4".io or false) ||
        (futures_util."0.3.4"."io" or false); }
      { "0.3.4"."tokio-io" =
        (f.futures_util."0.3.4"."tokio-io" or false) ||
        (f.futures_util."0.3.4".io-compat or false) ||
        (futures_util."0.3.4"."io-compat" or false); }
      { "0.3.4".default = (f.futures_util."0.3.4".default or true); }
    ];
    memchr."${deps.futures_util."0.3.4".memchr}".default = true;
    pin_utils."${deps.futures_util."0.3.4".pin_utils}".default = true;
    proc_macro_hack."${deps.futures_util."0.3.4".proc_macro_hack}".default = true;
    proc_macro_nested."${deps.futures_util."0.3.4".proc_macro_nested}".default = true;
    slab."${deps.futures_util."0.3.4".slab}".default = true;
  }) [
    (features_.futures_channel."${deps."futures_util"."0.3.4"."futures_channel"}" deps)
    (features_.futures_core."${deps."futures_util"."0.3.4"."futures_core"}" deps)
    (features_.futures_io."${deps."futures_util"."0.3.4"."futures_io"}" deps)
    (features_.futures_macro."${deps."futures_util"."0.3.4"."futures_macro"}" deps)
    (features_.futures_sink."${deps."futures_util"."0.3.4"."futures_sink"}" deps)
    (features_.futures_task."${deps."futures_util"."0.3.4"."futures_task"}" deps)
    (features_.memchr."${deps."futures_util"."0.3.4"."memchr"}" deps)
    (features_.pin_utils."${deps."futures_util"."0.3.4"."pin_utils"}" deps)
    (features_.proc_macro_hack."${deps."futures_util"."0.3.4"."proc_macro_hack"}" deps)
    (features_.proc_macro_nested."${deps."futures_util"."0.3.4"."proc_macro_nested"}" deps)
    (features_.slab."${deps."futures_util"."0.3.4"."slab"}" deps)
  ];


# end
# getrandom-0.1.14

  crates.getrandom."0.1.14" = deps: { features?(features_.getrandom."0.1.14" deps {}) }: buildRustCrate {
    crateName = "getrandom";
    version = "0.1.14";
    description = "A small cross-platform library for retrieving random data from system source";
    authors = [ "The Rand Project Developers" ];
    edition = "2018";
    sha256 = "1i6r4q7i24zdy6v5h3l966a1cf8a1aip2fi1pmdsi71sk1m3w7wr";
    dependencies = mapFeatures features ([
      (crates."cfg_if"."${deps."getrandom"."0.1.14"."cfg_if"}" deps)
    ])
      ++ (if kernel == "wasi" then mapFeatures features ([
      (crates."wasi"."${deps."getrandom"."0.1.14"."wasi"}" deps)
    ]) else [])
      ++ (if (kernel == "linux" || kernel == "darwin") then mapFeatures features ([
      (crates."libc"."${deps."getrandom"."0.1.14"."libc"}" deps)
    ]) else [])
      ++ (if kernel == "wasm32-unknown-unknown" then mapFeatures features ([
]) else []);
    features = mkFeatures (features."getrandom"."0.1.14" or {});
  };
  features_.getrandom."0.1.14" = deps: f: updateFeatures f (rec {
    cfg_if."${deps.getrandom."0.1.14".cfg_if}".default = true;
    getrandom = fold recursiveUpdate {} [
      { "0.1.14"."compiler_builtins" =
        (f.getrandom."0.1.14"."compiler_builtins" or false) ||
        (f.getrandom."0.1.14".rustc-dep-of-std or false) ||
        (getrandom."0.1.14"."rustc-dep-of-std" or false); }
      { "0.1.14"."core" =
        (f.getrandom."0.1.14"."core" or false) ||
        (f.getrandom."0.1.14".rustc-dep-of-std or false) ||
        (getrandom."0.1.14"."rustc-dep-of-std" or false); }
      { "0.1.14"."wasm-bindgen" =
        (f.getrandom."0.1.14"."wasm-bindgen" or false) ||
        (f.getrandom."0.1.14".test-in-browser or false) ||
        (getrandom."0.1.14"."test-in-browser" or false); }
      { "0.1.14".default = (f.getrandom."0.1.14".default or true); }
    ];
    libc."${deps.getrandom."0.1.14".libc}".default = (f.libc."${deps.getrandom."0.1.14".libc}".default or false);
    wasi."${deps.getrandom."0.1.14".wasi}".default = true;
  }) [
    (features_.cfg_if."${deps."getrandom"."0.1.14"."cfg_if"}" deps)
    (features_.wasi."${deps."getrandom"."0.1.14"."wasi"}" deps)
    (features_.libc."${deps."getrandom"."0.1.14"."libc"}" deps)
  ];


# end
# h2-0.2.2

  crates.h2."0.2.2" = deps: { features?(features_.h2."0.2.2" deps {}) }: buildRustCrate {
    crateName = "h2";
    version = "0.2.2";
    description = "An HTTP/2.0 client and server";
    authors = [ "Carl Lerche <me@carllerche.com>" "Sean McArthur <sean@seanmonstar.com>" ];
    edition = "2018";
    sha256 = "1p4al8zsacjk79cfrq6iy7c3wh8wawz052klrjyspar4vbig4wng";
    dependencies = mapFeatures features ([
      (crates."bytes"."${deps."h2"."0.2.2"."bytes"}" deps)
      (crates."fnv"."${deps."h2"."0.2.2"."fnv"}" deps)
      (crates."futures_core"."${deps."h2"."0.2.2"."futures_core"}" deps)
      (crates."futures_sink"."${deps."h2"."0.2.2"."futures_sink"}" deps)
      (crates."futures_util"."${deps."h2"."0.2.2"."futures_util"}" deps)
      (crates."http"."${deps."h2"."0.2.2"."http"}" deps)
      (crates."indexmap"."${deps."h2"."0.2.2"."indexmap"}" deps)
      (crates."log"."${deps."h2"."0.2.2"."log"}" deps)
      (crates."slab"."${deps."h2"."0.2.2"."slab"}" deps)
      (crates."tokio"."${deps."h2"."0.2.2"."tokio"}" deps)
      (crates."tokio_util"."${deps."h2"."0.2.2"."tokio_util"}" deps)
    ]);
    features = mkFeatures (features."h2"."0.2.2" or {});
  };
  features_.h2."0.2.2" = deps: f: updateFeatures f (rec {
    bytes."${deps.h2."0.2.2".bytes}".default = true;
    fnv."${deps.h2."0.2.2".fnv}".default = true;
    futures_core."${deps.h2."0.2.2".futures_core}".default = (f.futures_core."${deps.h2."0.2.2".futures_core}".default or false);
    futures_sink."${deps.h2."0.2.2".futures_sink}".default = (f.futures_sink."${deps.h2."0.2.2".futures_sink}".default or false);
    futures_util."${deps.h2."0.2.2".futures_util}".default = (f.futures_util."${deps.h2."0.2.2".futures_util}".default or false);
    h2."0.2.2".default = (f.h2."0.2.2".default or true);
    http."${deps.h2."0.2.2".http}".default = true;
    indexmap."${deps.h2."0.2.2".indexmap}".default = true;
    log."${deps.h2."0.2.2".log}".default = true;
    slab."${deps.h2."0.2.2".slab}".default = true;
    tokio = fold recursiveUpdate {} [
      { "${deps.h2."0.2.2".tokio}"."io-util" = true; }
      { "${deps.h2."0.2.2".tokio}"."sync" = true; }
      { "${deps.h2."0.2.2".tokio}".default = true; }
    ];
    tokio_util = fold recursiveUpdate {} [
      { "${deps.h2."0.2.2".tokio_util}"."codec" = true; }
      { "${deps.h2."0.2.2".tokio_util}".default = true; }
    ];
  }) [
    (features_.bytes."${deps."h2"."0.2.2"."bytes"}" deps)
    (features_.fnv."${deps."h2"."0.2.2"."fnv"}" deps)
    (features_.futures_core."${deps."h2"."0.2.2"."futures_core"}" deps)
    (features_.futures_sink."${deps."h2"."0.2.2"."futures_sink"}" deps)
    (features_.futures_util."${deps."h2"."0.2.2"."futures_util"}" deps)
    (features_.http."${deps."h2"."0.2.2"."http"}" deps)
    (features_.indexmap."${deps."h2"."0.2.2"."indexmap"}" deps)
    (features_.log."${deps."h2"."0.2.2"."log"}" deps)
    (features_.slab."${deps."h2"."0.2.2"."slab"}" deps)
    (features_.tokio."${deps."h2"."0.2.2"."tokio"}" deps)
    (features_.tokio_util."${deps."h2"."0.2.2"."tokio_util"}" deps)
  ];


# end
# heck-0.3.1

  crates.heck."0.3.1" = deps: { features?(features_.heck."0.3.1" deps {}) }: buildRustCrate {
    crateName = "heck";
    version = "0.3.1";
    description = "heck is a case conversion library.";
    authors = [ "Without Boats <woboats@gmail.com>" ];
    sha256 = "1q7vmnlh62kls6cvkfhbcacxkawaznaqa5wwm9dg1xkcza846c3d";
    dependencies = mapFeatures features ([
      (crates."unicode_segmentation"."${deps."heck"."0.3.1"."unicode_segmentation"}" deps)
    ]);
  };
  features_.heck."0.3.1" = deps: f: updateFeatures f (rec {
    heck."0.3.1".default = (f.heck."0.3.1".default or true);
    unicode_segmentation."${deps.heck."0.3.1".unicode_segmentation}".default = true;
  }) [
    (features_.unicode_segmentation."${deps."heck"."0.3.1"."unicode_segmentation"}" deps)
  ];


# end
# hermit-abi-0.1.8

  crates.hermit_abi."0.1.8" = deps: { features?(features_.hermit_abi."0.1.8" deps {}) }: buildRustCrate {
    crateName = "hermit-abi";
    version = "0.1.8";
    description = "hermit-abi is small interface to call functions from the unikernel RustyHermit.\nIt is used to build the target `x86_64-unknown-hermit`.\n";
    authors = [ "Stefan Lankes" ];
    sha256 = "1298mrpr19rabpx8a6p6gpiws2nwwdhj4jg0zxd5wim42s7hawr5";
    dependencies = mapFeatures features ([
      (crates."libc"."${deps."hermit_abi"."0.1.8"."libc"}" deps)
    ]);
    features = mkFeatures (features."hermit_abi"."0.1.8" or {});
  };
  features_.hermit_abi."0.1.8" = deps: f: updateFeatures f (rec {
    hermit_abi = fold recursiveUpdate {} [
      { "0.1.8"."core" =
        (f.hermit_abi."0.1.8"."core" or false) ||
        (f.hermit_abi."0.1.8".rustc-dep-of-std or false) ||
        (hermit_abi."0.1.8"."rustc-dep-of-std" or false); }
      { "0.1.8".default = (f.hermit_abi."0.1.8".default or true); }
    ];
    libc = fold recursiveUpdate {} [
      { "${deps.hermit_abi."0.1.8".libc}"."rustc-dep-of-std" =
        (f.libc."${deps.hermit_abi."0.1.8".libc}"."rustc-dep-of-std" or false) ||
        (hermit_abi."0.1.8"."rustc-dep-of-std" or false) ||
        (f."hermit_abi"."0.1.8"."rustc-dep-of-std" or false); }
      { "${deps.hermit_abi."0.1.8".libc}".default = (f.libc."${deps.hermit_abi."0.1.8".libc}".default or false); }
    ];
  }) [
    (features_.libc."${deps."hermit_abi"."0.1.8"."libc"}" deps)
  ];


# end
# hostname-0.3.1

  crates.hostname."0.3.1" = deps: { features?(features_.hostname."0.3.1" deps {}) }: buildRustCrate {
    crateName = "hostname";
    version = "0.3.1";
    description = "Cross-platform system's host name functions";
    authors = [ "fengcen <fengcen.love@gmail.com>" "svartalf <self@svartalf.info>" ];
    sha256 = "0m24c9pjyqqv94iicg39qy4j4z4554kjd9am44301v8qkmcl0xyp";
    dependencies = mapFeatures features ([
      (crates."match_cfg"."${deps."hostname"."0.3.1"."match_cfg"}" deps)
    ])
      ++ (if (kernel == "linux" || kernel == "darwin") || kernel == "redox" then mapFeatures features ([
      (crates."libc"."${deps."hostname"."0.3.1"."libc"}" deps)
    ]) else [])
      ++ (if kernel == "windows" then mapFeatures features ([
      (crates."winapi"."${deps."hostname"."0.3.1"."winapi"}" deps)
    ]) else []);
    features = mkFeatures (features."hostname"."0.3.1" or {});
  };
  features_.hostname."0.3.1" = deps: f: updateFeatures f (rec {
    hostname."0.3.1".default = (f.hostname."0.3.1".default or true);
    libc."${deps.hostname."0.3.1".libc}".default = true;
    match_cfg."${deps.hostname."0.3.1".match_cfg}".default = true;
    winapi = fold recursiveUpdate {} [
      { "${deps.hostname."0.3.1".winapi}"."sysinfoapi" = true; }
      { "${deps.hostname."0.3.1".winapi}".default = true; }
    ];
  }) [
    (features_.match_cfg."${deps."hostname"."0.3.1"."match_cfg"}" deps)
    (features_.libc."${deps."hostname"."0.3.1"."libc"}" deps)
    (features_.winapi."${deps."hostname"."0.3.1"."winapi"}" deps)
  ];


# end
# hound-3.4.0

  crates.hound."3.4.0" = deps: { features?(features_.hound."3.4.0" deps {}) }: buildRustCrate {
    crateName = "hound";
    version = "3.4.0";
    description = "A wav encoding and decoding library";
    authors = [ "Ruud van Asseldonk <dev@veniogames.com>" ];
    sha256 = "1jc1ykq1aayh50bl1jk3cywpw26m99jpgv8dc39492h5zifsjqzk";
  };
  features_.hound."3.4.0" = deps: f: updateFeatures f (rec {
    hound."3.4.0".default = (f.hound."3.4.0".default or true);
  }) [];


# end
# http-0.2.0

  crates.http."0.2.0" = deps: { features?(features_.http."0.2.0" deps {}) }: buildRustCrate {
    crateName = "http";
    version = "0.2.0";
    description = "A set of types for representing HTTP requests and responses.\n";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" "Carl Lerche <me@carllerche.com>" "Sean McArthur <sean@seanmonstar.com>" ];
    edition = "2018";
    sha256 = "0n2nk147bscbgs02rmfzlfwbyq5rlc2xwbw39v0p4hsprra16clz";
    dependencies = mapFeatures features ([
      (crates."bytes"."${deps."http"."0.2.0"."bytes"}" deps)
      (crates."fnv"."${deps."http"."0.2.0"."fnv"}" deps)
      (crates."itoa"."${deps."http"."0.2.0"."itoa"}" deps)
    ]);
  };
  features_.http."0.2.0" = deps: f: updateFeatures f (rec {
    bytes."${deps.http."0.2.0".bytes}".default = true;
    fnv."${deps.http."0.2.0".fnv}".default = true;
    http."0.2.0".default = (f.http."0.2.0".default or true);
    itoa."${deps.http."0.2.0".itoa}".default = true;
  }) [
    (features_.bytes."${deps."http"."0.2.0"."bytes"}" deps)
    (features_.fnv."${deps."http"."0.2.0"."fnv"}" deps)
    (features_.itoa."${deps."http"."0.2.0"."itoa"}" deps)
  ];


# end
# http-body-0.3.1

  crates.http_body."0.3.1" = deps: { features?(features_.http_body."0.3.1" deps {}) }: buildRustCrate {
    crateName = "http-body";
    version = "0.3.1";
    description = "Trait representing an asynchronous, streaming, HTTP request or response body.\n";
    authors = [ "Carl Lerche <me@carllerche.com>" "Lucio Franco <luciofranco14@gmail.com>" "Sean McArthur <sean@seanmonstar.com>" ];
    edition = "2018";
    sha256 = "179g14kk0fjhnanr0ah1dkvjwwxi1lbcxsczhkph2jyc847cnzd0";
    dependencies = mapFeatures features ([
      (crates."bytes"."${deps."http_body"."0.3.1"."bytes"}" deps)
      (crates."http"."${deps."http_body"."0.3.1"."http"}" deps)
    ]);
  };
  features_.http_body."0.3.1" = deps: f: updateFeatures f (rec {
    bytes."${deps.http_body."0.3.1".bytes}".default = true;
    http."${deps.http_body."0.3.1".http}".default = true;
    http_body."0.3.1".default = (f.http_body."0.3.1".default or true);
  }) [
    (features_.bytes."${deps."http_body"."0.3.1"."bytes"}" deps)
    (features_.http."${deps."http_body"."0.3.1"."http"}" deps)
  ];


# end
# httparse-1.3.4

  crates.httparse."1.3.4" = deps: { features?(features_.httparse."1.3.4" deps {}) }: buildRustCrate {
    crateName = "httparse";
    version = "1.3.4";
    description = "A tiny, safe, speedy, zero-copy HTTP/1.x parser.";
    authors = [ "Sean McArthur <sean@seanmonstar.com>" ];
    sha256 = "0dggj4s0cq69bn63q9nqzzay5acmwl33nrbhjjsh5xys8sk2x4jw";
    build = "build.rs";
    features = mkFeatures (features."httparse"."1.3.4" or {});
  };
  features_.httparse."1.3.4" = deps: f: updateFeatures f (rec {
    httparse = fold recursiveUpdate {} [
      { "1.3.4"."std" =
        (f.httparse."1.3.4"."std" or false) ||
        (f.httparse."1.3.4".default or false) ||
        (httparse."1.3.4"."default" or false); }
      { "1.3.4".default = (f.httparse."1.3.4".default or true); }
    ];
  }) [];


# end
# humantime-1.3.0

  crates.humantime."1.3.0" = deps: { features?(features_.humantime."1.3.0" deps {}) }: buildRustCrate {
    crateName = "humantime";
    version = "1.3.0";
    description = "    A parser and formatter for std::time::{Duration, SystemTime}\n";
    authors = [ "Paul Colomiets <paul@colomiets.name>" ];
    sha256 = "1y7q207gg33jr5rnlnb0h08k00i54g9fypf3drjk8g1sq2swn92r";
    libPath = "src/lib.rs";
    dependencies = mapFeatures features ([
      (crates."quick_error"."${deps."humantime"."1.3.0"."quick_error"}" deps)
    ]);
  };
  features_.humantime."1.3.0" = deps: f: updateFeatures f (rec {
    humantime."1.3.0".default = (f.humantime."1.3.0".default or true);
    quick_error."${deps.humantime."1.3.0".quick_error}".default = true;
  }) [
    (features_.quick_error."${deps."humantime"."1.3.0"."quick_error"}" deps)
  ];


# end
# hyper-0.13.4

  crates.hyper."0.13.4" = deps: { features?(features_.hyper."0.13.4" deps {}) }: buildRustCrate {
    crateName = "hyper";
    version = "0.13.4";
    description = "A fast and correct HTTP library.";
    authors = [ "Sean McArthur <sean@seanmonstar.com>" ];
    edition = "2018";
    sha256 = "1556mfxbmn99vhc08pqmgfvz44j9scpxxl5bsph8mg64zd3gcdyc";
    dependencies = mapFeatures features ([
      (crates."bytes"."${deps."hyper"."0.13.4"."bytes"}" deps)
      (crates."futures_channel"."${deps."hyper"."0.13.4"."futures_channel"}" deps)
      (crates."futures_core"."${deps."hyper"."0.13.4"."futures_core"}" deps)
      (crates."futures_util"."${deps."hyper"."0.13.4"."futures_util"}" deps)
      (crates."h2"."${deps."hyper"."0.13.4"."h2"}" deps)
      (crates."http"."${deps."hyper"."0.13.4"."http"}" deps)
      (crates."http_body"."${deps."hyper"."0.13.4"."http_body"}" deps)
      (crates."httparse"."${deps."hyper"."0.13.4"."httparse"}" deps)
      (crates."itoa"."${deps."hyper"."0.13.4"."itoa"}" deps)
      (crates."log"."${deps."hyper"."0.13.4"."log"}" deps)
      (crates."pin_project"."${deps."hyper"."0.13.4"."pin_project"}" deps)
      (crates."time"."${deps."hyper"."0.13.4"."time"}" deps)
      (crates."tokio"."${deps."hyper"."0.13.4"."tokio"}" deps)
      (crates."tower_service"."${deps."hyper"."0.13.4"."tower_service"}" deps)
      (crates."want"."${deps."hyper"."0.13.4"."want"}" deps)
    ]
      ++ (if features.hyper."0.13.4".net2 or false then [ (crates.net2."${deps."hyper"."0.13.4".net2}" deps) ] else []));
    features = mkFeatures (features."hyper"."0.13.4" or {});
  };
  features_.hyper."0.13.4" = deps: f: updateFeatures f (rec {
    bytes."${deps.hyper."0.13.4".bytes}".default = true;
    futures_channel."${deps.hyper."0.13.4".futures_channel}".default = true;
    futures_core."${deps.hyper."0.13.4".futures_core}".default = (f.futures_core."${deps.hyper."0.13.4".futures_core}".default or false);
    futures_util."${deps.hyper."0.13.4".futures_util}".default = (f.futures_util."${deps.hyper."0.13.4".futures_util}".default or false);
    h2."${deps.hyper."0.13.4".h2}".default = true;
    http."${deps.hyper."0.13.4".http}".default = true;
    http_body."${deps.hyper."0.13.4".http_body}".default = true;
    httparse."${deps.hyper."0.13.4".httparse}".default = true;
    hyper = fold recursiveUpdate {} [
      { "0.13.4"."net2" =
        (f.hyper."0.13.4"."net2" or false) ||
        (f.hyper."0.13.4".tcp or false) ||
        (hyper."0.13.4"."tcp" or false); }
      { "0.13.4"."runtime" =
        (f.hyper."0.13.4"."runtime" or false) ||
        (f.hyper."0.13.4".default or false) ||
        (hyper."0.13.4"."default" or false); }
      { "0.13.4"."stream" =
        (f.hyper."0.13.4"."stream" or false) ||
        (f.hyper."0.13.4".default or false) ||
        (hyper."0.13.4"."default" or false); }
      { "0.13.4"."tcp" =
        (f.hyper."0.13.4"."tcp" or false) ||
        (f.hyper."0.13.4".runtime or false) ||
        (hyper."0.13.4"."runtime" or false); }
      { "0.13.4".default = (f.hyper."0.13.4".default or true); }
    ];
    itoa."${deps.hyper."0.13.4".itoa}".default = true;
    log."${deps.hyper."0.13.4".log}".default = true;
    net2."${deps.hyper."0.13.4".net2}".default = true;
    pin_project."${deps.hyper."0.13.4".pin_project}".default = true;
    time."${deps.hyper."0.13.4".time}".default = true;
    tokio = fold recursiveUpdate {} [
      { "${deps.hyper."0.13.4".tokio}"."blocking" =
        (f.tokio."${deps.hyper."0.13.4".tokio}"."blocking" or false) ||
        (hyper."0.13.4"."tcp" or false) ||
        (f."hyper"."0.13.4"."tcp" or false); }
      { "${deps.hyper."0.13.4".tokio}"."rt-core" =
        (f.tokio."${deps.hyper."0.13.4".tokio}"."rt-core" or false) ||
        (hyper."0.13.4"."runtime" or false) ||
        (f."hyper"."0.13.4"."runtime" or false); }
      { "${deps.hyper."0.13.4".tokio}"."sync" = true; }
      { "${deps.hyper."0.13.4".tokio}".default = true; }
    ];
    tower_service."${deps.hyper."0.13.4".tower_service}".default = true;
    want."${deps.hyper."0.13.4".want}".default = true;
  }) [
    (features_.bytes."${deps."hyper"."0.13.4"."bytes"}" deps)
    (features_.futures_channel."${deps."hyper"."0.13.4"."futures_channel"}" deps)
    (features_.futures_core."${deps."hyper"."0.13.4"."futures_core"}" deps)
    (features_.futures_util."${deps."hyper"."0.13.4"."futures_util"}" deps)
    (features_.h2."${deps."hyper"."0.13.4"."h2"}" deps)
    (features_.http."${deps."hyper"."0.13.4"."http"}" deps)
    (features_.http_body."${deps."hyper"."0.13.4"."http_body"}" deps)
    (features_.httparse."${deps."hyper"."0.13.4"."httparse"}" deps)
    (features_.itoa."${deps."hyper"."0.13.4"."itoa"}" deps)
    (features_.log."${deps."hyper"."0.13.4"."log"}" deps)
    (features_.net2."${deps."hyper"."0.13.4"."net2"}" deps)
    (features_.pin_project."${deps."hyper"."0.13.4"."pin_project"}" deps)
    (features_.time."${deps."hyper"."0.13.4"."time"}" deps)
    (features_.tokio."${deps."hyper"."0.13.4"."tokio"}" deps)
    (features_.tower_service."${deps."hyper"."0.13.4"."tower_service"}" deps)
    (features_.want."${deps."hyper"."0.13.4"."want"}" deps)
  ];


# end
# indexmap-1.3.2

  crates.indexmap."1.3.2" = deps: { features?(features_.indexmap."1.3.2" deps {}) }: buildRustCrate {
    crateName = "indexmap";
    version = "1.3.2";
    description = "A hash table with consistent order and fast iteration.\n\nThe indexmap is a hash table where the iteration order of the key-value\npairs is independent of the hash values of the keys. It has the usual\nhash table functionality, it preserves insertion order except after\nremovals, and it allows lookup of its elements by either hash table key\nor numerical index. A corresponding hash set type is also provided.\n\nThis crate was initially published under the name ordermap, but it was renamed to\nindexmap.\n";
    authors = [ "bluss" "Josh Stone <cuviper@gmail.com>" ];
    sha256 = "0dkidxq5q2a17symqni0k6m2jfap339bxnd3dd83dr556jh5dz89";
    build = "build.rs";
    dependencies = mapFeatures features ([
]);

    buildDependencies = mapFeatures features ([
      (crates."autocfg"."${deps."indexmap"."1.3.2"."autocfg"}" deps)
    ]);
    features = mkFeatures (features."indexmap"."1.3.2" or {});
  };
  features_.indexmap."1.3.2" = deps: f: updateFeatures f (rec {
    autocfg."${deps.indexmap."1.3.2".autocfg}".default = true;
    indexmap = fold recursiveUpdate {} [
      { "1.3.2"."serde" =
        (f.indexmap."1.3.2"."serde" or false) ||
        (f.indexmap."1.3.2".serde-1 or false) ||
        (indexmap."1.3.2"."serde-1" or false); }
      { "1.3.2".default = (f.indexmap."1.3.2".default or true); }
    ];
  }) [
    (features_.autocfg."${deps."indexmap"."1.3.2"."autocfg"}" deps)
  ];


# end
# iovec-0.1.4

  crates.iovec."0.1.4" = deps: { features?(features_.iovec."0.1.4" deps {}) }: buildRustCrate {
    crateName = "iovec";
    version = "0.1.4";
    description = "Portable buffer type for scatter/gather I/O operations\n";
    authors = [ "Carl Lerche <me@carllerche.com>" ];
    sha256 = "1wy7rsm8rx6y4rjy98jws1aqxdy0v5wbz9whz73p45cwpsg4prfa";
    dependencies = (if (kernel == "linux" || kernel == "darwin") then mapFeatures features ([
      (crates."libc"."${deps."iovec"."0.1.4"."libc"}" deps)
    ]) else []);
  };
  features_.iovec."0.1.4" = deps: f: updateFeatures f (rec {
    iovec."0.1.4".default = (f.iovec."0.1.4".default or true);
    libc."${deps.iovec."0.1.4".libc}".default = true;
  }) [
    (features_.libc."${deps."iovec"."0.1.4"."libc"}" deps)
  ];


# end
# itertools-0.8.2

  crates.itertools."0.8.2" = deps: { features?(features_.itertools."0.8.2" deps {}) }: buildRustCrate {
    crateName = "itertools";
    version = "0.8.2";
    description = "Extra iterator adaptors, iterator methods, free functions, and macros.";
    authors = [ "bluss" ];
    sha256 = "08ibirc0yiijx66aqszx4psz08zkn4fp4627dym94xcrib12na9r";
    dependencies = mapFeatures features ([
      (crates."either"."${deps."itertools"."0.8.2"."either"}" deps)
    ]);
    features = mkFeatures (features."itertools"."0.8.2" or {});
  };
  features_.itertools."0.8.2" = deps: f: updateFeatures f (rec {
    either."${deps.itertools."0.8.2".either}".default = (f.either."${deps.itertools."0.8.2".either}".default or false);
    itertools = fold recursiveUpdate {} [
      { "0.8.2"."use_std" =
        (f.itertools."0.8.2"."use_std" or false) ||
        (f.itertools."0.8.2".default or false) ||
        (itertools."0.8.2"."default" or false); }
      { "0.8.2".default = (f.itertools."0.8.2".default or true); }
    ];
  }) [
    (features_.either."${deps."itertools"."0.8.2"."either"}" deps)
  ];


# end
# itoa-0.4.5

  crates.itoa."0.4.5" = deps: { features?(features_.itoa."0.4.5" deps {}) }: buildRustCrate {
    crateName = "itoa";
    version = "0.4.5";
    description = "Fast functions for printing integer primitives to an io::Write";
    authors = [ "David Tolnay <dtolnay@gmail.com>" ];
    sha256 = "102dgh2d1779jyi63kgah61d4d92ql05ydmq7iwlcykdv9pabnpx";
    features = mkFeatures (features."itoa"."0.4.5" or {});
  };
  features_.itoa."0.4.5" = deps: f: updateFeatures f (rec {
    itoa = fold recursiveUpdate {} [
      { "0.4.5"."std" =
        (f.itoa."0.4.5"."std" or false) ||
        (f.itoa."0.4.5".default or false) ||
        (itoa."0.4.5"."default" or false); }
      { "0.4.5".default = (f.itoa."0.4.5".default or true); }
    ];
  }) [];


# end
# kernel32-sys-0.2.2

  crates.kernel32_sys."0.2.2" = deps: { features?(features_.kernel32_sys."0.2.2" deps {}) }: buildRustCrate {
    crateName = "kernel32-sys";
    version = "0.2.2";
    description = "Contains function definitions for the Windows API library kernel32. See winapi for types and constants.";
    authors = [ "Peter Atashian <retep998@gmail.com>" ];
    sha256 = "1lrw1hbinyvr6cp28g60z97w32w8vsk6pahk64pmrv2fmby8srfj";
    libName = "kernel32";
    build = "build.rs";
    dependencies = mapFeatures features ([
      (crates."winapi"."${deps."kernel32_sys"."0.2.2"."winapi"}" deps)
    ]);

    buildDependencies = mapFeatures features ([
      (crates."winapi_build"."${deps."kernel32_sys"."0.2.2"."winapi_build"}" deps)
    ]);
  };
  features_.kernel32_sys."0.2.2" = deps: f: updateFeatures f (rec {
    kernel32_sys."0.2.2".default = (f.kernel32_sys."0.2.2".default or true);
    winapi."${deps.kernel32_sys."0.2.2".winapi}".default = true;
    winapi_build."${deps.kernel32_sys."0.2.2".winapi_build}".default = true;
  }) [
    (features_.winapi."${deps."kernel32_sys"."0.2.2"."winapi"}" deps)
    (features_.winapi_build."${deps."kernel32_sys"."0.2.2"."winapi_build"}" deps)
  ];


# end
# lazy_static-1.4.0

  crates.lazy_static."1.4.0" = deps: { features?(features_.lazy_static."1.4.0" deps {}) }: buildRustCrate {
    crateName = "lazy_static";
    version = "1.4.0";
    description = "A macro for declaring lazily evaluated statics in Rust.";
    authors = [ "Marvin Löbel <loebel.marvin@gmail.com>" ];
    sha256 = "13h6sdghdcy7vcqsm2gasfw3qg7ssa0fl3sw7lq6pdkbk52wbyfr";
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."lazy_static"."1.4.0" or {});
  };
  features_.lazy_static."1.4.0" = deps: f: updateFeatures f (rec {
    lazy_static = fold recursiveUpdate {} [
      { "1.4.0"."spin" =
        (f.lazy_static."1.4.0"."spin" or false) ||
        (f.lazy_static."1.4.0".spin_no_std or false) ||
        (lazy_static."1.4.0"."spin_no_std" or false); }
      { "1.4.0".default = (f.lazy_static."1.4.0".default or true); }
    ];
  }) [];


# end
# libc-0.2.68

  crates.libc."0.2.68" = deps: { features?(features_.libc."0.2.68" deps {}) }: buildRustCrate {
    crateName = "libc";
    version = "0.2.68";
    description = "Raw FFI bindings to platform libraries like libc.\n";
    authors = [ "The Rust Project Developers" ];
    sha256 = "1ypl20mr7rr5c08z9ygl8zf1z63i7mh63dd62jshcdifnwhm37ph";
    build = "build.rs";
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."libc"."0.2.68" or {});
  };
  features_.libc."0.2.68" = deps: f: updateFeatures f (rec {
    libc = fold recursiveUpdate {} [
      { "0.2.68"."align" =
        (f.libc."0.2.68"."align" or false) ||
        (f.libc."0.2.68".rustc-dep-of-std or false) ||
        (libc."0.2.68"."rustc-dep-of-std" or false); }
      { "0.2.68"."rustc-std-workspace-core" =
        (f.libc."0.2.68"."rustc-std-workspace-core" or false) ||
        (f.libc."0.2.68".rustc-dep-of-std or false) ||
        (libc."0.2.68"."rustc-dep-of-std" or false); }
      { "0.2.68"."std" =
        (f.libc."0.2.68"."std" or false) ||
        (f.libc."0.2.68".default or false) ||
        (libc."0.2.68"."default" or false) ||
        (f.libc."0.2.68".use_std or false) ||
        (libc."0.2.68"."use_std" or false); }
      { "0.2.68".default = (f.libc."0.2.68".default or true); }
    ];
  }) [];


# end
# linked-hash-map-0.5.2

  crates.linked_hash_map."0.5.2" = deps: { features?(features_.linked_hash_map."0.5.2" deps {}) }: buildRustCrate {
    crateName = "linked-hash-map";
    version = "0.5.2";
    description = "A HashMap wrapper that holds key-value pairs in insertion order";
    authors = [ "Stepan Koltsov <stepan.koltsov@gmail.com>" "Andrew Paseltiner <apaseltiner@gmail.com>" ];
    sha256 = "17bpcphlhrxknzvikmihiqm690wwyr0zridyilh1dlxgmrxng7pd";
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."linked_hash_map"."0.5.2" or {});
  };
  features_.linked_hash_map."0.5.2" = deps: f: updateFeatures f (rec {
    linked_hash_map = fold recursiveUpdate {} [
      { "0.5.2"."heapsize" =
        (f.linked_hash_map."0.5.2"."heapsize" or false) ||
        (f.linked_hash_map."0.5.2".heapsize_impl or false) ||
        (linked_hash_map."0.5.2"."heapsize_impl" or false); }
      { "0.5.2"."serde" =
        (f.linked_hash_map."0.5.2"."serde" or false) ||
        (f.linked_hash_map."0.5.2".serde_impl or false) ||
        (linked_hash_map."0.5.2"."serde_impl" or false); }
      { "0.5.2"."serde_test" =
        (f.linked_hash_map."0.5.2"."serde_test" or false) ||
        (f.linked_hash_map."0.5.2".serde_impl or false) ||
        (linked_hash_map."0.5.2"."serde_impl" or false); }
      { "0.5.2".default = (f.linked_hash_map."0.5.2".default or true); }
    ];
  }) [];


# end
# log-0.4.8

  crates.log."0.4.8" = deps: { features?(features_.log."0.4.8" deps {}) }: buildRustCrate {
    crateName = "log";
    version = "0.4.8";
    description = "A lightweight logging facade for Rust\n";
    authors = [ "The Rust Project Developers" ];
    sha256 = "0wvzzzcn89dai172rrqcyz06pzldyyy0lf0w71csmn206rdpnb15";
    build = "build.rs";
    dependencies = mapFeatures features ([
      (crates."cfg_if"."${deps."log"."0.4.8"."cfg_if"}" deps)
    ]);
    features = mkFeatures (features."log"."0.4.8" or {});
  };
  features_.log."0.4.8" = deps: f: updateFeatures f (rec {
    cfg_if."${deps.log."0.4.8".cfg_if}".default = true;
    log = fold recursiveUpdate {} [
      { "0.4.8"."kv_unstable" =
        (f.log."0.4.8"."kv_unstable" or false) ||
        (f.log."0.4.8".kv_unstable_sval or false) ||
        (log."0.4.8"."kv_unstable_sval" or false); }
      { "0.4.8".default = (f.log."0.4.8".default or true); }
    ];
  }) [
    (features_.cfg_if."${deps."log"."0.4.8"."cfg_if"}" deps)
  ];


# end
# match_cfg-0.1.0

  crates.match_cfg."0.1.0" = deps: { features?(features_.match_cfg."0.1.0" deps {}) }: buildRustCrate {
    crateName = "match_cfg";
    version = "0.1.0";
    description = "A convenience macro to ergonomically define an item depending on a large number\nof `#[cfg]` parameters. Structured like match statement, the first matching\nbranch is the item that gets emitted.\n";
    authors = [ "gnzlbg <gonzalobg88@gmail.com>" ];
    edition = "2015";
    sha256 = "0gp66ai1fivsyr95snn8b6nihk3qwccrpi9aw09sk2dgr85qq04g";
    features = mkFeatures (features."match_cfg"."0.1.0" or {});
  };
  features_.match_cfg."0.1.0" = deps: f: updateFeatures f (rec {
    match_cfg = fold recursiveUpdate {} [
      { "0.1.0"."use_core" =
        (f.match_cfg."0.1.0"."use_core" or false) ||
        (f.match_cfg."0.1.0".default or false) ||
        (match_cfg."0.1.0"."default" or false); }
      { "0.1.0".default = (f.match_cfg."0.1.0".default or true); }
    ];
  }) [];


# end
# memchr-2.3.3

  crates.memchr."2.3.3" = deps: { features?(features_.memchr."2.3.3" deps {}) }: buildRustCrate {
    crateName = "memchr";
    version = "2.3.3";
    description = "Safe interface to memchr.";
    authors = [ "Andrew Gallant <jamslam@gmail.com>" "bluss" ];
    sha256 = "1ivxvlswglk6wd46gadkbbsknr94gwryk6y21v64ja7x4icrpihw";
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."memchr"."2.3.3" or {});
  };
  features_.memchr."2.3.3" = deps: f: updateFeatures f (rec {
    memchr = fold recursiveUpdate {} [
      { "2.3.3"."std" =
        (f.memchr."2.3.3"."std" or false) ||
        (f.memchr."2.3.3".default or false) ||
        (memchr."2.3.3"."default" or false) ||
        (f.memchr."2.3.3".use_std or false) ||
        (memchr."2.3.3"."use_std" or false); }
      { "2.3.3".default = (f.memchr."2.3.3".default or true); }
    ];
  }) [];


# end
# mio-0.6.21

  crates.mio."0.6.21" = deps: { features?(features_.mio."0.6.21" deps {}) }: buildRustCrate {
    crateName = "mio";
    version = "0.6.21";
    description = "Lightweight non-blocking IO";
    authors = [ "Carl Lerche <me@carllerche.com>" ];
    sha256 = "08z31q5fx4irmp3hsvlzqy541swda8ixhs69adm95j97xz5ikmys";
    dependencies = mapFeatures features ([
      (crates."cfg_if"."${deps."mio"."0.6.21"."cfg_if"}" deps)
      (crates."iovec"."${deps."mio"."0.6.21"."iovec"}" deps)
      (crates."log"."${deps."mio"."0.6.21"."log"}" deps)
      (crates."net2"."${deps."mio"."0.6.21"."net2"}" deps)
      (crates."slab"."${deps."mio"."0.6.21"."slab"}" deps)
    ])
      ++ (if kernel == "fuchsia" then mapFeatures features ([
      (crates."fuchsia_zircon"."${deps."mio"."0.6.21"."fuchsia_zircon"}" deps)
      (crates."fuchsia_zircon_sys"."${deps."mio"."0.6.21"."fuchsia_zircon_sys"}" deps)
    ]) else [])
      ++ (if (kernel == "linux" || kernel == "darwin") then mapFeatures features ([
      (crates."libc"."${deps."mio"."0.6.21"."libc"}" deps)
    ]) else [])
      ++ (if kernel == "windows" then mapFeatures features ([
      (crates."kernel32_sys"."${deps."mio"."0.6.21"."kernel32_sys"}" deps)
      (crates."miow"."${deps."mio"."0.6.21"."miow"}" deps)
      (crates."winapi"."${deps."mio"."0.6.21"."winapi"}" deps)
    ]) else []);
    features = mkFeatures (features."mio"."0.6.21" or {});
  };
  features_.mio."0.6.21" = deps: f: updateFeatures f (rec {
    cfg_if."${deps.mio."0.6.21".cfg_if}".default = true;
    fuchsia_zircon."${deps.mio."0.6.21".fuchsia_zircon}".default = true;
    fuchsia_zircon_sys."${deps.mio."0.6.21".fuchsia_zircon_sys}".default = true;
    iovec."${deps.mio."0.6.21".iovec}".default = true;
    kernel32_sys."${deps.mio."0.6.21".kernel32_sys}".default = true;
    libc."${deps.mio."0.6.21".libc}".default = true;
    log."${deps.mio."0.6.21".log}".default = true;
    mio = fold recursiveUpdate {} [
      { "0.6.21"."with-deprecated" =
        (f.mio."0.6.21"."with-deprecated" or false) ||
        (f.mio."0.6.21".default or false) ||
        (mio."0.6.21"."default" or false); }
      { "0.6.21".default = (f.mio."0.6.21".default or true); }
    ];
    miow."${deps.mio."0.6.21".miow}".default = true;
    net2."${deps.mio."0.6.21".net2}".default = true;
    slab."${deps.mio."0.6.21".slab}".default = true;
    winapi."${deps.mio."0.6.21".winapi}".default = true;
  }) [
    (features_.cfg_if."${deps."mio"."0.6.21"."cfg_if"}" deps)
    (features_.iovec."${deps."mio"."0.6.21"."iovec"}" deps)
    (features_.log."${deps."mio"."0.6.21"."log"}" deps)
    (features_.net2."${deps."mio"."0.6.21"."net2"}" deps)
    (features_.slab."${deps."mio"."0.6.21"."slab"}" deps)
    (features_.fuchsia_zircon."${deps."mio"."0.6.21"."fuchsia_zircon"}" deps)
    (features_.fuchsia_zircon_sys."${deps."mio"."0.6.21"."fuchsia_zircon_sys"}" deps)
    (features_.libc."${deps."mio"."0.6.21"."libc"}" deps)
    (features_.kernel32_sys."${deps."mio"."0.6.21"."kernel32_sys"}" deps)
    (features_.miow."${deps."mio"."0.6.21"."miow"}" deps)
    (features_.winapi."${deps."mio"."0.6.21"."winapi"}" deps)
  ];


# end
# mio-named-pipes-0.1.6

  crates.mio_named_pipes."0.1.6" = deps: { features?(features_.mio_named_pipes."0.1.6" deps {}) }: buildRustCrate {
    crateName = "mio-named-pipes";
    version = "0.1.6";
    description = "Windows named pipe bindings for mio.\n";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "016r9rjh8yq94rs8vn7z4jasx08z1q06jfwcvg39bihfyar4gsfx";
    dependencies = (if kernel == "windows" then mapFeatures features ([
      (crates."log"."${deps."mio_named_pipes"."0.1.6"."log"}" deps)
      (crates."mio"."${deps."mio_named_pipes"."0.1.6"."mio"}" deps)
      (crates."miow"."${deps."mio_named_pipes"."0.1.6"."miow"}" deps)
      (crates."winapi"."${deps."mio_named_pipes"."0.1.6"."winapi"}" deps)
    ]) else []);
  };
  features_.mio_named_pipes."0.1.6" = deps: f: updateFeatures f (rec {
    log."${deps.mio_named_pipes."0.1.6".log}".default = true;
    mio."${deps.mio_named_pipes."0.1.6".mio}".default = true;
    mio_named_pipes."0.1.6".default = (f.mio_named_pipes."0.1.6".default or true);
    miow."${deps.mio_named_pipes."0.1.6".miow}".default = true;
    winapi = fold recursiveUpdate {} [
      { "${deps.mio_named_pipes."0.1.6".winapi}"."ioapiset" = true; }
      { "${deps.mio_named_pipes."0.1.6".winapi}"."minwinbase" = true; }
      { "${deps.mio_named_pipes."0.1.6".winapi}"."winbase" = true; }
      { "${deps.mio_named_pipes."0.1.6".winapi}"."winerror" = true; }
      { "${deps.mio_named_pipes."0.1.6".winapi}".default = true; }
    ];
  }) [
    (features_.log."${deps."mio_named_pipes"."0.1.6"."log"}" deps)
    (features_.mio."${deps."mio_named_pipes"."0.1.6"."mio"}" deps)
    (features_.miow."${deps."mio_named_pipes"."0.1.6"."miow"}" deps)
    (features_.winapi."${deps."mio_named_pipes"."0.1.6"."winapi"}" deps)
  ];


# end
# mio-uds-0.6.7

  crates.mio_uds."0.6.7" = deps: { features?(features_.mio_uds."0.6.7" deps {}) }: buildRustCrate {
    crateName = "mio-uds";
    version = "0.6.7";
    description = "Unix domain socket bindings for mio\n";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "1gff9908pvvysv7zgxvyxy7x34fnhs088cr0j8mgwj8j24mswrhm";
    dependencies = (if (kernel == "linux" || kernel == "darwin") then mapFeatures features ([
      (crates."iovec"."${deps."mio_uds"."0.6.7"."iovec"}" deps)
      (crates."libc"."${deps."mio_uds"."0.6.7"."libc"}" deps)
      (crates."mio"."${deps."mio_uds"."0.6.7"."mio"}" deps)
    ]) else []);
  };
  features_.mio_uds."0.6.7" = deps: f: updateFeatures f (rec {
    iovec."${deps.mio_uds."0.6.7".iovec}".default = true;
    libc."${deps.mio_uds."0.6.7".libc}".default = true;
    mio."${deps.mio_uds."0.6.7".mio}".default = true;
    mio_uds."0.6.7".default = (f.mio_uds."0.6.7".default or true);
  }) [
    (features_.iovec."${deps."mio_uds"."0.6.7"."iovec"}" deps)
    (features_.libc."${deps."mio_uds"."0.6.7"."libc"}" deps)
    (features_.mio."${deps."mio_uds"."0.6.7"."mio"}" deps)
  ];


# end
# miow-0.2.1

  crates.miow."0.2.1" = deps: { features?(features_.miow."0.2.1" deps {}) }: buildRustCrate {
    crateName = "miow";
    version = "0.2.1";
    description = "A zero overhead I/O library for Windows, focusing on IOCP and Async I/O\nabstractions.\n";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "14f8zkc6ix7mkyis1vsqnim8m29b6l55abkba3p2yz7j1ibcvrl0";
    dependencies = mapFeatures features ([
      (crates."kernel32_sys"."${deps."miow"."0.2.1"."kernel32_sys"}" deps)
      (crates."net2"."${deps."miow"."0.2.1"."net2"}" deps)
      (crates."winapi"."${deps."miow"."0.2.1"."winapi"}" deps)
      (crates."ws2_32_sys"."${deps."miow"."0.2.1"."ws2_32_sys"}" deps)
    ]);
  };
  features_.miow."0.2.1" = deps: f: updateFeatures f (rec {
    kernel32_sys."${deps.miow."0.2.1".kernel32_sys}".default = true;
    miow."0.2.1".default = (f.miow."0.2.1".default or true);
    net2."${deps.miow."0.2.1".net2}".default = (f.net2."${deps.miow."0.2.1".net2}".default or false);
    winapi."${deps.miow."0.2.1".winapi}".default = true;
    ws2_32_sys."${deps.miow."0.2.1".ws2_32_sys}".default = true;
  }) [
    (features_.kernel32_sys."${deps."miow"."0.2.1"."kernel32_sys"}" deps)
    (features_.net2."${deps."miow"."0.2.1"."net2"}" deps)
    (features_.winapi."${deps."miow"."0.2.1"."winapi"}" deps)
    (features_.ws2_32_sys."${deps."miow"."0.2.1"."ws2_32_sys"}" deps)
  ];


# end
# miow-0.3.3

  crates.miow."0.3.3" = deps: { features?(features_.miow."0.3.3" deps {}) }: buildRustCrate {
    crateName = "miow";
    version = "0.3.3";
    description = "A zero overhead I/O library for Windows, focusing on IOCP and Async I/O\nabstractions.\n";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "1mlk5mn00cl6bmf8qlpc6r85dxf4l45vbkbzshsr1mrkb3hn1j57";
    dependencies = mapFeatures features ([
      (crates."socket2"."${deps."miow"."0.3.3"."socket2"}" deps)
      (crates."winapi"."${deps."miow"."0.3.3"."winapi"}" deps)
    ]);
  };
  features_.miow."0.3.3" = deps: f: updateFeatures f (rec {
    miow."0.3.3".default = (f.miow."0.3.3".default or true);
    socket2."${deps.miow."0.3.3".socket2}".default = true;
    winapi = fold recursiveUpdate {} [
      { "${deps.miow."0.3.3".winapi}"."fileapi" = true; }
      { "${deps.miow."0.3.3".winapi}"."handleapi" = true; }
      { "${deps.miow."0.3.3".winapi}"."ioapiset" = true; }
      { "${deps.miow."0.3.3".winapi}"."minwindef" = true; }
      { "${deps.miow."0.3.3".winapi}"."namedpipeapi" = true; }
      { "${deps.miow."0.3.3".winapi}"."ntdef" = true; }
      { "${deps.miow."0.3.3".winapi}"."std" = true; }
      { "${deps.miow."0.3.3".winapi}"."synchapi" = true; }
      { "${deps.miow."0.3.3".winapi}"."winerror" = true; }
      { "${deps.miow."0.3.3".winapi}"."winsock2" = true; }
      { "${deps.miow."0.3.3".winapi}"."ws2def" = true; }
      { "${deps.miow."0.3.3".winapi}"."ws2ipdef" = true; }
      { "${deps.miow."0.3.3".winapi}".default = true; }
    ];
  }) [
    (features_.socket2."${deps."miow"."0.3.3"."socket2"}" deps)
    (features_.winapi."${deps."miow"."0.3.3"."winapi"}" deps)
  ];


# end
# multimap-0.8.0

  crates.multimap."0.8.0" = deps: { features?(features_.multimap."0.8.0" deps {}) }: buildRustCrate {
    crateName = "multimap";
    version = "0.8.0";
    description = "A multimap implementation.";
    authors = [ "Håvar Nøvik <havar.novik@gmail.com>" ];
    sha256 = "0dzl7am1y5fann3fbhqzg23vi64srlwlv1xl1g4rk1z4lq1kwf7r";
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."multimap"."0.8.0" or {});
  };
  features_.multimap."0.8.0" = deps: f: updateFeatures f (rec {
    multimap = fold recursiveUpdate {} [
      { "0.8.0"."serde" =
        (f.multimap."0.8.0"."serde" or false) ||
        (f.multimap."0.8.0".serde_impl or false) ||
        (multimap."0.8.0"."serde_impl" or false); }
      { "0.8.0"."serde_impl" =
        (f.multimap."0.8.0"."serde_impl" or false) ||
        (f.multimap."0.8.0".default or false) ||
        (multimap."0.8.0"."default" or false); }
      { "0.8.0".default = (f.multimap."0.8.0".default or true); }
    ];
  }) [];


# end
# net2-0.2.33

  crates.net2."0.2.33" = deps: { features?(features_.net2."0.2.33" deps {}) }: buildRustCrate {
    crateName = "net2";
    version = "0.2.33";
    description = "Extensions to the standard library's networking types as proposed in RFC 1158.\n";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "1qnmajafgybj5wyxz9iffa8x5wgbwd2znfklmhqj7vl6lw1m65mq";
    dependencies = mapFeatures features ([
      (crates."cfg_if"."${deps."net2"."0.2.33"."cfg_if"}" deps)
    ])
      ++ (if kernel == "redox" || (kernel == "linux" || kernel == "darwin") then mapFeatures features ([
      (crates."libc"."${deps."net2"."0.2.33"."libc"}" deps)
    ]) else [])
      ++ (if kernel == "windows" then mapFeatures features ([
      (crates."winapi"."${deps."net2"."0.2.33"."winapi"}" deps)
    ]) else []);
    features = mkFeatures (features."net2"."0.2.33" or {});
  };
  features_.net2."0.2.33" = deps: f: updateFeatures f (rec {
    cfg_if."${deps.net2."0.2.33".cfg_if}".default = true;
    libc."${deps.net2."0.2.33".libc}".default = true;
    net2 = fold recursiveUpdate {} [
      { "0.2.33"."duration" =
        (f.net2."0.2.33"."duration" or false) ||
        (f.net2."0.2.33".default or false) ||
        (net2."0.2.33"."default" or false); }
      { "0.2.33".default = (f.net2."0.2.33".default or true); }
    ];
    winapi = fold recursiveUpdate {} [
      { "${deps.net2."0.2.33".winapi}"."handleapi" = true; }
      { "${deps.net2."0.2.33".winapi}"."winsock2" = true; }
      { "${deps.net2."0.2.33".winapi}"."ws2def" = true; }
      { "${deps.net2."0.2.33".winapi}"."ws2ipdef" = true; }
      { "${deps.net2."0.2.33".winapi}"."ws2tcpip" = true; }
      { "${deps.net2."0.2.33".winapi}".default = true; }
    ];
  }) [
    (features_.cfg_if."${deps."net2"."0.2.33"."cfg_if"}" deps)
    (features_.libc."${deps."net2"."0.2.33"."libc"}" deps)
    (features_.winapi."${deps."net2"."0.2.33"."winapi"}" deps)
  ];


# end
# nix-0.15.0

  crates.nix."0.15.0" = deps: { features?(features_.nix."0.15.0" deps {}) }: buildRustCrate {
    crateName = "nix";
    version = "0.15.0";
    description = "Rust friendly bindings to *nix APIs";
    authors = [ "The nix-rust Project Developers" ];
    sha256 = "183si5x662vdpvh3956gz5vmqg23zzzxjbc6cvmfp8xc51x7w9f8";
    dependencies = mapFeatures features ([
      (crates."bitflags"."${deps."nix"."0.15.0"."bitflags"}" deps)
      (crates."cfg_if"."${deps."nix"."0.15.0"."cfg_if"}" deps)
      (crates."libc"."${deps."nix"."0.15.0"."libc"}" deps)
      (crates."void"."${deps."nix"."0.15.0"."void"}" deps)
    ])
      ++ (if kernel == "android" || kernel == "linux" then mapFeatures features ([
]) else [])
      ++ (if kernel == "dragonfly" then mapFeatures features ([
]) else [])
      ++ (if kernel == "freebsd" then mapFeatures features ([
]) else []);
  };
  features_.nix."0.15.0" = deps: f: updateFeatures f (rec {
    bitflags."${deps.nix."0.15.0".bitflags}".default = true;
    cfg_if."${deps.nix."0.15.0".cfg_if}".default = true;
    libc = fold recursiveUpdate {} [
      { "${deps.nix."0.15.0".libc}"."extra_traits" = true; }
      { "${deps.nix."0.15.0".libc}".default = true; }
    ];
    nix."0.15.0".default = (f.nix."0.15.0".default or true);
    void."${deps.nix."0.15.0".void}".default = true;
  }) [
    (features_.bitflags."${deps."nix"."0.15.0"."bitflags"}" deps)
    (features_.cfg_if."${deps."nix"."0.15.0"."cfg_if"}" deps)
    (features_.libc."${deps."nix"."0.15.0"."libc"}" deps)
    (features_.void."${deps."nix"."0.15.0"."void"}" deps)
  ];


# end
# num_cpus-1.12.0

  crates.num_cpus."1.12.0" = deps: { features?(features_.num_cpus."1.12.0" deps {}) }: buildRustCrate {
    crateName = "num_cpus";
    version = "1.12.0";
    description = "Get the number of CPUs on a machine.";
    authors = [ "Sean McArthur <sean@seanmonstar.com>" ];
    sha256 = "053115487n4v2v045gjp0wh0q3lziribn67hwxjdddqq95l2m45m";
    dependencies = mapFeatures features ([
      (crates."libc"."${deps."num_cpus"."1.12.0"."libc"}" deps)
    ])
      ++ (if cpu == "x86_64" || cpu == "aarch64" && kernel == "hermit" then mapFeatures features ([
      (crates."hermit_abi"."${deps."num_cpus"."1.12.0"."hermit_abi"}" deps)
    ]) else []);
  };
  features_.num_cpus."1.12.0" = deps: f: updateFeatures f (rec {
    hermit_abi."${deps.num_cpus."1.12.0".hermit_abi}".default = true;
    libc."${deps.num_cpus."1.12.0".libc}".default = true;
    num_cpus."1.12.0".default = (f.num_cpus."1.12.0".default or true);
  }) [
    (features_.libc."${deps."num_cpus"."1.12.0"."libc"}" deps)
    (features_.hermit_abi."${deps."num_cpus"."1.12.0"."hermit_abi"}" deps)
  ];


# end
# percent-encoding-1.0.1

  crates.percent_encoding."1.0.1" = deps: { features?(features_.percent_encoding."1.0.1" deps {}) }: buildRustCrate {
    crateName = "percent-encoding";
    version = "1.0.1";
    description = "Percent encoding and decoding";
    authors = [ "The rust-url developers" ];
    sha256 = "04ahrp7aw4ip7fmadb0bknybmkfav0kk0gw4ps3ydq5w6hr0ib5i";
    libPath = "lib.rs";
  };
  features_.percent_encoding."1.0.1" = deps: f: updateFeatures f (rec {
    percent_encoding."1.0.1".default = (f.percent_encoding."1.0.1".default or true);
  }) [];


# end
# petgraph-0.5.0

  crates.petgraph."0.5.0" = deps: { features?(features_.petgraph."0.5.0" deps {}) }: buildRustCrate {
    crateName = "petgraph";
    version = "0.5.0";
    description = "Graph data structure library. Provides graph types and graph algorithms.";
    authors = [ "bluss" "mitchmindtree" ];
    edition = "2018";
    sha256 = "1mfsm000j4glvjfpiviqdmrs48hna3m0w3pgsra29jsvnvywbvgi";
    dependencies = mapFeatures features ([
      (crates."fixedbitset"."${deps."petgraph"."0.5.0"."fixedbitset"}" deps)
      (crates."indexmap"."${deps."petgraph"."0.5.0"."indexmap"}" deps)
    ]);
    features = mkFeatures (features."petgraph"."0.5.0" or {});
  };
  features_.petgraph."0.5.0" = deps: f: updateFeatures f (rec {
    fixedbitset."${deps.petgraph."0.5.0".fixedbitset}".default = (f.fixedbitset."${deps.petgraph."0.5.0".fixedbitset}".default or false);
    indexmap."${deps.petgraph."0.5.0".indexmap}".default = true;
    petgraph = fold recursiveUpdate {} [
      { "0.5.0"."generate" =
        (f.petgraph."0.5.0"."generate" or false) ||
        (f.petgraph."0.5.0".unstable or false) ||
        (petgraph."0.5.0"."unstable" or false); }
      { "0.5.0"."graphmap" =
        (f.petgraph."0.5.0"."graphmap" or false) ||
        (f.petgraph."0.5.0".all or false) ||
        (petgraph."0.5.0"."all" or false) ||
        (f.petgraph."0.5.0".default or false) ||
        (petgraph."0.5.0"."default" or false); }
      { "0.5.0"."matrix_graph" =
        (f.petgraph."0.5.0"."matrix_graph" or false) ||
        (f.petgraph."0.5.0".all or false) ||
        (petgraph."0.5.0"."all" or false) ||
        (f.petgraph."0.5.0".default or false) ||
        (petgraph."0.5.0"."default" or false); }
      { "0.5.0"."quickcheck" =
        (f.petgraph."0.5.0"."quickcheck" or false) ||
        (f.petgraph."0.5.0".all or false) ||
        (petgraph."0.5.0"."all" or false); }
      { "0.5.0"."serde" =
        (f.petgraph."0.5.0"."serde" or false) ||
        (f.petgraph."0.5.0".serde-1 or false) ||
        (petgraph."0.5.0"."serde-1" or false); }
      { "0.5.0"."serde_derive" =
        (f.petgraph."0.5.0"."serde_derive" or false) ||
        (f.petgraph."0.5.0".serde-1 or false) ||
        (petgraph."0.5.0"."serde-1" or false); }
      { "0.5.0"."stable_graph" =
        (f.petgraph."0.5.0"."stable_graph" or false) ||
        (f.petgraph."0.5.0".all or false) ||
        (petgraph."0.5.0"."all" or false) ||
        (f.petgraph."0.5.0".default or false) ||
        (petgraph."0.5.0"."default" or false); }
      { "0.5.0"."unstable" =
        (f.petgraph."0.5.0"."unstable" or false) ||
        (f.petgraph."0.5.0".all or false) ||
        (petgraph."0.5.0"."all" or false); }
      { "0.5.0".default = (f.petgraph."0.5.0".default or true); }
    ];
  }) [
    (features_.fixedbitset."${deps."petgraph"."0.5.0"."fixedbitset"}" deps)
    (features_.indexmap."${deps."petgraph"."0.5.0"."indexmap"}" deps)
  ];


# end
# pin-project-0.4.8

  crates.pin_project."0.4.8" = deps: { features?(features_.pin_project."0.4.8" deps {}) }: buildRustCrate {
    crateName = "pin-project";
    version = "0.4.8";
    description = "A crate for safe and ergonomic pin-projection.\n";
    authors = [ "Taiki Endo <te316e89@gmail.com>" ];
    edition = "2018";
    sha256 = "0wb1j947sinyr5sqc5wjxljs250rpfsm7aazy0mswg9jcv1v4zss";
    dependencies = mapFeatures features ([
      (crates."pin_project_internal"."${deps."pin_project"."0.4.8"."pin_project_internal"}" deps)
    ]);
  };
  features_.pin_project."0.4.8" = deps: f: updateFeatures f (rec {
    pin_project."0.4.8".default = (f.pin_project."0.4.8".default or true);
    pin_project_internal."${deps.pin_project."0.4.8".pin_project_internal}".default = (f.pin_project_internal."${deps.pin_project."0.4.8".pin_project_internal}".default or false);
  }) [
    (features_.pin_project_internal."${deps."pin_project"."0.4.8"."pin_project_internal"}" deps)
  ];


# end
# pin-project-internal-0.4.8

  crates.pin_project_internal."0.4.8" = deps: { features?(features_.pin_project_internal."0.4.8" deps {}) }: buildRustCrate {
    crateName = "pin-project-internal";
    version = "0.4.8";
    description = "An internal crate to support pin_project - do not use directly\n";
    authors = [ "Taiki Endo <te316e89@gmail.com>" ];
    edition = "2018";
    sha256 = "11gzk6fx0s6cyh5fhzwvfy6ds864szw93df8xb7m3s4f2kiblr0n";
    procMacro = true;
    dependencies = mapFeatures features ([
      (crates."proc_macro2"."${deps."pin_project_internal"."0.4.8"."proc_macro2"}" deps)
      (crates."quote"."${deps."pin_project_internal"."0.4.8"."quote"}" deps)
      (crates."syn"."${deps."pin_project_internal"."0.4.8"."syn"}" deps)
    ]);
  };
  features_.pin_project_internal."0.4.8" = deps: f: updateFeatures f (rec {
    pin_project_internal."0.4.8".default = (f.pin_project_internal."0.4.8".default or true);
    proc_macro2."${deps.pin_project_internal."0.4.8".proc_macro2}".default = true;
    quote."${deps.pin_project_internal."0.4.8".quote}".default = true;
    syn = fold recursiveUpdate {} [
      { "${deps.pin_project_internal."0.4.8".syn}"."full" = true; }
      { "${deps.pin_project_internal."0.4.8".syn}"."visit-mut" = true; }
      { "${deps.pin_project_internal."0.4.8".syn}".default = true; }
    ];
  }) [
    (features_.proc_macro2."${deps."pin_project_internal"."0.4.8"."proc_macro2"}" deps)
    (features_.quote."${deps."pin_project_internal"."0.4.8"."quote"}" deps)
    (features_.syn."${deps."pin_project_internal"."0.4.8"."syn"}" deps)
  ];


# end
# pin-project-lite-0.1.4

  crates.pin_project_lite."0.1.4" = deps: { features?(features_.pin_project_lite."0.1.4" deps {}) }: buildRustCrate {
    crateName = "pin-project-lite";
    version = "0.1.4";
    description = "A lightweight version of pin-project written with declarative macros.\n";
    authors = [ "Taiki Endo <te316e89@gmail.com>" ];
    edition = "2018";
    sha256 = "01pjrqsjxh1ypqcy07wk7jwmns89mkq8zgjmanjnzx261sw69s79";
  };
  features_.pin_project_lite."0.1.4" = deps: f: updateFeatures f (rec {
    pin_project_lite."0.1.4".default = (f.pin_project_lite."0.1.4".default or true);
  }) [];


# end
# pin-utils-0.1.0-alpha.4

  crates.pin_utils."0.1.0-alpha.4" = deps: { features?(features_.pin_utils."0.1.0-alpha.4" deps {}) }: buildRustCrate {
    crateName = "pin-utils";
    version = "0.1.0-alpha.4";
    description = "Utilities for pinning\n";
    authors = [ "Josef Brandl <mail@josefbrandl.de>" ];
    edition = "2018";
    sha256 = "1fl7h1f6gr7qj903k3ir2vw993gbj4dd775s0idq4pzsbjqjj3x1";
  };
  features_.pin_utils."0.1.0-alpha.4" = deps: f: updateFeatures f (rec {
    pin_utils."0.1.0-alpha.4".default = (f.pin_utils."0.1.0-alpha.4".default or true);
  }) [];


# end
# pkg-config-0.3.17

  crates.pkg_config."0.3.17" = deps: { features?(features_.pkg_config."0.3.17" deps {}) }: buildRustCrate {
    crateName = "pkg-config";
    version = "0.3.17";
    description = "A library to run the pkg-config system tool at build time in order to be used in\nCargo build scripts.\n";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "0f83cnls5a6y97k8b3a54xhmyrjybj29qq6rwvz450qdsy5ff8vj";
  };
  features_.pkg_config."0.3.17" = deps: f: updateFeatures f (rec {
    pkg_config."0.3.17".default = (f.pkg_config."0.3.17".default or true);
  }) [];


# end
# ppv-lite86-0.2.6

  crates.ppv_lite86."0.2.6" = deps: { features?(features_.ppv_lite86."0.2.6" deps {}) }: buildRustCrate {
    crateName = "ppv-lite86";
    version = "0.2.6";
    description = "Implementation of the crypto-simd API for x86";
    authors = [ "The CryptoCorrosion Contributors" ];
    edition = "2018";
    sha256 = "1mlbp0713frbyvcbjmc5vl062b0vr58agkv3ar2qqi5plgy9b7ib";
    features = mkFeatures (features."ppv_lite86"."0.2.6" or {});
  };
  features_.ppv_lite86."0.2.6" = deps: f: updateFeatures f (rec {
    ppv_lite86 = fold recursiveUpdate {} [
      { "0.2.6"."simd" =
        (f.ppv_lite86."0.2.6"."simd" or false) ||
        (f.ppv_lite86."0.2.6".default or false) ||
        (ppv_lite86."0.2.6"."default" or false); }
      { "0.2.6"."std" =
        (f.ppv_lite86."0.2.6"."std" or false) ||
        (f.ppv_lite86."0.2.6".default or false) ||
        (ppv_lite86."0.2.6"."default" or false); }
      { "0.2.6".default = (f.ppv_lite86."0.2.6".default or true); }
    ];
  }) [];


# end
# proc-macro-hack-0.5.14

  crates.proc_macro_hack."0.5.14" = deps: { features?(features_.proc_macro_hack."0.5.14" deps {}) }: buildRustCrate {
    crateName = "proc-macro-hack";
    version = "0.5.14";
    description = "Procedural macros in expression position";
    authors = [ "David Tolnay <dtolnay@gmail.com>" ];
    edition = "2018";
    sha256 = "08dyyxwasmcw2n8yfjs0v7hyg1hi9j3qqn04i2g309sqi4cvi51b";
    procMacro = true;
  };
  features_.proc_macro_hack."0.5.14" = deps: f: updateFeatures f (rec {
    proc_macro_hack."0.5.14".default = (f.proc_macro_hack."0.5.14".default or true);
  }) [];


# end
# proc-macro-nested-0.1.4

  crates.proc_macro_nested."0.1.4" = deps: { features?(features_.proc_macro_nested."0.1.4" deps {}) }: buildRustCrate {
    crateName = "proc-macro-nested";
    version = "0.1.4";
    description = "Support for nested proc-macro-hack invocations";
    authors = [ "David Tolnay <dtolnay@gmail.com>" ];
    sha256 = "1vb6rxh3004by7z27mbyrp7iv477vp43n70hiy4gryv1y41sfry2";
  };
  features_.proc_macro_nested."0.1.4" = deps: f: updateFeatures f (rec {
    proc_macro_nested."0.1.4".default = (f.proc_macro_nested."0.1.4".default or true);
  }) [];


# end
# proc-macro2-1.0.9

  crates.proc_macro2."1.0.9" = deps: { features?(features_.proc_macro2."1.0.9" deps {}) }: buildRustCrate {
    crateName = "proc-macro2";
    version = "1.0.9";
    description = "A stable implementation of the upcoming new `proc_macro` API. Comes with an\noption, off by default, to also reimplement itself in terms of the upstream\nunstable API.\n";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    edition = "2018";
    sha256 = "1kyip1rs0j3v1wafjn4ss03djs05ffxs2y7c2zi5064skhpxfzav";
    dependencies = mapFeatures features ([
      (crates."unicode_xid"."${deps."proc_macro2"."1.0.9"."unicode_xid"}" deps)
    ]);
    features = mkFeatures (features."proc_macro2"."1.0.9" or {});
  };
  features_.proc_macro2."1.0.9" = deps: f: updateFeatures f (rec {
    proc_macro2 = fold recursiveUpdate {} [
      { "1.0.9"."proc-macro" =
        (f.proc_macro2."1.0.9"."proc-macro" or false) ||
        (f.proc_macro2."1.0.9".default or false) ||
        (proc_macro2."1.0.9"."default" or false); }
      { "1.0.9".default = (f.proc_macro2."1.0.9".default or true); }
    ];
    unicode_xid."${deps.proc_macro2."1.0.9".unicode_xid}".default = true;
  }) [
    (features_.unicode_xid."${deps."proc_macro2"."1.0.9"."unicode_xid"}" deps)
  ];


# end
# prost-0.6.1

  crates.prost."0.6.1" = deps: { features?(features_.prost."0.6.1" deps {}) }: buildRustCrate {
    crateName = "prost";
    version = "0.6.1";
    description = "A Protocol Buffers implementation for the Rust Language.";
    authors = [ "Dan Burkert <dan@danburkert.com>" ];
    edition = "2018";
    sha256 = "1myvyvlz5v9z7j2wkn2v46illjnd476mrk9nmwv0162l1s3wbdxj";
    dependencies = mapFeatures features ([
      (crates."bytes"."${deps."prost"."0.6.1"."bytes"}" deps)
    ]
      ++ (if features.prost."0.6.1".prost-derive or false then [ (crates.prost_derive."${deps."prost"."0.6.1".prost_derive}" deps) ] else []));
    features = mkFeatures (features."prost"."0.6.1" or {});
  };
  features_.prost."0.6.1" = deps: f: updateFeatures f (rec {
    bytes."${deps.prost."0.6.1".bytes}".default = true;
    prost = fold recursiveUpdate {} [
      { "0.6.1"."prost-derive" =
        (f.prost."0.6.1"."prost-derive" or false) ||
        (f.prost."0.6.1".default or false) ||
        (prost."0.6.1"."default" or false); }
      { "0.6.1".default = (f.prost."0.6.1".default or true); }
    ];
    prost_derive."${deps.prost."0.6.1".prost_derive}".default = true;
  }) [
    (features_.bytes."${deps."prost"."0.6.1"."bytes"}" deps)
    (features_.prost_derive."${deps."prost"."0.6.1"."prost_derive"}" deps)
  ];


# end
# prost-build-0.6.1

  crates.prost_build."0.6.1" = deps: { features?(features_.prost_build."0.6.1" deps {}) }: buildRustCrate {
    crateName = "prost-build";
    version = "0.6.1";
    description = "A Protocol Buffers implementation for the Rust Language.";
    authors = [ "Dan Burkert <dan@danburkert.com>" ];
    edition = "2018";
    sha256 = "053mdzyc60i9df3l4c6if1mr1zrx0m6aiy8l20i1gvn66g5kk0zd";
    dependencies = mapFeatures features ([
      (crates."bytes"."${deps."prost_build"."0.6.1"."bytes"}" deps)
      (crates."heck"."${deps."prost_build"."0.6.1"."heck"}" deps)
      (crates."itertools"."${deps."prost_build"."0.6.1"."itertools"}" deps)
      (crates."log"."${deps."prost_build"."0.6.1"."log"}" deps)
      (crates."multimap"."${deps."prost_build"."0.6.1"."multimap"}" deps)
      (crates."petgraph"."${deps."prost_build"."0.6.1"."petgraph"}" deps)
      (crates."prost"."${deps."prost_build"."0.6.1"."prost"}" deps)
      (crates."prost_types"."${deps."prost_build"."0.6.1"."prost_types"}" deps)
      (crates."tempfile"."${deps."prost_build"."0.6.1"."tempfile"}" deps)
    ]);

    buildDependencies = mapFeatures features ([
      (crates."which"."${deps."prost_build"."0.6.1"."which"}" deps)
    ]);
  };
  features_.prost_build."0.6.1" = deps: f: updateFeatures f (rec {
    bytes."${deps.prost_build."0.6.1".bytes}".default = true;
    heck."${deps.prost_build."0.6.1".heck}".default = true;
    itertools."${deps.prost_build."0.6.1".itertools}".default = true;
    log."${deps.prost_build."0.6.1".log}".default = true;
    multimap."${deps.prost_build."0.6.1".multimap}".default = (f.multimap."${deps.prost_build."0.6.1".multimap}".default or false);
    petgraph."${deps.prost_build."0.6.1".petgraph}".default = (f.petgraph."${deps.prost_build."0.6.1".petgraph}".default or false);
    prost."${deps.prost_build."0.6.1".prost}".default = true;
    prost_build."0.6.1".default = (f.prost_build."0.6.1".default or true);
    prost_types."${deps.prost_build."0.6.1".prost_types}".default = true;
    tempfile."${deps.prost_build."0.6.1".tempfile}".default = true;
    which."${deps.prost_build."0.6.1".which}".default = (f.which."${deps.prost_build."0.6.1".which}".default or false);
  }) [
    (features_.bytes."${deps."prost_build"."0.6.1"."bytes"}" deps)
    (features_.heck."${deps."prost_build"."0.6.1"."heck"}" deps)
    (features_.itertools."${deps."prost_build"."0.6.1"."itertools"}" deps)
    (features_.log."${deps."prost_build"."0.6.1"."log"}" deps)
    (features_.multimap."${deps."prost_build"."0.6.1"."multimap"}" deps)
    (features_.petgraph."${deps."prost_build"."0.6.1"."petgraph"}" deps)
    (features_.prost."${deps."prost_build"."0.6.1"."prost"}" deps)
    (features_.prost_types."${deps."prost_build"."0.6.1"."prost_types"}" deps)
    (features_.tempfile."${deps."prost_build"."0.6.1"."tempfile"}" deps)
    (features_.which."${deps."prost_build"."0.6.1"."which"}" deps)
  ];


# end
# prost-derive-0.6.1

  crates.prost_derive."0.6.1" = deps: { features?(features_.prost_derive."0.6.1" deps {}) }: buildRustCrate {
    crateName = "prost-derive";
    version = "0.6.1";
    description = "A Protocol Buffers implementation for the Rust Language.";
    authors = [ "Dan Burkert <dan@danburkert.com>" ];
    edition = "2018";
    sha256 = "0bx82a7kr15ahy1mbwdxlmxgcv8m61jvp6d491dczvqy1d65z0gc";
    dependencies = mapFeatures features ([
      (crates."anyhow"."${deps."prost_derive"."0.6.1"."anyhow"}" deps)
      (crates."itertools"."${deps."prost_derive"."0.6.1"."itertools"}" deps)
      (crates."proc_macro2"."${deps."prost_derive"."0.6.1"."proc_macro2"}" deps)
      (crates."quote"."${deps."prost_derive"."0.6.1"."quote"}" deps)
      (crates."syn"."${deps."prost_derive"."0.6.1"."syn"}" deps)
    ]);
  };
  features_.prost_derive."0.6.1" = deps: f: updateFeatures f (rec {
    anyhow."${deps.prost_derive."0.6.1".anyhow}".default = true;
    itertools."${deps.prost_derive."0.6.1".itertools}".default = true;
    proc_macro2."${deps.prost_derive."0.6.1".proc_macro2}".default = true;
    prost_derive."0.6.1".default = (f.prost_derive."0.6.1".default or true);
    quote."${deps.prost_derive."0.6.1".quote}".default = true;
    syn = fold recursiveUpdate {} [
      { "${deps.prost_derive."0.6.1".syn}"."extra-traits" = true; }
      { "${deps.prost_derive."0.6.1".syn}".default = true; }
    ];
  }) [
    (features_.anyhow."${deps."prost_derive"."0.6.1"."anyhow"}" deps)
    (features_.itertools."${deps."prost_derive"."0.6.1"."itertools"}" deps)
    (features_.proc_macro2."${deps."prost_derive"."0.6.1"."proc_macro2"}" deps)
    (features_.quote."${deps."prost_derive"."0.6.1"."quote"}" deps)
    (features_.syn."${deps."prost_derive"."0.6.1"."syn"}" deps)
  ];


# end
# prost-types-0.6.1

  crates.prost_types."0.6.1" = deps: { features?(features_.prost_types."0.6.1" deps {}) }: buildRustCrate {
    crateName = "prost-types";
    version = "0.6.1";
    description = "A Protocol Buffers implementation for the Rust Language.";
    authors = [ "Dan Burkert <dan@danburkert.com>" ];
    edition = "2018";
    sha256 = "035l6ff0dz841qavfkq5gm9b4609rfv116kksc4d0qxy9a1663n2";
    dependencies = mapFeatures features ([
      (crates."bytes"."${deps."prost_types"."0.6.1"."bytes"}" deps)
      (crates."prost"."${deps."prost_types"."0.6.1"."prost"}" deps)
    ]);
  };
  features_.prost_types."0.6.1" = deps: f: updateFeatures f (rec {
    bytes."${deps.prost_types."0.6.1".bytes}".default = true;
    prost."${deps.prost_types."0.6.1".prost}".default = true;
    prost_types."0.6.1".default = (f.prost_types."0.6.1".default or true);
  }) [
    (features_.bytes."${deps."prost_types"."0.6.1"."bytes"}" deps)
    (features_.prost."${deps."prost_types"."0.6.1"."prost"}" deps)
  ];


# end
# quick-error-1.2.3

  crates.quick_error."1.2.3" = deps: { features?(features_.quick_error."1.2.3" deps {}) }: buildRustCrate {
    crateName = "quick-error";
    version = "1.2.3";
    description = "    A macro which makes error types pleasant to write.\n";
    authors = [ "Paul Colomiets <paul@colomiets.name>" "Colin Kiegel <kiegel@gmx.de>" ];
    sha256 = "17gqp7ifp6j5pcnk450f964a5jkqmy71848x69ahmsa9gyzhkh7x";
  };
  features_.quick_error."1.2.3" = deps: f: updateFeatures f (rec {
    quick_error."1.2.3".default = (f.quick_error."1.2.3".default or true);
  }) [];


# end
# quote-1.0.3

  crates.quote."1.0.3" = deps: { features?(features_.quote."1.0.3" deps {}) }: buildRustCrate {
    crateName = "quote";
    version = "1.0.3";
    description = "Quasi-quoting macro quote!(...)";
    authors = [ "David Tolnay <dtolnay@gmail.com>" ];
    edition = "2018";
    sha256 = "093chkpg7dc8f86kz0hlxzyfxvbix3xpkmlbhilf0wji228ad35c";
    dependencies = mapFeatures features ([
      (crates."proc_macro2"."${deps."quote"."1.0.3"."proc_macro2"}" deps)
    ]);
    features = mkFeatures (features."quote"."1.0.3" or {});
  };
  features_.quote."1.0.3" = deps: f: updateFeatures f (rec {
    proc_macro2 = fold recursiveUpdate {} [
      { "${deps.quote."1.0.3".proc_macro2}"."proc-macro" =
        (f.proc_macro2."${deps.quote."1.0.3".proc_macro2}"."proc-macro" or false) ||
        (quote."1.0.3"."proc-macro" or false) ||
        (f."quote"."1.0.3"."proc-macro" or false); }
      { "${deps.quote."1.0.3".proc_macro2}".default = (f.proc_macro2."${deps.quote."1.0.3".proc_macro2}".default or false); }
    ];
    quote = fold recursiveUpdate {} [
      { "1.0.3"."proc-macro" =
        (f.quote."1.0.3"."proc-macro" or false) ||
        (f.quote."1.0.3".default or false) ||
        (quote."1.0.3"."default" or false); }
      { "1.0.3".default = (f.quote."1.0.3".default or true); }
    ];
  }) [
    (features_.proc_macro2."${deps."quote"."1.0.3"."proc_macro2"}" deps)
  ];


# end
# rand-0.7.3

  crates.rand."0.7.3" = deps: { features?(features_.rand."0.7.3" deps {}) }: buildRustCrate {
    crateName = "rand";
    version = "0.7.3";
    description = "Random number generators and other randomness functionality.\n";
    authors = [ "The Rand Project Developers" "The Rust Project Developers" ];
    edition = "2018";
    sha256 = "1amg6qj53ylq3ix22n27kmj1gyj6i15my36mkayr30ndymny0b8r";
    dependencies = mapFeatures features ([
      (crates."rand_core"."${deps."rand"."0.7.3"."rand_core"}" deps)
    ]
      ++ (if features.rand."0.7.3".rand_pcg or false then [ (crates.rand_pcg."${deps."rand"."0.7.3".rand_pcg}" deps) ] else []))
      ++ (if !(kernel == "emscripten") then mapFeatures features ([
      (crates."rand_chacha"."${deps."rand"."0.7.3"."rand_chacha"}" deps)
    ]) else [])
      ++ (if kernel == "emscripten" then mapFeatures features ([
      (crates."rand_hc"."${deps."rand"."0.7.3"."rand_hc"}" deps)
    ]) else [])
      ++ (if (kernel == "linux" || kernel == "darwin") then mapFeatures features ([
    ]
      ++ (if features.rand."0.7.3".libc or false then [ (crates.libc."${deps."rand"."0.7.3".libc}" deps) ] else [])) else []);
    features = mkFeatures (features."rand"."0.7.3" or {});
  };
  features_.rand."0.7.3" = deps: f: updateFeatures f (rec {
    libc."${deps.rand."0.7.3".libc}".default = (f.libc."${deps.rand."0.7.3".libc}".default or false);
    rand = fold recursiveUpdate {} [
      { "0.7.3"."alloc" =
        (f.rand."0.7.3"."alloc" or false) ||
        (f.rand."0.7.3".std or false) ||
        (rand."0.7.3"."std" or false); }
      { "0.7.3"."getrandom" =
        (f.rand."0.7.3"."getrandom" or false) ||
        (f.rand."0.7.3".std or false) ||
        (rand."0.7.3"."std" or false); }
      { "0.7.3"."getrandom_package" =
        (f.rand."0.7.3"."getrandom_package" or false) ||
        (f.rand."0.7.3".getrandom or false) ||
        (rand."0.7.3"."getrandom" or false); }
      { "0.7.3"."libc" =
        (f.rand."0.7.3"."libc" or false) ||
        (f.rand."0.7.3".std or false) ||
        (rand."0.7.3"."std" or false); }
      { "0.7.3"."packed_simd" =
        (f.rand."0.7.3"."packed_simd" or false) ||
        (f.rand."0.7.3".simd_support or false) ||
        (rand."0.7.3"."simd_support" or false); }
      { "0.7.3"."rand_pcg" =
        (f.rand."0.7.3"."rand_pcg" or false) ||
        (f.rand."0.7.3".small_rng or false) ||
        (rand."0.7.3"."small_rng" or false); }
      { "0.7.3"."simd_support" =
        (f.rand."0.7.3"."simd_support" or false) ||
        (f.rand."0.7.3".nightly or false) ||
        (rand."0.7.3"."nightly" or false); }
      { "0.7.3"."std" =
        (f.rand."0.7.3"."std" or false) ||
        (f.rand."0.7.3".default or false) ||
        (rand."0.7.3"."default" or false); }
      { "0.7.3".default = (f.rand."0.7.3".default or true); }
    ];
    rand_chacha."${deps.rand."0.7.3".rand_chacha}".default = (f.rand_chacha."${deps.rand."0.7.3".rand_chacha}".default or false);
    rand_core = fold recursiveUpdate {} [
      { "${deps.rand."0.7.3".rand_core}"."alloc" =
        (f.rand_core."${deps.rand."0.7.3".rand_core}"."alloc" or false) ||
        (rand."0.7.3"."alloc" or false) ||
        (f."rand"."0.7.3"."alloc" or false); }
      { "${deps.rand."0.7.3".rand_core}"."getrandom" =
        (f.rand_core."${deps.rand."0.7.3".rand_core}"."getrandom" or false) ||
        (rand."0.7.3"."getrandom" or false) ||
        (f."rand"."0.7.3"."getrandom" or false); }
      { "${deps.rand."0.7.3".rand_core}"."std" =
        (f.rand_core."${deps.rand."0.7.3".rand_core}"."std" or false) ||
        (rand."0.7.3"."std" or false) ||
        (f."rand"."0.7.3"."std" or false); }
      { "${deps.rand."0.7.3".rand_core}".default = true; }
    ];
    rand_hc."${deps.rand."0.7.3".rand_hc}".default = true;
    rand_pcg."${deps.rand."0.7.3".rand_pcg}".default = true;
  }) [
    (features_.rand_core."${deps."rand"."0.7.3"."rand_core"}" deps)
    (features_.rand_pcg."${deps."rand"."0.7.3"."rand_pcg"}" deps)
    (features_.rand_chacha."${deps."rand"."0.7.3"."rand_chacha"}" deps)
    (features_.rand_hc."${deps."rand"."0.7.3"."rand_hc"}" deps)
    (features_.libc."${deps."rand"."0.7.3"."libc"}" deps)
  ];


# end
# rand_chacha-0.2.2

  crates.rand_chacha."0.2.2" = deps: { features?(features_.rand_chacha."0.2.2" deps {}) }: buildRustCrate {
    crateName = "rand_chacha";
    version = "0.2.2";
    description = "ChaCha random number generator\n";
    authors = [ "The Rand Project Developers" "The Rust Project Developers" "The CryptoCorrosion Contributors" ];
    edition = "2018";
    sha256 = "1adx0h0h17y6sxlx1zpwg0hnyccnwlp5ad7dxn2jib9caw1s7ghk";
    dependencies = mapFeatures features ([
      (crates."ppv_lite86"."${deps."rand_chacha"."0.2.2"."ppv_lite86"}" deps)
      (crates."rand_core"."${deps."rand_chacha"."0.2.2"."rand_core"}" deps)
    ]);
    features = mkFeatures (features."rand_chacha"."0.2.2" or {});
  };
  features_.rand_chacha."0.2.2" = deps: f: updateFeatures f (rec {
    ppv_lite86 = fold recursiveUpdate {} [
      { "${deps.rand_chacha."0.2.2".ppv_lite86}"."simd" = true; }
      { "${deps.rand_chacha."0.2.2".ppv_lite86}"."std" =
        (f.ppv_lite86."${deps.rand_chacha."0.2.2".ppv_lite86}"."std" or false) ||
        (rand_chacha."0.2.2"."std" or false) ||
        (f."rand_chacha"."0.2.2"."std" or false); }
      { "${deps.rand_chacha."0.2.2".ppv_lite86}".default = (f.ppv_lite86."${deps.rand_chacha."0.2.2".ppv_lite86}".default or false); }
    ];
    rand_chacha = fold recursiveUpdate {} [
      { "0.2.2"."simd" =
        (f.rand_chacha."0.2.2"."simd" or false) ||
        (f.rand_chacha."0.2.2".default or false) ||
        (rand_chacha."0.2.2"."default" or false); }
      { "0.2.2"."std" =
        (f.rand_chacha."0.2.2"."std" or false) ||
        (f.rand_chacha."0.2.2".default or false) ||
        (rand_chacha."0.2.2"."default" or false); }
      { "0.2.2".default = (f.rand_chacha."0.2.2".default or true); }
    ];
    rand_core."${deps.rand_chacha."0.2.2".rand_core}".default = true;
  }) [
    (features_.ppv_lite86."${deps."rand_chacha"."0.2.2"."ppv_lite86"}" deps)
    (features_.rand_core."${deps."rand_chacha"."0.2.2"."rand_core"}" deps)
  ];


# end
# rand_core-0.5.1

  crates.rand_core."0.5.1" = deps: { features?(features_.rand_core."0.5.1" deps {}) }: buildRustCrate {
    crateName = "rand_core";
    version = "0.5.1";
    description = "Core random number generator traits and tools for implementation.\n";
    authors = [ "The Rand Project Developers" "The Rust Project Developers" ];
    edition = "2018";
    sha256 = "19qfnh77bzz0x2gfsk91h0gygy0z1s5l3yyc2j91gmprq60d6s3r";
    dependencies = mapFeatures features ([
    ]
      ++ (if features.rand_core."0.5.1".getrandom or false then [ (crates.getrandom."${deps."rand_core"."0.5.1".getrandom}" deps) ] else []));
    features = mkFeatures (features."rand_core"."0.5.1" or {});
  };
  features_.rand_core."0.5.1" = deps: f: updateFeatures f (rec {
    getrandom = fold recursiveUpdate {} [
      { "${deps.rand_core."0.5.1".getrandom}"."std" =
        (f.getrandom."${deps.rand_core."0.5.1".getrandom}"."std" or false) ||
        (rand_core."0.5.1"."std" or false) ||
        (f."rand_core"."0.5.1"."std" or false); }
      { "${deps.rand_core."0.5.1".getrandom}".default = true; }
    ];
    rand_core = fold recursiveUpdate {} [
      { "0.5.1"."alloc" =
        (f.rand_core."0.5.1"."alloc" or false) ||
        (f.rand_core."0.5.1".std or false) ||
        (rand_core."0.5.1"."std" or false); }
      { "0.5.1"."getrandom" =
        (f.rand_core."0.5.1"."getrandom" or false) ||
        (f.rand_core."0.5.1".std or false) ||
        (rand_core."0.5.1"."std" or false); }
      { "0.5.1"."serde" =
        (f.rand_core."0.5.1"."serde" or false) ||
        (f.rand_core."0.5.1".serde1 or false) ||
        (rand_core."0.5.1"."serde1" or false); }
      { "0.5.1".default = (f.rand_core."0.5.1".default or true); }
    ];
  }) [
    (features_.getrandom."${deps."rand_core"."0.5.1"."getrandom"}" deps)
  ];


# end
# rand_hc-0.2.0

  crates.rand_hc."0.2.0" = deps: { features?(features_.rand_hc."0.2.0" deps {}) }: buildRustCrate {
    crateName = "rand_hc";
    version = "0.2.0";
    description = "HC128 random number generator\n";
    authors = [ "The Rand Project Developers" ];
    edition = "2018";
    sha256 = "0592q9kqcna9aiyzy6vp3fadxkkbpfkmi2cnkv48zhybr0v2yf01";
    dependencies = mapFeatures features ([
      (crates."rand_core"."${deps."rand_hc"."0.2.0"."rand_core"}" deps)
    ]);
  };
  features_.rand_hc."0.2.0" = deps: f: updateFeatures f (rec {
    rand_core."${deps.rand_hc."0.2.0".rand_core}".default = true;
    rand_hc."0.2.0".default = (f.rand_hc."0.2.0".default or true);
  }) [
    (features_.rand_core."${deps."rand_hc"."0.2.0"."rand_core"}" deps)
  ];


# end
# rand_pcg-0.2.1

  crates.rand_pcg."0.2.1" = deps: { features?(features_.rand_pcg."0.2.1" deps {}) }: buildRustCrate {
    crateName = "rand_pcg";
    version = "0.2.1";
    description = "Selected PCG random number generators\n";
    authors = [ "The Rand Project Developers" ];
    edition = "2018";
    sha256 = "04yzci1dbsp2n404iyhzi4dk50cplfw8g9si4xibxdcz062nbmh0";
    dependencies = mapFeatures features ([
      (crates."rand_core"."${deps."rand_pcg"."0.2.1"."rand_core"}" deps)
    ]);
    features = mkFeatures (features."rand_pcg"."0.2.1" or {});
  };
  features_.rand_pcg."0.2.1" = deps: f: updateFeatures f (rec {
    rand_core."${deps.rand_pcg."0.2.1".rand_core}".default = true;
    rand_pcg = fold recursiveUpdate {} [
      { "0.2.1"."serde" =
        (f.rand_pcg."0.2.1"."serde" or false) ||
        (f.rand_pcg."0.2.1".serde1 or false) ||
        (rand_pcg."0.2.1"."serde1" or false); }
      { "0.2.1".default = (f.rand_pcg."0.2.1".default or true); }
    ];
  }) [
    (features_.rand_core."${deps."rand_pcg"."0.2.1"."rand_core"}" deps)
  ];


# end
# redox_syscall-0.1.56

  crates.redox_syscall."0.1.56" = deps: { features?(features_.redox_syscall."0.1.56" deps {}) }: buildRustCrate {
    crateName = "redox_syscall";
    version = "0.1.56";
    description = "A Rust library to access raw Redox system calls";
    authors = [ "Jeremy Soller <jackpot51@gmail.com>" ];
    sha256 = "0jcp8nd947zcy938bz09pzlmi3vyxfdzg92pjxdvvk0699vwcc26";
    libName = "syscall";
  };
  features_.redox_syscall."0.1.56" = deps: f: updateFeatures f (rec {
    redox_syscall."0.1.56".default = (f.redox_syscall."0.1.56".default or true);
  }) [];


# end
# regex-1.3.6

  crates.regex."1.3.6" = deps: { features?(features_.regex."1.3.6" deps {}) }: buildRustCrate {
    crateName = "regex";
    version = "1.3.6";
    description = "An implementation of regular expressions for Rust. This implementation uses\nfinite automata and guarantees linear time matching on all inputs.\n";
    authors = [ "The Rust Project Developers" ];
    sha256 = "1ymfjn2wf5pq2fkgnkh1jif8iqw1ivhdmgdf04xv18czkz1an5g4";
    dependencies = mapFeatures features ([
      (crates."regex_syntax"."${deps."regex"."1.3.6"."regex_syntax"}" deps)
    ]
      ++ (if features.regex."1.3.6".aho-corasick or false then [ (crates.aho_corasick."${deps."regex"."1.3.6".aho_corasick}" deps) ] else [])
      ++ (if features.regex."1.3.6".memchr or false then [ (crates.memchr."${deps."regex"."1.3.6".memchr}" deps) ] else [])
      ++ (if features.regex."1.3.6".thread_local or false then [ (crates.thread_local."${deps."regex"."1.3.6".thread_local}" deps) ] else []));
    features = mkFeatures (features."regex"."1.3.6" or {});
  };
  features_.regex."1.3.6" = deps: f: updateFeatures f (rec {
    aho_corasick."${deps.regex."1.3.6".aho_corasick}".default = true;
    memchr."${deps.regex."1.3.6".memchr}".default = true;
    regex = fold recursiveUpdate {} [
      { "1.3.6"."aho-corasick" =
        (f.regex."1.3.6"."aho-corasick" or false) ||
        (f.regex."1.3.6".perf-literal or false) ||
        (regex."1.3.6"."perf-literal" or false); }
      { "1.3.6"."memchr" =
        (f.regex."1.3.6"."memchr" or false) ||
        (f.regex."1.3.6".perf-literal or false) ||
        (regex."1.3.6"."perf-literal" or false); }
      { "1.3.6"."pattern" =
        (f.regex."1.3.6"."pattern" or false) ||
        (f.regex."1.3.6".unstable or false) ||
        (regex."1.3.6"."unstable" or false); }
      { "1.3.6"."perf" =
        (f.regex."1.3.6"."perf" or false) ||
        (f.regex."1.3.6".default or false) ||
        (regex."1.3.6"."default" or false); }
      { "1.3.6"."perf-cache" =
        (f.regex."1.3.6"."perf-cache" or false) ||
        (f.regex."1.3.6".perf or false) ||
        (regex."1.3.6"."perf" or false); }
      { "1.3.6"."perf-dfa" =
        (f.regex."1.3.6"."perf-dfa" or false) ||
        (f.regex."1.3.6".perf or false) ||
        (regex."1.3.6"."perf" or false); }
      { "1.3.6"."perf-inline" =
        (f.regex."1.3.6"."perf-inline" or false) ||
        (f.regex."1.3.6".perf or false) ||
        (regex."1.3.6"."perf" or false); }
      { "1.3.6"."perf-literal" =
        (f.regex."1.3.6"."perf-literal" or false) ||
        (f.regex."1.3.6".perf or false) ||
        (regex."1.3.6"."perf" or false); }
      { "1.3.6"."std" =
        (f.regex."1.3.6"."std" or false) ||
        (f.regex."1.3.6".default or false) ||
        (regex."1.3.6"."default" or false) ||
        (f.regex."1.3.6".use_std or false) ||
        (regex."1.3.6"."use_std" or false); }
      { "1.3.6"."thread_local" =
        (f.regex."1.3.6"."thread_local" or false) ||
        (f.regex."1.3.6".perf-cache or false) ||
        (regex."1.3.6"."perf-cache" or false); }
      { "1.3.6"."unicode" =
        (f.regex."1.3.6"."unicode" or false) ||
        (f.regex."1.3.6".default or false) ||
        (regex."1.3.6"."default" or false); }
      { "1.3.6"."unicode-age" =
        (f.regex."1.3.6"."unicode-age" or false) ||
        (f.regex."1.3.6".unicode or false) ||
        (regex."1.3.6"."unicode" or false); }
      { "1.3.6"."unicode-bool" =
        (f.regex."1.3.6"."unicode-bool" or false) ||
        (f.regex."1.3.6".unicode or false) ||
        (regex."1.3.6"."unicode" or false); }
      { "1.3.6"."unicode-case" =
        (f.regex."1.3.6"."unicode-case" or false) ||
        (f.regex."1.3.6".unicode or false) ||
        (regex."1.3.6"."unicode" or false); }
      { "1.3.6"."unicode-gencat" =
        (f.regex."1.3.6"."unicode-gencat" or false) ||
        (f.regex."1.3.6".unicode or false) ||
        (regex."1.3.6"."unicode" or false); }
      { "1.3.6"."unicode-perl" =
        (f.regex."1.3.6"."unicode-perl" or false) ||
        (f.regex."1.3.6".unicode or false) ||
        (regex."1.3.6"."unicode" or false); }
      { "1.3.6"."unicode-script" =
        (f.regex."1.3.6"."unicode-script" or false) ||
        (f.regex."1.3.6".unicode or false) ||
        (regex."1.3.6"."unicode" or false); }
      { "1.3.6"."unicode-segment" =
        (f.regex."1.3.6"."unicode-segment" or false) ||
        (f.regex."1.3.6".unicode or false) ||
        (regex."1.3.6"."unicode" or false); }
      { "1.3.6".default = (f.regex."1.3.6".default or true); }
    ];
    regex_syntax = fold recursiveUpdate {} [
      { "${deps.regex."1.3.6".regex_syntax}"."unicode-age" =
        (f.regex_syntax."${deps.regex."1.3.6".regex_syntax}"."unicode-age" or false) ||
        (regex."1.3.6"."unicode-age" or false) ||
        (f."regex"."1.3.6"."unicode-age" or false); }
      { "${deps.regex."1.3.6".regex_syntax}"."unicode-bool" =
        (f.regex_syntax."${deps.regex."1.3.6".regex_syntax}"."unicode-bool" or false) ||
        (regex."1.3.6"."unicode-bool" or false) ||
        (f."regex"."1.3.6"."unicode-bool" or false); }
      { "${deps.regex."1.3.6".regex_syntax}"."unicode-case" =
        (f.regex_syntax."${deps.regex."1.3.6".regex_syntax}"."unicode-case" or false) ||
        (regex."1.3.6"."unicode-case" or false) ||
        (f."regex"."1.3.6"."unicode-case" or false); }
      { "${deps.regex."1.3.6".regex_syntax}"."unicode-gencat" =
        (f.regex_syntax."${deps.regex."1.3.6".regex_syntax}"."unicode-gencat" or false) ||
        (regex."1.3.6"."unicode-gencat" or false) ||
        (f."regex"."1.3.6"."unicode-gencat" or false); }
      { "${deps.regex."1.3.6".regex_syntax}"."unicode-perl" =
        (f.regex_syntax."${deps.regex."1.3.6".regex_syntax}"."unicode-perl" or false) ||
        (regex."1.3.6"."unicode-perl" or false) ||
        (f."regex"."1.3.6"."unicode-perl" or false); }
      { "${deps.regex."1.3.6".regex_syntax}"."unicode-script" =
        (f.regex_syntax."${deps.regex."1.3.6".regex_syntax}"."unicode-script" or false) ||
        (regex."1.3.6"."unicode-script" or false) ||
        (f."regex"."1.3.6"."unicode-script" or false); }
      { "${deps.regex."1.3.6".regex_syntax}"."unicode-segment" =
        (f.regex_syntax."${deps.regex."1.3.6".regex_syntax}"."unicode-segment" or false) ||
        (regex."1.3.6"."unicode-segment" or false) ||
        (f."regex"."1.3.6"."unicode-segment" or false); }
      { "${deps.regex."1.3.6".regex_syntax}".default = (f.regex_syntax."${deps.regex."1.3.6".regex_syntax}".default or false); }
    ];
    thread_local."${deps.regex."1.3.6".thread_local}".default = true;
  }) [
    (features_.aho_corasick."${deps."regex"."1.3.6"."aho_corasick"}" deps)
    (features_.memchr."${deps."regex"."1.3.6"."memchr"}" deps)
    (features_.regex_syntax."${deps."regex"."1.3.6"."regex_syntax"}" deps)
    (features_.thread_local."${deps."regex"."1.3.6"."thread_local"}" deps)
  ];


# end
# regex-syntax-0.6.17

  crates.regex_syntax."0.6.17" = deps: { features?(features_.regex_syntax."0.6.17" deps {}) }: buildRustCrate {
    crateName = "regex-syntax";
    version = "0.6.17";
    description = "A regular expression parser.";
    authors = [ "The Rust Project Developers" ];
    sha256 = "0jvwz9bfycw52mf0djnmvwzx6v3jcvcwaz0zf9ikajrl00ahfx3a";
    features = mkFeatures (features."regex_syntax"."0.6.17" or {});
  };
  features_.regex_syntax."0.6.17" = deps: f: updateFeatures f (rec {
    regex_syntax = fold recursiveUpdate {} [
      { "0.6.17"."unicode" =
        (f.regex_syntax."0.6.17"."unicode" or false) ||
        (f.regex_syntax."0.6.17".default or false) ||
        (regex_syntax."0.6.17"."default" or false); }
      { "0.6.17"."unicode-age" =
        (f.regex_syntax."0.6.17"."unicode-age" or false) ||
        (f.regex_syntax."0.6.17".unicode or false) ||
        (regex_syntax."0.6.17"."unicode" or false); }
      { "0.6.17"."unicode-bool" =
        (f.regex_syntax."0.6.17"."unicode-bool" or false) ||
        (f.regex_syntax."0.6.17".unicode or false) ||
        (regex_syntax."0.6.17"."unicode" or false); }
      { "0.6.17"."unicode-case" =
        (f.regex_syntax."0.6.17"."unicode-case" or false) ||
        (f.regex_syntax."0.6.17".unicode or false) ||
        (regex_syntax."0.6.17"."unicode" or false); }
      { "0.6.17"."unicode-gencat" =
        (f.regex_syntax."0.6.17"."unicode-gencat" or false) ||
        (f.regex_syntax."0.6.17".unicode or false) ||
        (regex_syntax."0.6.17"."unicode" or false); }
      { "0.6.17"."unicode-perl" =
        (f.regex_syntax."0.6.17"."unicode-perl" or false) ||
        (f.regex_syntax."0.6.17".unicode or false) ||
        (regex_syntax."0.6.17"."unicode" or false); }
      { "0.6.17"."unicode-script" =
        (f.regex_syntax."0.6.17"."unicode-script" or false) ||
        (f.regex_syntax."0.6.17".unicode or false) ||
        (regex_syntax."0.6.17"."unicode" or false); }
      { "0.6.17"."unicode-segment" =
        (f.regex_syntax."0.6.17"."unicode-segment" or false) ||
        (f.regex_syntax."0.6.17".unicode or false) ||
        (regex_syntax."0.6.17"."unicode" or false); }
      { "0.6.17".default = (f.regex_syntax."0.6.17".default or true); }
    ];
  }) [];


# end
# remove_dir_all-0.5.2

  crates.remove_dir_all."0.5.2" = deps: { features?(features_.remove_dir_all."0.5.2" deps {}) }: buildRustCrate {
    crateName = "remove_dir_all";
    version = "0.5.2";
    description = "A safe, reliable implementation of remove_dir_all for Windows";
    authors = [ "Aaronepower <theaaronepower@gmail.com>" ];
    sha256 = "04sxg2ppvxiljc2i13bwvpbi540rf9d2a89cq0wmqf9pjvr3a1wm";
    dependencies = (if kernel == "windows" then mapFeatures features ([
      (crates."winapi"."${deps."remove_dir_all"."0.5.2"."winapi"}" deps)
    ]) else []);
  };
  features_.remove_dir_all."0.5.2" = deps: f: updateFeatures f (rec {
    remove_dir_all."0.5.2".default = (f.remove_dir_all."0.5.2".default or true);
    winapi = fold recursiveUpdate {} [
      { "${deps.remove_dir_all."0.5.2".winapi}"."errhandlingapi" = true; }
      { "${deps.remove_dir_all."0.5.2".winapi}"."fileapi" = true; }
      { "${deps.remove_dir_all."0.5.2".winapi}"."std" = true; }
      { "${deps.remove_dir_all."0.5.2".winapi}"."winbase" = true; }
      { "${deps.remove_dir_all."0.5.2".winapi}"."winerror" = true; }
      { "${deps.remove_dir_all."0.5.2".winapi}".default = true; }
    ];
  }) [
    (features_.winapi."${deps."remove_dir_all"."0.5.2"."winapi"}" deps)
  ];


# end
# rustc-demangle-0.1.16

  crates.rustc_demangle."0.1.16" = deps: { features?(features_.rustc_demangle."0.1.16" deps {}) }: buildRustCrate {
    crateName = "rustc-demangle";
    version = "0.1.16";
    description = "Rust compiler symbol demangling.\n";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "0zmn448d0f898ahfkz7cir0fi0vk84dabjpw84mk6a1r6nf9vzmi";
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."rustc_demangle"."0.1.16" or {});
  };
  features_.rustc_demangle."0.1.16" = deps: f: updateFeatures f (rec {
    rustc_demangle = fold recursiveUpdate {} [
      { "0.1.16"."compiler_builtins" =
        (f.rustc_demangle."0.1.16"."compiler_builtins" or false) ||
        (f.rustc_demangle."0.1.16".rustc-dep-of-std or false) ||
        (rustc_demangle."0.1.16"."rustc-dep-of-std" or false); }
      { "0.1.16"."core" =
        (f.rustc_demangle."0.1.16"."core" or false) ||
        (f.rustc_demangle."0.1.16".rustc-dep-of-std or false) ||
        (rustc_demangle."0.1.16"."rustc-dep-of-std" or false); }
      { "0.1.16".default = (f.rustc_demangle."0.1.16".default or true); }
    ];
  }) [];


# end
# serde-1.0.105

  crates.serde."1.0.105" = deps: { features?(features_.serde."1.0.105" deps {}) }: buildRustCrate {
    crateName = "serde";
    version = "1.0.105";
    description = "A generic serialization/deserialization framework";
    authors = [ "Erick Tryzelaar <erick.tryzelaar@gmail.com>" "David Tolnay <dtolnay@gmail.com>" ];
    sha256 = "17dl5caqh51ypvf1sc1qfkzmr8xyfcsafylndslyxgnlrq04p43i";
    build = "build.rs";
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."serde"."1.0.105" or {});
  };
  features_.serde."1.0.105" = deps: f: updateFeatures f (rec {
    serde = fold recursiveUpdate {} [
      { "1.0.105"."serde_derive" =
        (f.serde."1.0.105"."serde_derive" or false) ||
        (f.serde."1.0.105".derive or false) ||
        (serde."1.0.105"."derive" or false); }
      { "1.0.105"."std" =
        (f.serde."1.0.105"."std" or false) ||
        (f.serde."1.0.105".default or false) ||
        (serde."1.0.105"."default" or false); }
      { "1.0.105".default = (f.serde."1.0.105".default or true); }
    ];
  }) [];


# end
# serde_derive-1.0.105

  crates.serde_derive."1.0.105" = deps: { features?(features_.serde_derive."1.0.105" deps {}) }: buildRustCrate {
    crateName = "serde_derive";
    version = "1.0.105";
    description = "Macros 1.1 implementation of #[derive(Serialize, Deserialize)]";
    authors = [ "Erick Tryzelaar <erick.tryzelaar@gmail.com>" "David Tolnay <dtolnay@gmail.com>" ];
    sha256 = "05k5lp59fmsc4kk09flq0yxy6qd8npm6084m5vl803ahk7w613rc";
    procMacro = true;
    dependencies = mapFeatures features ([
      (crates."proc_macro2"."${deps."serde_derive"."1.0.105"."proc_macro2"}" deps)
      (crates."quote"."${deps."serde_derive"."1.0.105"."quote"}" deps)
      (crates."syn"."${deps."serde_derive"."1.0.105"."syn"}" deps)
    ]);
    features = mkFeatures (features."serde_derive"."1.0.105" or {});
  };
  features_.serde_derive."1.0.105" = deps: f: updateFeatures f (rec {
    proc_macro2."${deps.serde_derive."1.0.105".proc_macro2}".default = true;
    quote."${deps.serde_derive."1.0.105".quote}".default = true;
    serde_derive."1.0.105".default = (f.serde_derive."1.0.105".default or true);
    syn = fold recursiveUpdate {} [
      { "${deps.serde_derive."1.0.105".syn}"."visit" = true; }
      { "${deps.serde_derive."1.0.105".syn}".default = true; }
    ];
  }) [
    (features_.proc_macro2."${deps."serde_derive"."1.0.105"."proc_macro2"}" deps)
    (features_.quote."${deps."serde_derive"."1.0.105"."quote"}" deps)
    (features_.syn."${deps."serde_derive"."1.0.105"."syn"}" deps)
  ];


# end
# serde_yaml-0.8.11

  crates.serde_yaml."0.8.11" = deps: { features?(features_.serde_yaml."0.8.11" deps {}) }: buildRustCrate {
    crateName = "serde_yaml";
    version = "0.8.11";
    description = "YAML support for Serde";
    authors = [ "David Tolnay <dtolnay@gmail.com>" ];
    edition = "2018";
    sha256 = "0727jwg07binrwimzxqpbpp26lyssiy9krrn73sdhal75ba4mzyn";
    dependencies = mapFeatures features ([
      (crates."dtoa"."${deps."serde_yaml"."0.8.11"."dtoa"}" deps)
      (crates."linked_hash_map"."${deps."serde_yaml"."0.8.11"."linked_hash_map"}" deps)
      (crates."serde"."${deps."serde_yaml"."0.8.11"."serde"}" deps)
      (crates."yaml_rust"."${deps."serde_yaml"."0.8.11"."yaml_rust"}" deps)
    ]);
  };
  features_.serde_yaml."0.8.11" = deps: f: updateFeatures f (rec {
    dtoa."${deps.serde_yaml."0.8.11".dtoa}".default = true;
    linked_hash_map."${deps.serde_yaml."0.8.11".linked_hash_map}".default = true;
    serde."${deps.serde_yaml."0.8.11".serde}".default = true;
    serde_yaml."0.8.11".default = (f.serde_yaml."0.8.11".default or true);
    yaml_rust."${deps.serde_yaml."0.8.11".yaml_rust}".default = true;
  }) [
    (features_.dtoa."${deps."serde_yaml"."0.8.11"."dtoa"}" deps)
    (features_.linked_hash_map."${deps."serde_yaml"."0.8.11"."linked_hash_map"}" deps)
    (features_.serde."${deps."serde_yaml"."0.8.11"."serde"}" deps)
    (features_.yaml_rust."${deps."serde_yaml"."0.8.11"."yaml_rust"}" deps)
  ];


# end
# signal-hook-registry-1.2.0

  crates.signal_hook_registry."1.2.0" = deps: { features?(features_.signal_hook_registry."1.2.0" deps {}) }: buildRustCrate {
    crateName = "signal-hook-registry";
    version = "1.2.0";
    description = "Backend crate for signal-hook";
    authors = [ "Michal 'vorner' Vaner <vorner@vorner.cz>" "Masaki Hara <ackie.h.gmai@gmail.com>" ];
    sha256 = "0sap7brbb8fp3641nrvfm4rk024hjcmxix0y0zn9sc8vgvnfivxb";
    dependencies = mapFeatures features ([
      (crates."arc_swap"."${deps."signal_hook_registry"."1.2.0"."arc_swap"}" deps)
      (crates."libc"."${deps."signal_hook_registry"."1.2.0"."libc"}" deps)
    ]);
  };
  features_.signal_hook_registry."1.2.0" = deps: f: updateFeatures f (rec {
    arc_swap."${deps.signal_hook_registry."1.2.0".arc_swap}".default = true;
    libc."${deps.signal_hook_registry."1.2.0".libc}".default = true;
    signal_hook_registry."1.2.0".default = (f.signal_hook_registry."1.2.0".default or true);
  }) [
    (features_.arc_swap."${deps."signal_hook_registry"."1.2.0"."arc_swap"}" deps)
    (features_.libc."${deps."signal_hook_registry"."1.2.0"."libc"}" deps)
  ];


# end
# slab-0.4.2

  crates.slab."0.4.2" = deps: { features?(features_.slab."0.4.2" deps {}) }: buildRustCrate {
    crateName = "slab";
    version = "0.4.2";
    description = "Pre-allocated storage for a uniform data type";
    authors = [ "Carl Lerche <me@carllerche.com>" ];
    sha256 = "0h1l2z7qy6207kv0v3iigdf2xfk9yrhbwj1svlxk6wxjmdxvgdl7";
  };
  features_.slab."0.4.2" = deps: f: updateFeatures f (rec {
    slab."0.4.2".default = (f.slab."0.4.2".default or true);
  }) [];


# end
# socket2-0.3.11

  crates.socket2."0.3.11" = deps: { features?(features_.socket2."0.3.11" deps {}) }: buildRustCrate {
    crateName = "socket2";
    version = "0.3.11";
    description = "Utilities for handling networking sockets with a maximal amount of configuration\npossible intended.\n";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    edition = "2018";
    sha256 = "06v07j2i8miv484vdgbj0k6npk6115x756yi0x3gvd3424nj3yjx";
    dependencies = (if (kernel == "linux" || kernel == "darwin") || kernel == "redox" then mapFeatures features ([
      (crates."cfg_if"."${deps."socket2"."0.3.11"."cfg_if"}" deps)
      (crates."libc"."${deps."socket2"."0.3.11"."libc"}" deps)
    ]) else [])
      ++ (if kernel == "redox" then mapFeatures features ([
      (crates."redox_syscall"."${deps."socket2"."0.3.11"."redox_syscall"}" deps)
    ]) else [])
      ++ (if kernel == "windows" then mapFeatures features ([
      (crates."winapi"."${deps."socket2"."0.3.11"."winapi"}" deps)
    ]) else []);
    features = mkFeatures (features."socket2"."0.3.11" or {});
  };
  features_.socket2."0.3.11" = deps: f: updateFeatures f (rec {
    cfg_if."${deps.socket2."0.3.11".cfg_if}".default = true;
    libc."${deps.socket2."0.3.11".libc}".default = true;
    redox_syscall."${deps.socket2."0.3.11".redox_syscall}".default = true;
    socket2."0.3.11".default = (f.socket2."0.3.11".default or true);
    winapi = fold recursiveUpdate {} [
      { "${deps.socket2."0.3.11".winapi}"."handleapi" = true; }
      { "${deps.socket2."0.3.11".winapi}"."minwindef" = true; }
      { "${deps.socket2."0.3.11".winapi}"."ws2def" = true; }
      { "${deps.socket2."0.3.11".winapi}"."ws2ipdef" = true; }
      { "${deps.socket2."0.3.11".winapi}"."ws2tcpip" = true; }
      { "${deps.socket2."0.3.11".winapi}".default = true; }
    ];
  }) [
    (features_.cfg_if."${deps."socket2"."0.3.11"."cfg_if"}" deps)
    (features_.libc."${deps."socket2"."0.3.11"."libc"}" deps)
    (features_.redox_syscall."${deps."socket2"."0.3.11"."redox_syscall"}" deps)
    (features_.winapi."${deps."socket2"."0.3.11"."winapi"}" deps)
  ];


# end
# syn-1.0.17

  crates.syn."1.0.17" = deps: { features?(features_.syn."1.0.17" deps {}) }: buildRustCrate {
    crateName = "syn";
    version = "1.0.17";
    description = "Parser for Rust source code";
    authors = [ "David Tolnay <dtolnay@gmail.com>" ];
    edition = "2018";
    sha256 = "1vd0ixzqffdr6cb49fvwcrhrbd5a9zlrzkifp166fz0ci940ga6h";
    dependencies = mapFeatures features ([
      (crates."proc_macro2"."${deps."syn"."1.0.17"."proc_macro2"}" deps)
      (crates."unicode_xid"."${deps."syn"."1.0.17"."unicode_xid"}" deps)
    ]
      ++ (if features.syn."1.0.17".quote or false then [ (crates.quote."${deps."syn"."1.0.17".quote}" deps) ] else []));
    features = mkFeatures (features."syn"."1.0.17" or {});
  };
  features_.syn."1.0.17" = deps: f: updateFeatures f (rec {
    proc_macro2 = fold recursiveUpdate {} [
      { "${deps.syn."1.0.17".proc_macro2}"."proc-macro" =
        (f.proc_macro2."${deps.syn."1.0.17".proc_macro2}"."proc-macro" or false) ||
        (syn."1.0.17"."proc-macro" or false) ||
        (f."syn"."1.0.17"."proc-macro" or false); }
      { "${deps.syn."1.0.17".proc_macro2}".default = (f.proc_macro2."${deps.syn."1.0.17".proc_macro2}".default or false); }
    ];
    quote = fold recursiveUpdate {} [
      { "${deps.syn."1.0.17".quote}"."proc-macro" =
        (f.quote."${deps.syn."1.0.17".quote}"."proc-macro" or false) ||
        (syn."1.0.17"."proc-macro" or false) ||
        (f."syn"."1.0.17"."proc-macro" or false); }
      { "${deps.syn."1.0.17".quote}".default = (f.quote."${deps.syn."1.0.17".quote}".default or false); }
    ];
    syn = fold recursiveUpdate {} [
      { "1.0.17"."clone-impls" =
        (f.syn."1.0.17"."clone-impls" or false) ||
        (f.syn."1.0.17".default or false) ||
        (syn."1.0.17"."default" or false); }
      { "1.0.17"."derive" =
        (f.syn."1.0.17"."derive" or false) ||
        (f.syn."1.0.17".default or false) ||
        (syn."1.0.17"."default" or false); }
      { "1.0.17"."parsing" =
        (f.syn."1.0.17"."parsing" or false) ||
        (f.syn."1.0.17".default or false) ||
        (syn."1.0.17"."default" or false); }
      { "1.0.17"."printing" =
        (f.syn."1.0.17"."printing" or false) ||
        (f.syn."1.0.17".default or false) ||
        (syn."1.0.17"."default" or false); }
      { "1.0.17"."proc-macro" =
        (f.syn."1.0.17"."proc-macro" or false) ||
        (f.syn."1.0.17".default or false) ||
        (syn."1.0.17"."default" or false); }
      { "1.0.17"."quote" =
        (f.syn."1.0.17"."quote" or false) ||
        (f.syn."1.0.17".printing or false) ||
        (syn."1.0.17"."printing" or false); }
      { "1.0.17".default = (f.syn."1.0.17".default or true); }
    ];
    unicode_xid."${deps.syn."1.0.17".unicode_xid}".default = true;
  }) [
    (features_.proc_macro2."${deps."syn"."1.0.17"."proc_macro2"}" deps)
    (features_.quote."${deps."syn"."1.0.17"."quote"}" deps)
    (features_.unicode_xid."${deps."syn"."1.0.17"."unicode_xid"}" deps)
  ];


# end
# synstructure-0.12.3

  crates.synstructure."0.12.3" = deps: { features?(features_.synstructure."0.12.3" deps {}) }: buildRustCrate {
    crateName = "synstructure";
    version = "0.12.3";
    description = "Helper methods and macros for custom derives";
    authors = [ "Nika Layzell <nika@thelayzells.com>" ];
    edition = "2018";
    sha256 = "1mi3yl5h54wkarzbm4ma4b3dqfjiy8rlvags4qxqhsy3j850rmcy";
    dependencies = mapFeatures features ([
      (crates."proc_macro2"."${deps."synstructure"."0.12.3"."proc_macro2"}" deps)
      (crates."quote"."${deps."synstructure"."0.12.3"."quote"}" deps)
      (crates."syn"."${deps."synstructure"."0.12.3"."syn"}" deps)
      (crates."unicode_xid"."${deps."synstructure"."0.12.3"."unicode_xid"}" deps)
    ]);
    features = mkFeatures (features."synstructure"."0.12.3" or {});
  };
  features_.synstructure."0.12.3" = deps: f: updateFeatures f (rec {
    proc_macro2 = fold recursiveUpdate {} [
      { "${deps.synstructure."0.12.3".proc_macro2}"."proc-macro" =
        (f.proc_macro2."${deps.synstructure."0.12.3".proc_macro2}"."proc-macro" or false) ||
        (synstructure."0.12.3"."proc-macro" or false) ||
        (f."synstructure"."0.12.3"."proc-macro" or false); }
      { "${deps.synstructure."0.12.3".proc_macro2}".default = (f.proc_macro2."${deps.synstructure."0.12.3".proc_macro2}".default or false); }
    ];
    quote = fold recursiveUpdate {} [
      { "${deps.synstructure."0.12.3".quote}"."proc-macro" =
        (f.quote."${deps.synstructure."0.12.3".quote}"."proc-macro" or false) ||
        (synstructure."0.12.3"."proc-macro" or false) ||
        (f."synstructure"."0.12.3"."proc-macro" or false); }
      { "${deps.synstructure."0.12.3".quote}".default = (f.quote."${deps.synstructure."0.12.3".quote}".default or false); }
    ];
    syn = fold recursiveUpdate {} [
      { "${deps.synstructure."0.12.3".syn}"."clone-impls" = true; }
      { "${deps.synstructure."0.12.3".syn}"."derive" = true; }
      { "${deps.synstructure."0.12.3".syn}"."extra-traits" = true; }
      { "${deps.synstructure."0.12.3".syn}"."parsing" = true; }
      { "${deps.synstructure."0.12.3".syn}"."printing" = true; }
      { "${deps.synstructure."0.12.3".syn}"."proc-macro" =
        (f.syn."${deps.synstructure."0.12.3".syn}"."proc-macro" or false) ||
        (synstructure."0.12.3"."proc-macro" or false) ||
        (f."synstructure"."0.12.3"."proc-macro" or false); }
      { "${deps.synstructure."0.12.3".syn}"."visit" = true; }
      { "${deps.synstructure."0.12.3".syn}".default = (f.syn."${deps.synstructure."0.12.3".syn}".default or false); }
    ];
    synstructure = fold recursiveUpdate {} [
      { "0.12.3"."proc-macro" =
        (f.synstructure."0.12.3"."proc-macro" or false) ||
        (f.synstructure."0.12.3".default or false) ||
        (synstructure."0.12.3"."default" or false); }
      { "0.12.3".default = (f.synstructure."0.12.3".default or true); }
    ];
    unicode_xid."${deps.synstructure."0.12.3".unicode_xid}".default = true;
  }) [
    (features_.proc_macro2."${deps."synstructure"."0.12.3"."proc_macro2"}" deps)
    (features_.quote."${deps."synstructure"."0.12.3"."quote"}" deps)
    (features_.syn."${deps."synstructure"."0.12.3"."syn"}" deps)
    (features_.unicode_xid."${deps."synstructure"."0.12.3"."unicode_xid"}" deps)
  ];


# end
# tempfile-3.1.0

  crates.tempfile."3.1.0" = deps: { features?(features_.tempfile."3.1.0" deps {}) }: buildRustCrate {
    crateName = "tempfile";
    version = "3.1.0";
    description = "A library for managing temporary files and directories.";
    authors = [ "Steven Allen <steven@stebalien.com>" "The Rust Project Developers" "Ashley Mannix <ashleymannix@live.com.au>" "Jason White <jasonaw0@gmail.com>" ];
    edition = "2018";
    sha256 = "1r7ykxw90p5hm1g46i8ia33j5iwl3q252kbb6b074qhdav3sqndk";
    dependencies = mapFeatures features ([
      (crates."cfg_if"."${deps."tempfile"."3.1.0"."cfg_if"}" deps)
      (crates."rand"."${deps."tempfile"."3.1.0"."rand"}" deps)
      (crates."remove_dir_all"."${deps."tempfile"."3.1.0"."remove_dir_all"}" deps)
    ])
      ++ (if kernel == "redox" then mapFeatures features ([
      (crates."redox_syscall"."${deps."tempfile"."3.1.0"."redox_syscall"}" deps)
    ]) else [])
      ++ (if (kernel == "linux" || kernel == "darwin") then mapFeatures features ([
      (crates."libc"."${deps."tempfile"."3.1.0"."libc"}" deps)
    ]) else [])
      ++ (if kernel == "windows" then mapFeatures features ([
      (crates."winapi"."${deps."tempfile"."3.1.0"."winapi"}" deps)
    ]) else []);
  };
  features_.tempfile."3.1.0" = deps: f: updateFeatures f (rec {
    cfg_if."${deps.tempfile."3.1.0".cfg_if}".default = true;
    libc."${deps.tempfile."3.1.0".libc}".default = true;
    rand."${deps.tempfile."3.1.0".rand}".default = true;
    redox_syscall."${deps.tempfile."3.1.0".redox_syscall}".default = true;
    remove_dir_all."${deps.tempfile."3.1.0".remove_dir_all}".default = true;
    tempfile."3.1.0".default = (f.tempfile."3.1.0".default or true);
    winapi = fold recursiveUpdate {} [
      { "${deps.tempfile."3.1.0".winapi}"."fileapi" = true; }
      { "${deps.tempfile."3.1.0".winapi}"."handleapi" = true; }
      { "${deps.tempfile."3.1.0".winapi}"."winbase" = true; }
      { "${deps.tempfile."3.1.0".winapi}".default = true; }
    ];
  }) [
    (features_.cfg_if."${deps."tempfile"."3.1.0"."cfg_if"}" deps)
    (features_.rand."${deps."tempfile"."3.1.0"."rand"}" deps)
    (features_.remove_dir_all."${deps."tempfile"."3.1.0"."remove_dir_all"}" deps)
    (features_.redox_syscall."${deps."tempfile"."3.1.0"."redox_syscall"}" deps)
    (features_.libc."${deps."tempfile"."3.1.0"."libc"}" deps)
    (features_.winapi."${deps."tempfile"."3.1.0"."winapi"}" deps)
  ];


# end
# termcolor-1.1.0

  crates.termcolor."1.1.0" = deps: { features?(features_.termcolor."1.1.0" deps {}) }: buildRustCrate {
    crateName = "termcolor";
    version = "1.1.0";
    description = "A simple cross platform library for writing colored text to a terminal.\n";
    authors = [ "Andrew Gallant <jamslam@gmail.com>" ];
    edition = "2018";
    sha256 = "10ckhcj1pv4xgxrvby0j1fccanfnyc4fwdlvqr9gm4k35yx0ssci";
    dependencies = (if kernel == "windows" then mapFeatures features ([
      (crates."winapi_util"."${deps."termcolor"."1.1.0"."winapi_util"}" deps)
    ]) else []);
  };
  features_.termcolor."1.1.0" = deps: f: updateFeatures f (rec {
    termcolor."1.1.0".default = (f.termcolor."1.1.0".default or true);
    winapi_util."${deps.termcolor."1.1.0".winapi_util}".default = true;
  }) [
    (features_.winapi_util."${deps."termcolor"."1.1.0"."winapi_util"}" deps)
  ];


# end
# thread_local-1.0.1

  crates.thread_local."1.0.1" = deps: { features?(features_.thread_local."1.0.1" deps {}) }: buildRustCrate {
    crateName = "thread_local";
    version = "1.0.1";
    description = "Per-object thread-local storage";
    authors = [ "Amanieu d'Antras <amanieu@gmail.com>" ];
    sha256 = "0vs440x0nwpsw30ks6b8f70178y0gl7zhrqydhjykrhn56bj57h7";
    dependencies = mapFeatures features ([
      (crates."lazy_static"."${deps."thread_local"."1.0.1"."lazy_static"}" deps)
    ]);
  };
  features_.thread_local."1.0.1" = deps: f: updateFeatures f (rec {
    lazy_static."${deps.thread_local."1.0.1".lazy_static}".default = true;
    thread_local."1.0.1".default = (f.thread_local."1.0.1".default or true);
  }) [
    (features_.lazy_static."${deps."thread_local"."1.0.1"."lazy_static"}" deps)
  ];


# end
# time-0.1.42

  crates.time."0.1.42" = deps: { features?(features_.time."0.1.42" deps {}) }: buildRustCrate {
    crateName = "time";
    version = "0.1.42";
    description = "Utilities for working with time-related functions in Rust.\n";
    authors = [ "The Rust Project Developers" ];
    sha256 = "1ny809kmdjwd4b478ipc33dz7q6nq7rxk766x8cnrg6zygcksmmx";
    dependencies = mapFeatures features ([
      (crates."libc"."${deps."time"."0.1.42"."libc"}" deps)
    ])
      ++ (if kernel == "redox" then mapFeatures features ([
      (crates."redox_syscall"."${deps."time"."0.1.42"."redox_syscall"}" deps)
    ]) else [])
      ++ (if kernel == "windows" then mapFeatures features ([
      (crates."winapi"."${deps."time"."0.1.42"."winapi"}" deps)
    ]) else []);
  };
  features_.time."0.1.42" = deps: f: updateFeatures f (rec {
    libc."${deps.time."0.1.42".libc}".default = true;
    redox_syscall."${deps.time."0.1.42".redox_syscall}".default = true;
    time."0.1.42".default = (f.time."0.1.42".default or true);
    winapi = fold recursiveUpdate {} [
      { "${deps.time."0.1.42".winapi}"."minwinbase" = true; }
      { "${deps.time."0.1.42".winapi}"."minwindef" = true; }
      { "${deps.time."0.1.42".winapi}"."ntdef" = true; }
      { "${deps.time."0.1.42".winapi}"."profileapi" = true; }
      { "${deps.time."0.1.42".winapi}"."std" = true; }
      { "${deps.time."0.1.42".winapi}"."sysinfoapi" = true; }
      { "${deps.time."0.1.42".winapi}"."timezoneapi" = true; }
      { "${deps.time."0.1.42".winapi}".default = true; }
    ];
  }) [
    (features_.libc."${deps."time"."0.1.42"."libc"}" deps)
    (features_.redox_syscall."${deps."time"."0.1.42"."redox_syscall"}" deps)
    (features_.winapi."${deps."time"."0.1.42"."winapi"}" deps)
  ];


# end
# tokio-0.2.13

  crates.tokio."0.2.13" = deps: { features?(features_.tokio."0.2.13" deps {}) }: buildRustCrate {
    crateName = "tokio";
    version = "0.2.13";
    description = "An event-driven, non-blocking I/O platform for writing asynchronous I/O\nbacked applications.\n";
    authors = [ "Tokio Contributors <team@tokio.rs>" ];
    edition = "2018";
    sha256 = "0dr3lbg1r2pmmjl8w28y1886ir3dygi8jqijlbjjbxsc0dwcbc3j";
    dependencies = mapFeatures features ([
      (crates."bytes"."${deps."tokio"."0.2.13"."bytes"}" deps)
      (crates."pin_project_lite"."${deps."tokio"."0.2.13"."pin_project_lite"}" deps)
    ]
      ++ (if features.tokio."0.2.13".fnv or false then [ (crates.fnv."${deps."tokio"."0.2.13".fnv}" deps) ] else [])
      ++ (if features.tokio."0.2.13".iovec or false then [ (crates.iovec."${deps."tokio"."0.2.13".iovec}" deps) ] else [])
      ++ (if features.tokio."0.2.13".lazy_static or false then [ (crates.lazy_static."${deps."tokio"."0.2.13".lazy_static}" deps) ] else [])
      ++ (if features.tokio."0.2.13".memchr or false then [ (crates.memchr."${deps."tokio"."0.2.13".memchr}" deps) ] else [])
      ++ (if features.tokio."0.2.13".mio or false then [ (crates.mio."${deps."tokio"."0.2.13".mio}" deps) ] else [])
      ++ (if features.tokio."0.2.13".num_cpus or false then [ (crates.num_cpus."${deps."tokio"."0.2.13".num_cpus}" deps) ] else [])
      ++ (if features.tokio."0.2.13".slab or false then [ (crates.slab."${deps."tokio"."0.2.13".slab}" deps) ] else [])
      ++ (if features.tokio."0.2.13".tokio-macros or false then [ (crates.tokio_macros."${deps."tokio"."0.2.13".tokio_macros}" deps) ] else []))
      ++ (if !(kernel == "windows") then mapFeatures features ([
]) else [])
      ++ (if (kernel == "linux" || kernel == "darwin") then mapFeatures features ([
    ]
      ++ (if features.tokio."0.2.13".libc or false then [ (crates.libc."${deps."tokio"."0.2.13".libc}" deps) ] else [])
      ++ (if features.tokio."0.2.13".mio-uds or false then [ (crates.mio_uds."${deps."tokio"."0.2.13".mio_uds}" deps) ] else [])
      ++ (if features.tokio."0.2.13".signal-hook-registry or false then [ (crates.signal_hook_registry."${deps."tokio"."0.2.13".signal_hook_registry}" deps) ] else [])) else [])
      ++ (if kernel == "windows" then mapFeatures features ([
    ]
      ++ (if features.tokio."0.2.13".mio-named-pipes or false then [ (crates.mio_named_pipes."${deps."tokio"."0.2.13".mio_named_pipes}" deps) ] else [])
      ++ (if features.tokio."0.2.13".winapi or false then [ (crates.winapi."${deps."tokio"."0.2.13".winapi}" deps) ] else [])) else []);
    features = mkFeatures (features."tokio"."0.2.13" or {});
  };
  features_.tokio."0.2.13" = deps: f: updateFeatures f (rec {
    bytes."${deps.tokio."0.2.13".bytes}".default = true;
    fnv."${deps.tokio."0.2.13".fnv}".default = true;
    iovec."${deps.tokio."0.2.13".iovec}".default = true;
    lazy_static."${deps.tokio."0.2.13".lazy_static}".default = true;
    libc."${deps.tokio."0.2.13".libc}".default = true;
    memchr."${deps.tokio."0.2.13".memchr}".default = true;
    mio."${deps.tokio."0.2.13".mio}".default = true;
    mio_named_pipes."${deps.tokio."0.2.13".mio_named_pipes}".default = true;
    mio_uds."${deps.tokio."0.2.13".mio_uds}".default = true;
    num_cpus."${deps.tokio."0.2.13".num_cpus}".default = true;
    pin_project_lite."${deps.tokio."0.2.13".pin_project_lite}".default = true;
    signal_hook_registry."${deps.tokio."0.2.13".signal_hook_registry}".default = true;
    slab."${deps.tokio."0.2.13".slab}".default = true;
    tokio = fold recursiveUpdate {} [
      { "0.2.13"."blocking" =
        (f.tokio."0.2.13"."blocking" or false) ||
        (f.tokio."0.2.13".full or false) ||
        (tokio."0.2.13"."full" or false); }
      { "0.2.13"."dns" =
        (f.tokio."0.2.13"."dns" or false) ||
        (f.tokio."0.2.13".full or false) ||
        (tokio."0.2.13"."full" or false) ||
        (f.tokio."0.2.13".net or false) ||
        (tokio."0.2.13"."net" or false); }
      { "0.2.13"."fnv" =
        (f.tokio."0.2.13"."fnv" or false) ||
        (f.tokio."0.2.13".sync or false) ||
        (tokio."0.2.13"."sync" or false); }
      { "0.2.13"."fs" =
        (f.tokio."0.2.13"."fs" or false) ||
        (f.tokio."0.2.13".full or false) ||
        (tokio."0.2.13"."full" or false); }
      { "0.2.13"."futures-core" =
        (f.tokio."0.2.13"."futures-core" or false) ||
        (f.tokio."0.2.13".stream or false) ||
        (tokio."0.2.13"."stream" or false); }
      { "0.2.13"."io-driver" =
        (f.tokio."0.2.13"."io-driver" or false) ||
        (f.tokio."0.2.13".full or false) ||
        (tokio."0.2.13"."full" or false) ||
        (f.tokio."0.2.13".process or false) ||
        (tokio."0.2.13"."process" or false) ||
        (f.tokio."0.2.13".signal or false) ||
        (tokio."0.2.13"."signal" or false) ||
        (f.tokio."0.2.13".tcp or false) ||
        (tokio."0.2.13"."tcp" or false) ||
        (f.tokio."0.2.13".udp or false) ||
        (tokio."0.2.13"."udp" or false) ||
        (f.tokio."0.2.13".uds or false) ||
        (tokio."0.2.13"."uds" or false); }
      { "0.2.13"."io-std" =
        (f.tokio."0.2.13"."io-std" or false) ||
        (f.tokio."0.2.13".full or false) ||
        (tokio."0.2.13"."full" or false); }
      { "0.2.13"."io-util" =
        (f.tokio."0.2.13"."io-util" or false) ||
        (f.tokio."0.2.13".fs or false) ||
        (tokio."0.2.13"."fs" or false) ||
        (f.tokio."0.2.13".full or false) ||
        (tokio."0.2.13"."full" or false); }
      { "0.2.13"."iovec" =
        (f.tokio."0.2.13"."iovec" or false) ||
        (f.tokio."0.2.13".tcp or false) ||
        (tokio."0.2.13"."tcp" or false); }
      { "0.2.13"."lazy_static" =
        (f.tokio."0.2.13"."lazy_static" or false) ||
        (f.tokio."0.2.13".io-driver or false) ||
        (tokio."0.2.13"."io-driver" or false) ||
        (f.tokio."0.2.13".signal or false) ||
        (tokio."0.2.13"."signal" or false); }
      { "0.2.13"."libc" =
        (f.tokio."0.2.13"."libc" or false) ||
        (f.tokio."0.2.13".process or false) ||
        (tokio."0.2.13"."process" or false) ||
        (f.tokio."0.2.13".signal or false) ||
        (tokio."0.2.13"."signal" or false) ||
        (f.tokio."0.2.13".uds or false) ||
        (tokio."0.2.13"."uds" or false); }
      { "0.2.13"."macros" =
        (f.tokio."0.2.13"."macros" or false) ||
        (f.tokio."0.2.13".full or false) ||
        (tokio."0.2.13"."full" or false); }
      { "0.2.13"."memchr" =
        (f.tokio."0.2.13"."memchr" or false) ||
        (f.tokio."0.2.13".io-util or false) ||
        (tokio."0.2.13"."io-util" or false); }
      { "0.2.13"."mio" =
        (f.tokio."0.2.13"."mio" or false) ||
        (f.tokio."0.2.13".io-driver or false) ||
        (tokio."0.2.13"."io-driver" or false); }
      { "0.2.13"."mio-named-pipes" =
        (f.tokio."0.2.13"."mio-named-pipes" or false) ||
        (f.tokio."0.2.13".process or false) ||
        (tokio."0.2.13"."process" or false); }
      { "0.2.13"."mio-uds" =
        (f.tokio."0.2.13"."mio-uds" or false) ||
        (f.tokio."0.2.13".signal or false) ||
        (tokio."0.2.13"."signal" or false) ||
        (f.tokio."0.2.13".uds or false) ||
        (tokio."0.2.13"."uds" or false); }
      { "0.2.13"."net" =
        (f.tokio."0.2.13"."net" or false) ||
        (f.tokio."0.2.13".full or false) ||
        (tokio."0.2.13"."full" or false); }
      { "0.2.13"."num_cpus" =
        (f.tokio."0.2.13"."num_cpus" or false) ||
        (f.tokio."0.2.13".rt-threaded or false) ||
        (tokio."0.2.13"."rt-threaded" or false); }
      { "0.2.13"."process" =
        (f.tokio."0.2.13"."process" or false) ||
        (f.tokio."0.2.13".full or false) ||
        (tokio."0.2.13"."full" or false); }
      { "0.2.13"."rt-core" =
        (f.tokio."0.2.13"."rt-core" or false) ||
        (f.tokio."0.2.13".blocking or false) ||
        (tokio."0.2.13"."blocking" or false) ||
        (f.tokio."0.2.13".dns or false) ||
        (tokio."0.2.13"."dns" or false) ||
        (f.tokio."0.2.13".fs or false) ||
        (tokio."0.2.13"."fs" or false) ||
        (f.tokio."0.2.13".full or false) ||
        (tokio."0.2.13"."full" or false) ||
        (f.tokio."0.2.13".io-std or false) ||
        (tokio."0.2.13"."io-std" or false) ||
        (f.tokio."0.2.13".rt-threaded or false) ||
        (tokio."0.2.13"."rt-threaded" or false); }
      { "0.2.13"."rt-threaded" =
        (f.tokio."0.2.13"."rt-threaded" or false) ||
        (f.tokio."0.2.13".full or false) ||
        (tokio."0.2.13"."full" or false); }
      { "0.2.13"."rt-util" =
        (f.tokio."0.2.13"."rt-util" or false) ||
        (f.tokio."0.2.13".full or false) ||
        (tokio."0.2.13"."full" or false); }
      { "0.2.13"."signal" =
        (f.tokio."0.2.13"."signal" or false) ||
        (f.tokio."0.2.13".full or false) ||
        (tokio."0.2.13"."full" or false) ||
        (f.tokio."0.2.13".process or false) ||
        (tokio."0.2.13"."process" or false); }
      { "0.2.13"."signal-hook-registry" =
        (f.tokio."0.2.13"."signal-hook-registry" or false) ||
        (f.tokio."0.2.13".signal or false) ||
        (tokio."0.2.13"."signal" or false); }
      { "0.2.13"."slab" =
        (f.tokio."0.2.13"."slab" or false) ||
        (f.tokio."0.2.13".time or false) ||
        (tokio."0.2.13"."time" or false); }
      { "0.2.13"."stream" =
        (f.tokio."0.2.13"."stream" or false) ||
        (f.tokio."0.2.13".full or false) ||
        (tokio."0.2.13"."full" or false); }
      { "0.2.13"."sync" =
        (f.tokio."0.2.13"."sync" or false) ||
        (f.tokio."0.2.13".full or false) ||
        (tokio."0.2.13"."full" or false); }
      { "0.2.13"."tcp" =
        (f.tokio."0.2.13"."tcp" or false) ||
        (f.tokio."0.2.13".net or false) ||
        (tokio."0.2.13"."net" or false); }
      { "0.2.13"."time" =
        (f.tokio."0.2.13"."time" or false) ||
        (f.tokio."0.2.13".full or false) ||
        (tokio."0.2.13"."full" or false); }
      { "0.2.13"."tokio-macros" =
        (f.tokio."0.2.13"."tokio-macros" or false) ||
        (f.tokio."0.2.13".macros or false) ||
        (tokio."0.2.13"."macros" or false); }
      { "0.2.13"."udp" =
        (f.tokio."0.2.13"."udp" or false) ||
        (f.tokio."0.2.13".net or false) ||
        (tokio."0.2.13"."net" or false); }
      { "0.2.13"."uds" =
        (f.tokio."0.2.13"."uds" or false) ||
        (f.tokio."0.2.13".net or false) ||
        (tokio."0.2.13"."net" or false); }
      { "0.2.13".default = (f.tokio."0.2.13".default or true); }
    ];
    tokio_macros."${deps.tokio."0.2.13".tokio_macros}".default = true;
    winapi."${deps.tokio."0.2.13".winapi}".default = (f.winapi."${deps.tokio."0.2.13".winapi}".default or false);
  }) [
    (features_.bytes."${deps."tokio"."0.2.13"."bytes"}" deps)
    (features_.fnv."${deps."tokio"."0.2.13"."fnv"}" deps)
    (features_.iovec."${deps."tokio"."0.2.13"."iovec"}" deps)
    (features_.lazy_static."${deps."tokio"."0.2.13"."lazy_static"}" deps)
    (features_.memchr."${deps."tokio"."0.2.13"."memchr"}" deps)
    (features_.mio."${deps."tokio"."0.2.13"."mio"}" deps)
    (features_.num_cpus."${deps."tokio"."0.2.13"."num_cpus"}" deps)
    (features_.pin_project_lite."${deps."tokio"."0.2.13"."pin_project_lite"}" deps)
    (features_.slab."${deps."tokio"."0.2.13"."slab"}" deps)
    (features_.tokio_macros."${deps."tokio"."0.2.13"."tokio_macros"}" deps)
    (features_.libc."${deps."tokio"."0.2.13"."libc"}" deps)
    (features_.mio_uds."${deps."tokio"."0.2.13"."mio_uds"}" deps)
    (features_.signal_hook_registry."${deps."tokio"."0.2.13"."signal_hook_registry"}" deps)
    (features_.mio_named_pipes."${deps."tokio"."0.2.13"."mio_named_pipes"}" deps)
    (features_.winapi."${deps."tokio"."0.2.13"."winapi"}" deps)
  ];


# end
# tokio-macros-0.2.5

  crates.tokio_macros."0.2.5" = deps: { features?(features_.tokio_macros."0.2.5" deps {}) }: buildRustCrate {
    crateName = "tokio-macros";
    version = "0.2.5";
    description = "Tokio's proc macros.\n";
    authors = [ "Tokio Contributors <team@tokio.rs>" ];
    edition = "2018";
    sha256 = "18yjsc90y6a8n3x4hk0krwqwhik8q8fsdz8j465ibsc388s5n38j";
    procMacro = true;
    dependencies = mapFeatures features ([
      (crates."proc_macro2"."${deps."tokio_macros"."0.2.5"."proc_macro2"}" deps)
      (crates."quote"."${deps."tokio_macros"."0.2.5"."quote"}" deps)
      (crates."syn"."${deps."tokio_macros"."0.2.5"."syn"}" deps)
    ]);
  };
  features_.tokio_macros."0.2.5" = deps: f: updateFeatures f (rec {
    proc_macro2."${deps.tokio_macros."0.2.5".proc_macro2}".default = true;
    quote."${deps.tokio_macros."0.2.5".quote}".default = true;
    syn = fold recursiveUpdate {} [
      { "${deps.tokio_macros."0.2.5".syn}"."full" = true; }
      { "${deps.tokio_macros."0.2.5".syn}".default = true; }
    ];
    tokio_macros."0.2.5".default = (f.tokio_macros."0.2.5".default or true);
  }) [
    (features_.proc_macro2."${deps."tokio_macros"."0.2.5"."proc_macro2"}" deps)
    (features_.quote."${deps."tokio_macros"."0.2.5"."quote"}" deps)
    (features_.syn."${deps."tokio_macros"."0.2.5"."syn"}" deps)
  ];


# end
# tokio-util-0.2.0

  crates.tokio_util."0.2.0" = deps: { features?(features_.tokio_util."0.2.0" deps {}) }: buildRustCrate {
    crateName = "tokio-util";
    version = "0.2.0";
    description = "Additional utilities for working with Tokio.\n";
    authors = [ "Tokio Contributors <team@tokio.rs>" ];
    edition = "2018";
    sha256 = "1jvqz5shi2gllxdhgfgksazk0cqn0aiiry7wgrdhrz9vgi76976i";
    dependencies = mapFeatures features ([
      (crates."bytes"."${deps."tokio_util"."0.2.0"."bytes"}" deps)
      (crates."futures_core"."${deps."tokio_util"."0.2.0"."futures_core"}" deps)
      (crates."futures_sink"."${deps."tokio_util"."0.2.0"."futures_sink"}" deps)
      (crates."log"."${deps."tokio_util"."0.2.0"."log"}" deps)
      (crates."pin_project_lite"."${deps."tokio_util"."0.2.0"."pin_project_lite"}" deps)
      (crates."tokio"."${deps."tokio_util"."0.2.0"."tokio"}" deps)
    ]);
    features = mkFeatures (features."tokio_util"."0.2.0" or {});
  };
  features_.tokio_util."0.2.0" = deps: f: updateFeatures f (rec {
    bytes."${deps.tokio_util."0.2.0".bytes}".default = true;
    futures_core."${deps.tokio_util."0.2.0".futures_core}".default = true;
    futures_sink."${deps.tokio_util."0.2.0".futures_sink}".default = true;
    log."${deps.tokio_util."0.2.0".log}".default = true;
    pin_project_lite."${deps.tokio_util."0.2.0".pin_project_lite}".default = true;
    tokio = fold recursiveUpdate {} [
      { "${deps.tokio_util."0.2.0".tokio}"."udp" =
        (f.tokio."${deps.tokio_util."0.2.0".tokio}"."udp" or false) ||
        (tokio_util."0.2.0"."udp" or false) ||
        (f."tokio_util"."0.2.0"."udp" or false); }
      { "${deps.tokio_util."0.2.0".tokio}".default = true; }
    ];
    tokio_util = fold recursiveUpdate {} [
      { "0.2.0"."codec" =
        (f.tokio_util."0.2.0"."codec" or false) ||
        (f.tokio_util."0.2.0".full or false) ||
        (tokio_util."0.2.0"."full" or false); }
      { "0.2.0"."udp" =
        (f.tokio_util."0.2.0"."udp" or false) ||
        (f.tokio_util."0.2.0".full or false) ||
        (tokio_util."0.2.0"."full" or false); }
      { "0.2.0".default = (f.tokio_util."0.2.0".default or true); }
    ];
  }) [
    (features_.bytes."${deps."tokio_util"."0.2.0"."bytes"}" deps)
    (features_.futures_core."${deps."tokio_util"."0.2.0"."futures_core"}" deps)
    (features_.futures_sink."${deps."tokio_util"."0.2.0"."futures_sink"}" deps)
    (features_.log."${deps."tokio_util"."0.2.0"."log"}" deps)
    (features_.pin_project_lite."${deps."tokio_util"."0.2.0"."pin_project_lite"}" deps)
    (features_.tokio."${deps."tokio_util"."0.2.0"."tokio"}" deps)
  ];


# end
# tonic-0.1.1

  crates.tonic."0.1.1" = deps: { features?(features_.tonic."0.1.1" deps {}) }: buildRustCrate {
    crateName = "tonic";
    version = "0.1.1";
    description = "A gRPC over HTTP/2 implementation focused on high performance, interoperability, and flexibility.\n";
    authors = [ "Lucio Franco <luciofranco14@gmail.com>" ];
    edition = "2018";
    sha256 = "0yrlgighd7jxsjn657qcg6l8zljgxsz357vs3hcf8f85aqc70s4z";
    dependencies = mapFeatures features ([
      (crates."async_stream"."${deps."tonic"."0.1.1"."async_stream"}" deps)
      (crates."base64"."${deps."tonic"."0.1.1"."base64"}" deps)
      (crates."bytes"."${deps."tonic"."0.1.1"."bytes"}" deps)
      (crates."futures_core"."${deps."tonic"."0.1.1"."futures_core"}" deps)
      (crates."futures_util"."${deps."tonic"."0.1.1"."futures_util"}" deps)
      (crates."http"."${deps."tonic"."0.1.1"."http"}" deps)
      (crates."http_body"."${deps."tonic"."0.1.1"."http_body"}" deps)
      (crates."percent_encoding"."${deps."tonic"."0.1.1"."percent_encoding"}" deps)
      (crates."pin_project"."${deps."tonic"."0.1.1"."pin_project"}" deps)
      (crates."tokio_util"."${deps."tonic"."0.1.1"."tokio_util"}" deps)
      (crates."tower_make"."${deps."tonic"."0.1.1"."tower_make"}" deps)
      (crates."tower_service"."${deps."tonic"."0.1.1"."tower_service"}" deps)
      (crates."tracing"."${deps."tonic"."0.1.1"."tracing"}" deps)
    ]
      ++ (if features.tonic."0.1.1".async-trait or false then [ (crates.async_trait."${deps."tonic"."0.1.1".async_trait}" deps) ] else [])
      ++ (if features.tonic."0.1.1".hyper or false then [ (crates.hyper."${deps."tonic"."0.1.1".hyper}" deps) ] else [])
      ++ (if features.tonic."0.1.1".prost or false then [ (crates.prost."${deps."tonic"."0.1.1".prost}" deps) ] else [])
      ++ (if features.tonic."0.1.1".prost-derive or false then [ (crates.prost_derive."${deps."tonic"."0.1.1".prost_derive}" deps) ] else [])
      ++ (if features.tonic."0.1.1".tokio or false then [ (crates.tokio."${deps."tonic"."0.1.1".tokio}" deps) ] else [])
      ++ (if features.tonic."0.1.1".tower or false then [ (crates.tower."${deps."tonic"."0.1.1".tower}" deps) ] else [])
      ++ (if features.tonic."0.1.1".tower-balance or false then [ (crates.tower_balance."${deps."tonic"."0.1.1".tower_balance}" deps) ] else [])
      ++ (if features.tonic."0.1.1".tower-load or false then [ (crates.tower_load."${deps."tonic"."0.1.1".tower_load}" deps) ] else [])
      ++ (if features.tonic."0.1.1".tracing-futures or false then [ (crates.tracing_futures."${deps."tonic"."0.1.1".tracing_futures}" deps) ] else []));
    features = mkFeatures (features."tonic"."0.1.1" or {});
  };
  features_.tonic."0.1.1" = deps: f: updateFeatures f (rec {
    async_stream."${deps.tonic."0.1.1".async_stream}".default = true;
    async_trait."${deps.tonic."0.1.1".async_trait}".default = true;
    base64."${deps.tonic."0.1.1".base64}".default = true;
    bytes."${deps.tonic."0.1.1".bytes}".default = true;
    futures_core."${deps.tonic."0.1.1".futures_core}".default = (f.futures_core."${deps.tonic."0.1.1".futures_core}".default or false);
    futures_util."${deps.tonic."0.1.1".futures_util}".default = (f.futures_util."${deps.tonic."0.1.1".futures_util}".default or false);
    http."${deps.tonic."0.1.1".http}".default = true;
    http_body."${deps.tonic."0.1.1".http_body}".default = true;
    hyper = fold recursiveUpdate {} [
      { "${deps.tonic."0.1.1".hyper}"."stream" = true; }
      { "${deps.tonic."0.1.1".hyper}".default = true; }
    ];
    percent_encoding."${deps.tonic."0.1.1".percent_encoding}".default = true;
    pin_project."${deps.tonic."0.1.1".pin_project}".default = true;
    prost."${deps.tonic."0.1.1".prost}".default = true;
    prost_derive."${deps.tonic."0.1.1".prost_derive}".default = true;
    tokio = fold recursiveUpdate {} [
      { "${deps.tonic."0.1.1".tokio}"."tcp" = true; }
      { "${deps.tonic."0.1.1".tokio}".default = true; }
    ];
    tokio_util = fold recursiveUpdate {} [
      { "${deps.tonic."0.1.1".tokio_util}"."codec" = true; }
      { "${deps.tonic."0.1.1".tokio_util}".default = true; }
    ];
    tonic = fold recursiveUpdate {} [
      { "0.1.1"."async-trait" =
        (f.tonic."0.1.1"."async-trait" or false) ||
        (f.tonic."0.1.1".codegen or false) ||
        (tonic."0.1.1"."codegen" or false); }
      { "0.1.1"."codegen" =
        (f.tonic."0.1.1"."codegen" or false) ||
        (f.tonic."0.1.1".default or false) ||
        (tonic."0.1.1"."default" or false); }
      { "0.1.1"."hyper" =
        (f.tonic."0.1.1"."hyper" or false) ||
        (f.tonic."0.1.1".transport or false) ||
        (tonic."0.1.1"."transport" or false); }
      { "0.1.1"."prost" =
        (f.tonic."0.1.1"."prost" or false) ||
        (f.tonic."0.1.1".codegen or false) ||
        (tonic."0.1.1"."codegen" or false); }
      { "0.1.1"."prost-derive" =
        (f.tonic."0.1.1"."prost-derive" or false) ||
        (f.tonic."0.1.1".codegen or false) ||
        (tonic."0.1.1"."codegen" or false); }
      { "0.1.1"."rustls-native-certs" =
        (f.tonic."0.1.1"."rustls-native-certs" or false) ||
        (f.tonic."0.1.1".tls-roots or false) ||
        (tonic."0.1.1"."tls-roots" or false); }
      { "0.1.1"."tls" =
        (f.tonic."0.1.1"."tls" or false) ||
        (f.tonic."0.1.1".tls-roots or false) ||
        (tonic."0.1.1"."tls-roots" or false); }
      { "0.1.1"."tokio" =
        (f.tonic."0.1.1"."tokio" or false) ||
        (f.tonic."0.1.1".transport or false) ||
        (tonic."0.1.1"."transport" or false); }
      { "0.1.1"."tokio-rustls" =
        (f.tonic."0.1.1"."tokio-rustls" or false) ||
        (f.tonic."0.1.1".tls or false) ||
        (tonic."0.1.1"."tls" or false); }
      { "0.1.1"."tower" =
        (f.tonic."0.1.1"."tower" or false) ||
        (f.tonic."0.1.1".transport or false) ||
        (tonic."0.1.1"."transport" or false); }
      { "0.1.1"."tower-balance" =
        (f.tonic."0.1.1"."tower-balance" or false) ||
        (f.tonic."0.1.1".transport or false) ||
        (tonic."0.1.1"."transport" or false); }
      { "0.1.1"."tower-load" =
        (f.tonic."0.1.1"."tower-load" or false) ||
        (f.tonic."0.1.1".transport or false) ||
        (tonic."0.1.1"."transport" or false); }
      { "0.1.1"."tracing-futures" =
        (f.tonic."0.1.1"."tracing-futures" or false) ||
        (f.tonic."0.1.1".transport or false) ||
        (tonic."0.1.1"."transport" or false); }
      { "0.1.1"."transport" =
        (f.tonic."0.1.1"."transport" or false) ||
        (f.tonic."0.1.1".default or false) ||
        (tonic."0.1.1"."default" or false) ||
        (f.tonic."0.1.1".tls or false) ||
        (tonic."0.1.1"."tls" or false); }
      { "0.1.1".default = (f.tonic."0.1.1".default or true); }
    ];
    tower."${deps.tonic."0.1.1".tower}".default = true;
    tower_balance."${deps.tonic."0.1.1".tower_balance}".default = true;
    tower_load."${deps.tonic."0.1.1".tower_load}".default = true;
    tower_make = fold recursiveUpdate {} [
      { "${deps.tonic."0.1.1".tower_make}"."connect" = true; }
      { "${deps.tonic."0.1.1".tower_make}".default = true; }
    ];
    tower_service."${deps.tonic."0.1.1".tower_service}".default = true;
    tracing."${deps.tonic."0.1.1".tracing}".default = true;
    tracing_futures."${deps.tonic."0.1.1".tracing_futures}".default = true;
  }) [
    (features_.async_stream."${deps."tonic"."0.1.1"."async_stream"}" deps)
    (features_.async_trait."${deps."tonic"."0.1.1"."async_trait"}" deps)
    (features_.base64."${deps."tonic"."0.1.1"."base64"}" deps)
    (features_.bytes."${deps."tonic"."0.1.1"."bytes"}" deps)
    (features_.futures_core."${deps."tonic"."0.1.1"."futures_core"}" deps)
    (features_.futures_util."${deps."tonic"."0.1.1"."futures_util"}" deps)
    (features_.http."${deps."tonic"."0.1.1"."http"}" deps)
    (features_.http_body."${deps."tonic"."0.1.1"."http_body"}" deps)
    (features_.hyper."${deps."tonic"."0.1.1"."hyper"}" deps)
    (features_.percent_encoding."${deps."tonic"."0.1.1"."percent_encoding"}" deps)
    (features_.pin_project."${deps."tonic"."0.1.1"."pin_project"}" deps)
    (features_.prost."${deps."tonic"."0.1.1"."prost"}" deps)
    (features_.prost_derive."${deps."tonic"."0.1.1"."prost_derive"}" deps)
    (features_.tokio."${deps."tonic"."0.1.1"."tokio"}" deps)
    (features_.tokio_util."${deps."tonic"."0.1.1"."tokio_util"}" deps)
    (features_.tower."${deps."tonic"."0.1.1"."tower"}" deps)
    (features_.tower_balance."${deps."tonic"."0.1.1"."tower_balance"}" deps)
    (features_.tower_load."${deps."tonic"."0.1.1"."tower_load"}" deps)
    (features_.tower_make."${deps."tonic"."0.1.1"."tower_make"}" deps)
    (features_.tower_service."${deps."tonic"."0.1.1"."tower_service"}" deps)
    (features_.tracing."${deps."tonic"."0.1.1"."tracing"}" deps)
    (features_.tracing_futures."${deps."tonic"."0.1.1"."tracing_futures"}" deps)
  ];


# end
# tonic-build-0.1.1

  crates.tonic_build."0.1.1" = deps: { features?(features_.tonic_build."0.1.1" deps {}) }: buildRustCrate {
    crateName = "tonic-build";
    version = "0.1.1";
    description = "Codegen module of `tonic` gRPC implementation.\n";
    authors = [ "Lucio Franco <luciofranco14@gmail.com>" ];
    edition = "2018";
    sha256 = "1zipcj4pf0lyf8gix9fvwyb40rdp0rhkb3f3387xgdlkk0yrcnjh";
    dependencies = mapFeatures features ([
      (crates."proc_macro2"."${deps."tonic_build"."0.1.1"."proc_macro2"}" deps)
      (crates."prost_build"."${deps."tonic_build"."0.1.1"."prost_build"}" deps)
      (crates."quote"."${deps."tonic_build"."0.1.1"."quote"}" deps)
      (crates."syn"."${deps."tonic_build"."0.1.1"."syn"}" deps)
    ]);
    features = mkFeatures (features."tonic_build"."0.1.1" or {});
  };
  features_.tonic_build."0.1.1" = deps: f: updateFeatures f (rec {
    proc_macro2."${deps.tonic_build."0.1.1".proc_macro2}".default = true;
    prost_build."${deps.tonic_build."0.1.1".prost_build}".default = true;
    quote."${deps.tonic_build."0.1.1".quote}".default = true;
    syn."${deps.tonic_build."0.1.1".syn}".default = true;
    tonic_build = fold recursiveUpdate {} [
      { "0.1.1"."rustfmt" =
        (f.tonic_build."0.1.1"."rustfmt" or false) ||
        (f.tonic_build."0.1.1".default or false) ||
        (tonic_build."0.1.1"."default" or false); }
      { "0.1.1"."transport" =
        (f.tonic_build."0.1.1"."transport" or false) ||
        (f.tonic_build."0.1.1".default or false) ||
        (tonic_build."0.1.1"."default" or false); }
      { "0.1.1".default = (f.tonic_build."0.1.1".default or true); }
    ];
  }) [
    (features_.proc_macro2."${deps."tonic_build"."0.1.1"."proc_macro2"}" deps)
    (features_.prost_build."${deps."tonic_build"."0.1.1"."prost_build"}" deps)
    (features_.quote."${deps."tonic_build"."0.1.1"."quote"}" deps)
    (features_.syn."${deps."tonic_build"."0.1.1"."syn"}" deps)
  ];


# end
# tower-0.3.1

  crates.tower."0.3.1" = deps: { features?(features_.tower."0.3.1" deps {}) }: buildRustCrate {
    crateName = "tower";
    version = "0.3.1";
    description = "Tower is a library of modular and reusable components for building robust\nclients and servers.\n";
    authors = [ "Tower Maintainers <team@tower-rs.com>" ];
    edition = "2018";
    sha256 = "02vddswyrvx5gf4rfn27rr4bgndkdf9nkk99vc4dgnh104y3jigc";
    dependencies = mapFeatures features ([
      (crates."futures_core"."${deps."tower"."0.3.1"."futures_core"}" deps)
      (crates."tower_buffer"."${deps."tower"."0.3.1"."tower_buffer"}" deps)
      (crates."tower_discover"."${deps."tower"."0.3.1"."tower_discover"}" deps)
      (crates."tower_layer"."${deps."tower"."0.3.1"."tower_layer"}" deps)
      (crates."tower_limit"."${deps."tower"."0.3.1"."tower_limit"}" deps)
      (crates."tower_load_shed"."${deps."tower"."0.3.1"."tower_load_shed"}" deps)
      (crates."tower_retry"."${deps."tower"."0.3.1"."tower_retry"}" deps)
      (crates."tower_service"."${deps."tower"."0.3.1"."tower_service"}" deps)
      (crates."tower_timeout"."${deps."tower"."0.3.1"."tower_timeout"}" deps)
      (crates."tower_util"."${deps."tower"."0.3.1"."tower_util"}" deps)
    ]);
    features = mkFeatures (features."tower"."0.3.1" or {});
  };
  features_.tower."0.3.1" = deps: f: updateFeatures f (rec {
    futures_core."${deps.tower."0.3.1".futures_core}".default = (f.futures_core."${deps.tower."0.3.1".futures_core}".default or false);
    tower = fold recursiveUpdate {} [
      { "0.3.1"."full" =
        (f.tower."0.3.1"."full" or false) ||
        (f.tower."0.3.1".default or false) ||
        (tower."0.3.1"."default" or false); }
      { "0.3.1"."log" =
        (f.tower."0.3.1"."log" or false) ||
        (f.tower."0.3.1".default or false) ||
        (tower."0.3.1"."default" or false); }
      { "0.3.1".default = (f.tower."0.3.1".default or true); }
    ];
    tower_buffer = fold recursiveUpdate {} [
      { "${deps.tower."0.3.1".tower_buffer}"."log" =
        (f.tower_buffer."${deps.tower."0.3.1".tower_buffer}"."log" or false) ||
        (tower."0.3.1"."log" or false) ||
        (f."tower"."0.3.1"."log" or false); }
      { "${deps.tower."0.3.1".tower_buffer}".default = (f.tower_buffer."${deps.tower."0.3.1".tower_buffer}".default or false); }
    ];
    tower_discover."${deps.tower."0.3.1".tower_discover}".default = true;
    tower_layer."${deps.tower."0.3.1".tower_layer}".default = true;
    tower_limit."${deps.tower."0.3.1".tower_limit}".default = true;
    tower_load_shed."${deps.tower."0.3.1".tower_load_shed}".default = true;
    tower_retry."${deps.tower."0.3.1".tower_retry}".default = true;
    tower_service."${deps.tower."0.3.1".tower_service}".default = true;
    tower_timeout."${deps.tower."0.3.1".tower_timeout}".default = true;
    tower_util = fold recursiveUpdate {} [
      { "${deps.tower."0.3.1".tower_util}"."call-all" = true; }
      { "${deps.tower."0.3.1".tower_util}".default = true; }
    ];
  }) [
    (features_.futures_core."${deps."tower"."0.3.1"."futures_core"}" deps)
    (features_.tower_buffer."${deps."tower"."0.3.1"."tower_buffer"}" deps)
    (features_.tower_discover."${deps."tower"."0.3.1"."tower_discover"}" deps)
    (features_.tower_layer."${deps."tower"."0.3.1"."tower_layer"}" deps)
    (features_.tower_limit."${deps."tower"."0.3.1"."tower_limit"}" deps)
    (features_.tower_load_shed."${deps."tower"."0.3.1"."tower_load_shed"}" deps)
    (features_.tower_retry."${deps."tower"."0.3.1"."tower_retry"}" deps)
    (features_.tower_service."${deps."tower"."0.3.1"."tower_service"}" deps)
    (features_.tower_timeout."${deps."tower"."0.3.1"."tower_timeout"}" deps)
    (features_.tower_util."${deps."tower"."0.3.1"."tower_util"}" deps)
  ];


# end
# tower-balance-0.3.0

  crates.tower_balance."0.3.0" = deps: { features?(features_.tower_balance."0.3.0" deps {}) }: buildRustCrate {
    crateName = "tower-balance";
    version = "0.3.0";
    description = "Balance load across a set of uniform services.\n";
    authors = [ "Tower Maintainers <team@tower-rs.com>" ];
    edition = "2018";
    sha256 = "0qp828l7sff0l9n9prlsl1gh5kh6p2b86acnwxhyh6c3m9ypd3k8";
    dependencies = mapFeatures features ([
      (crates."futures_core"."${deps."tower_balance"."0.3.0"."futures_core"}" deps)
      (crates."futures_util"."${deps."tower_balance"."0.3.0"."futures_util"}" deps)
      (crates."indexmap"."${deps."tower_balance"."0.3.0"."indexmap"}" deps)
      (crates."pin_project"."${deps."tower_balance"."0.3.0"."pin_project"}" deps)
      (crates."rand"."${deps."tower_balance"."0.3.0"."rand"}" deps)
      (crates."slab"."${deps."tower_balance"."0.3.0"."slab"}" deps)
      (crates."tokio"."${deps."tower_balance"."0.3.0"."tokio"}" deps)
      (crates."tower_discover"."${deps."tower_balance"."0.3.0"."tower_discover"}" deps)
      (crates."tower_layer"."${deps."tower_balance"."0.3.0"."tower_layer"}" deps)
      (crates."tower_load"."${deps."tower_balance"."0.3.0"."tower_load"}" deps)
      (crates."tower_make"."${deps."tower_balance"."0.3.0"."tower_make"}" deps)
      (crates."tower_ready_cache"."${deps."tower_balance"."0.3.0"."tower_ready_cache"}" deps)
      (crates."tower_service"."${deps."tower_balance"."0.3.0"."tower_service"}" deps)
      (crates."tracing"."${deps."tower_balance"."0.3.0"."tracing"}" deps)
    ]);
    features = mkFeatures (features."tower_balance"."0.3.0" or {});
  };
  features_.tower_balance."0.3.0" = deps: f: updateFeatures f (rec {
    futures_core."${deps.tower_balance."0.3.0".futures_core}".default = (f.futures_core."${deps.tower_balance."0.3.0".futures_core}".default or false);
    futures_util."${deps.tower_balance."0.3.0".futures_util}".default = (f.futures_util."${deps.tower_balance."0.3.0".futures_util}".default or false);
    indexmap."${deps.tower_balance."0.3.0".indexmap}".default = true;
    pin_project."${deps.tower_balance."0.3.0".pin_project}".default = true;
    rand = fold recursiveUpdate {} [
      { "${deps.tower_balance."0.3.0".rand}"."small_rng" = true; }
      { "${deps.tower_balance."0.3.0".rand}".default = true; }
    ];
    slab."${deps.tower_balance."0.3.0".slab}".default = true;
    tokio = fold recursiveUpdate {} [
      { "${deps.tower_balance."0.3.0".tokio}"."sync" = true; }
      { "${deps.tower_balance."0.3.0".tokio}"."time" = true; }
      { "${deps.tower_balance."0.3.0".tokio}".default = true; }
    ];
    tower_balance = fold recursiveUpdate {} [
      { "0.3.0"."log" =
        (f.tower_balance."0.3.0"."log" or false) ||
        (f.tower_balance."0.3.0".default or false) ||
        (tower_balance."0.3.0"."default" or false); }
      { "0.3.0".default = (f.tower_balance."0.3.0".default or true); }
    ];
    tower_discover."${deps.tower_balance."0.3.0".tower_discover}".default = true;
    tower_layer."${deps.tower_balance."0.3.0".tower_layer}".default = true;
    tower_load."${deps.tower_balance."0.3.0".tower_load}".default = true;
    tower_make."${deps.tower_balance."0.3.0".tower_make}".default = true;
    tower_ready_cache."${deps.tower_balance."0.3.0".tower_ready_cache}".default = true;
    tower_service."${deps.tower_balance."0.3.0".tower_service}".default = true;
    tracing = fold recursiveUpdate {} [
      { "${deps.tower_balance."0.3.0".tracing}"."log" =
        (f.tracing."${deps.tower_balance."0.3.0".tracing}"."log" or false) ||
        (tower_balance."0.3.0"."log" or false) ||
        (f."tower_balance"."0.3.0"."log" or false); }
      { "${deps.tower_balance."0.3.0".tracing}".default = true; }
    ];
  }) [
    (features_.futures_core."${deps."tower_balance"."0.3.0"."futures_core"}" deps)
    (features_.futures_util."${deps."tower_balance"."0.3.0"."futures_util"}" deps)
    (features_.indexmap."${deps."tower_balance"."0.3.0"."indexmap"}" deps)
    (features_.pin_project."${deps."tower_balance"."0.3.0"."pin_project"}" deps)
    (features_.rand."${deps."tower_balance"."0.3.0"."rand"}" deps)
    (features_.slab."${deps."tower_balance"."0.3.0"."slab"}" deps)
    (features_.tokio."${deps."tower_balance"."0.3.0"."tokio"}" deps)
    (features_.tower_discover."${deps."tower_balance"."0.3.0"."tower_discover"}" deps)
    (features_.tower_layer."${deps."tower_balance"."0.3.0"."tower_layer"}" deps)
    (features_.tower_load."${deps."tower_balance"."0.3.0"."tower_load"}" deps)
    (features_.tower_make."${deps."tower_balance"."0.3.0"."tower_make"}" deps)
    (features_.tower_ready_cache."${deps."tower_balance"."0.3.0"."tower_ready_cache"}" deps)
    (features_.tower_service."${deps."tower_balance"."0.3.0"."tower_service"}" deps)
    (features_.tracing."${deps."tower_balance"."0.3.0"."tracing"}" deps)
  ];


# end
# tower-buffer-0.3.0

  crates.tower_buffer."0.3.0" = deps: { features?(features_.tower_buffer."0.3.0" deps {}) }: buildRustCrate {
    crateName = "tower-buffer";
    version = "0.3.0";
    description = "Buffer requests before dispatching to a `Service`.\n";
    authors = [ "Tower Maintainers <team@tower-rs.com>" ];
    edition = "2018";
    sha256 = "0qlq0ynx08xx0fzw5vkksmx2klyxw90wlpngi0dzbkz76448sy4z";
    dependencies = mapFeatures features ([
      (crates."futures_core"."${deps."tower_buffer"."0.3.0"."futures_core"}" deps)
      (crates."pin_project"."${deps."tower_buffer"."0.3.0"."pin_project"}" deps)
      (crates."tokio"."${deps."tower_buffer"."0.3.0"."tokio"}" deps)
      (crates."tower_layer"."${deps."tower_buffer"."0.3.0"."tower_layer"}" deps)
      (crates."tower_service"."${deps."tower_buffer"."0.3.0"."tower_service"}" deps)
      (crates."tracing"."${deps."tower_buffer"."0.3.0"."tracing"}" deps)
    ]);
    features = mkFeatures (features."tower_buffer"."0.3.0" or {});
  };
  features_.tower_buffer."0.3.0" = deps: f: updateFeatures f (rec {
    futures_core."${deps.tower_buffer."0.3.0".futures_core}".default = (f.futures_core."${deps.tower_buffer."0.3.0".futures_core}".default or false);
    pin_project."${deps.tower_buffer."0.3.0".pin_project}".default = true;
    tokio = fold recursiveUpdate {} [
      { "${deps.tower_buffer."0.3.0".tokio}"."rt-core" = true; }
      { "${deps.tower_buffer."0.3.0".tokio}"."sync" = true; }
      { "${deps.tower_buffer."0.3.0".tokio}".default = true; }
    ];
    tower_buffer = fold recursiveUpdate {} [
      { "0.3.0"."log" =
        (f.tower_buffer."0.3.0"."log" or false) ||
        (f.tower_buffer."0.3.0".default or false) ||
        (tower_buffer."0.3.0"."default" or false); }
      { "0.3.0".default = (f.tower_buffer."0.3.0".default or true); }
    ];
    tower_layer."${deps.tower_buffer."0.3.0".tower_layer}".default = true;
    tower_service."${deps.tower_buffer."0.3.0".tower_service}".default = true;
    tracing = fold recursiveUpdate {} [
      { "${deps.tower_buffer."0.3.0".tracing}"."log" =
        (f.tracing."${deps.tower_buffer."0.3.0".tracing}"."log" or false) ||
        (tower_buffer."0.3.0"."log" or false) ||
        (f."tower_buffer"."0.3.0"."log" or false); }
      { "${deps.tower_buffer."0.3.0".tracing}".default = true; }
    ];
  }) [
    (features_.futures_core."${deps."tower_buffer"."0.3.0"."futures_core"}" deps)
    (features_.pin_project."${deps."tower_buffer"."0.3.0"."pin_project"}" deps)
    (features_.tokio."${deps."tower_buffer"."0.3.0"."tokio"}" deps)
    (features_.tower_layer."${deps."tower_buffer"."0.3.0"."tower_layer"}" deps)
    (features_.tower_service."${deps."tower_buffer"."0.3.0"."tower_service"}" deps)
    (features_.tracing."${deps."tower_buffer"."0.3.0"."tracing"}" deps)
  ];


# end
# tower-discover-0.3.0

  crates.tower_discover."0.3.0" = deps: { features?(features_.tower_discover."0.3.0" deps {}) }: buildRustCrate {
    crateName = "tower-discover";
    version = "0.3.0";
    description = "Abstracts over service discovery strategies.\n";
    authors = [ "Tower Maintainers <team@tower-rs.com>" ];
    edition = "2018";
    sha256 = "0acmcv5qxxw5jw1jbpzavnk6nkki223gk4ciwh40wpbrd6g6d15v";
    dependencies = mapFeatures features ([
      (crates."futures_core"."${deps."tower_discover"."0.3.0"."futures_core"}" deps)
      (crates."pin_project"."${deps."tower_discover"."0.3.0"."pin_project"}" deps)
      (crates."tower_service"."${deps."tower_discover"."0.3.0"."tower_service"}" deps)
    ]);
  };
  features_.tower_discover."0.3.0" = deps: f: updateFeatures f (rec {
    futures_core."${deps.tower_discover."0.3.0".futures_core}".default = (f.futures_core."${deps.tower_discover."0.3.0".futures_core}".default or false);
    pin_project."${deps.tower_discover."0.3.0".pin_project}".default = true;
    tower_discover."0.3.0".default = (f.tower_discover."0.3.0".default or true);
    tower_service."${deps.tower_discover."0.3.0".tower_service}".default = true;
  }) [
    (features_.futures_core."${deps."tower_discover"."0.3.0"."futures_core"}" deps)
    (features_.pin_project."${deps."tower_discover"."0.3.0"."pin_project"}" deps)
    (features_.tower_service."${deps."tower_discover"."0.3.0"."tower_service"}" deps)
  ];


# end
# tower-layer-0.3.0

  crates.tower_layer."0.3.0" = deps: { features?(features_.tower_layer."0.3.0" deps {}) }: buildRustCrate {
    crateName = "tower-layer";
    version = "0.3.0";
    description = "Decorates a `Service` to allow easy composition between `Service`s.\n";
    authors = [ "Tower Maintainers <team@tower-rs.com>" ];
    edition = "2018";
    sha256 = "14zm0ykvd5p8ijna51qcsqs6s09r3z7kcxzqf2cidda40aps17fs";
  };
  features_.tower_layer."0.3.0" = deps: f: updateFeatures f (rec {
    tower_layer."0.3.0".default = (f.tower_layer."0.3.0".default or true);
  }) [];


# end
# tower-limit-0.3.0

  crates.tower_limit."0.3.0" = deps: { features?(features_.tower_limit."0.3.0" deps {}) }: buildRustCrate {
    crateName = "tower-limit";
    version = "0.3.0";
    description = "Limit maximum request rate to a `Service`.\n";
    authors = [ "Tower Maintainers <team@tower-rs.com>" ];
    edition = "2018";
    sha256 = "0azlr6ll6rd85zms88d27j1b85rvp9lqk7bgbvjjad5bh100w479";
    dependencies = mapFeatures features ([
      (crates."futures_core"."${deps."tower_limit"."0.3.0"."futures_core"}" deps)
      (crates."pin_project"."${deps."tower_limit"."0.3.0"."pin_project"}" deps)
      (crates."tokio"."${deps."tower_limit"."0.3.0"."tokio"}" deps)
      (crates."tower_layer"."${deps."tower_limit"."0.3.0"."tower_layer"}" deps)
      (crates."tower_service"."${deps."tower_limit"."0.3.0"."tower_service"}" deps)
    ]);
  };
  features_.tower_limit."0.3.0" = deps: f: updateFeatures f (rec {
    futures_core."${deps.tower_limit."0.3.0".futures_core}".default = (f.futures_core."${deps.tower_limit."0.3.0".futures_core}".default or false);
    pin_project."${deps.tower_limit."0.3.0".pin_project}".default = true;
    tokio = fold recursiveUpdate {} [
      { "${deps.tower_limit."0.3.0".tokio}"."time" = true; }
      { "${deps.tower_limit."0.3.0".tokio}".default = true; }
    ];
    tower_layer."${deps.tower_limit."0.3.0".tower_layer}".default = true;
    tower_limit."0.3.0".default = (f.tower_limit."0.3.0".default or true);
    tower_service."${deps.tower_limit."0.3.0".tower_service}".default = true;
  }) [
    (features_.futures_core."${deps."tower_limit"."0.3.0"."futures_core"}" deps)
    (features_.pin_project."${deps."tower_limit"."0.3.0"."pin_project"}" deps)
    (features_.tokio."${deps."tower_limit"."0.3.0"."tokio"}" deps)
    (features_.tower_layer."${deps."tower_limit"."0.3.0"."tower_layer"}" deps)
    (features_.tower_service."${deps."tower_limit"."0.3.0"."tower_service"}" deps)
  ];


# end
# tower-load-0.3.0

  crates.tower_load."0.3.0" = deps: { features?(features_.tower_load."0.3.0" deps {}) }: buildRustCrate {
    crateName = "tower-load";
    version = "0.3.0";
    description = "Strategies for measuring the load of a service\n";
    authors = [ "Tower Maintainers <team@tower-rs.com>" ];
    edition = "2018";
    sha256 = "01cm4h3gp6jqxqzimlclcja2ki1s1qy1860gy06si8nxk74hs1zv";
    dependencies = mapFeatures features ([
      (crates."futures_core"."${deps."tower_load"."0.3.0"."futures_core"}" deps)
      (crates."log"."${deps."tower_load"."0.3.0"."log"}" deps)
      (crates."pin_project"."${deps."tower_load"."0.3.0"."pin_project"}" deps)
      (crates."tokio"."${deps."tower_load"."0.3.0"."tokio"}" deps)
      (crates."tower_discover"."${deps."tower_load"."0.3.0"."tower_discover"}" deps)
      (crates."tower_service"."${deps."tower_load"."0.3.0"."tower_service"}" deps)
    ]);
  };
  features_.tower_load."0.3.0" = deps: f: updateFeatures f (rec {
    futures_core."${deps.tower_load."0.3.0".futures_core}".default = (f.futures_core."${deps.tower_load."0.3.0".futures_core}".default or false);
    log."${deps.tower_load."0.3.0".log}".default = true;
    pin_project."${deps.tower_load."0.3.0".pin_project}".default = true;
    tokio = fold recursiveUpdate {} [
      { "${deps.tower_load."0.3.0".tokio}"."time" = true; }
      { "${deps.tower_load."0.3.0".tokio}".default = true; }
    ];
    tower_discover."${deps.tower_load."0.3.0".tower_discover}".default = true;
    tower_load."0.3.0".default = (f.tower_load."0.3.0".default or true);
    tower_service."${deps.tower_load."0.3.0".tower_service}".default = true;
  }) [
    (features_.futures_core."${deps."tower_load"."0.3.0"."futures_core"}" deps)
    (features_.log."${deps."tower_load"."0.3.0"."log"}" deps)
    (features_.pin_project."${deps."tower_load"."0.3.0"."pin_project"}" deps)
    (features_.tokio."${deps."tower_load"."0.3.0"."tokio"}" deps)
    (features_.tower_discover."${deps."tower_load"."0.3.0"."tower_discover"}" deps)
    (features_.tower_service."${deps."tower_load"."0.3.0"."tower_service"}" deps)
  ];


# end
# tower-load-shed-0.3.0

  crates.tower_load_shed."0.3.0" = deps: { features?(features_.tower_load_shed."0.3.0" deps {}) }: buildRustCrate {
    crateName = "tower-load-shed";
    version = "0.3.0";
    description = "Immediately reject requests if the inner service is not ready. This is also\nknown as load-shedding.\n";
    authors = [ "Tower Maintainers <team@tower-rs.com>" ];
    edition = "2018";
    sha256 = "1ykn814l6yx3jikmxqnmknl1r198ccgl0xpakpg1wkyv5s1hr1dz";
    dependencies = mapFeatures features ([
      (crates."futures_core"."${deps."tower_load_shed"."0.3.0"."futures_core"}" deps)
      (crates."pin_project"."${deps."tower_load_shed"."0.3.0"."pin_project"}" deps)
      (crates."tower_layer"."${deps."tower_load_shed"."0.3.0"."tower_layer"}" deps)
      (crates."tower_service"."${deps."tower_load_shed"."0.3.0"."tower_service"}" deps)
    ]);
  };
  features_.tower_load_shed."0.3.0" = deps: f: updateFeatures f (rec {
    futures_core."${deps.tower_load_shed."0.3.0".futures_core}".default = (f.futures_core."${deps.tower_load_shed."0.3.0".futures_core}".default or false);
    pin_project."${deps.tower_load_shed."0.3.0".pin_project}".default = true;
    tower_layer."${deps.tower_load_shed."0.3.0".tower_layer}".default = true;
    tower_load_shed."0.3.0".default = (f.tower_load_shed."0.3.0".default or true);
    tower_service."${deps.tower_load_shed."0.3.0".tower_service}".default = true;
  }) [
    (features_.futures_core."${deps."tower_load_shed"."0.3.0"."futures_core"}" deps)
    (features_.pin_project."${deps."tower_load_shed"."0.3.0"."pin_project"}" deps)
    (features_.tower_layer."${deps."tower_load_shed"."0.3.0"."tower_layer"}" deps)
    (features_.tower_service."${deps."tower_load_shed"."0.3.0"."tower_service"}" deps)
  ];


# end
# tower-make-0.3.0

  crates.tower_make."0.3.0" = deps: { features?(features_.tower_make."0.3.0" deps {}) }: buildRustCrate {
    crateName = "tower-make";
    version = "0.3.0";
    description = "Trait aliases for Services that produce specific types of Responses.\n";
    authors = [ "Tower Maintainers <team@tower-rs.com>" ];
    edition = "2018";
    sha256 = "013qz97j8w2pq8gsdp237969gs9cj2392vkvi1b5652qp820yd2a";
    dependencies = mapFeatures features ([
      (crates."tower_service"."${deps."tower_make"."0.3.0"."tower_service"}" deps)
    ]
      ++ (if features.tower_make."0.3.0".tokio or false then [ (crates.tokio."${deps."tower_make"."0.3.0".tokio}" deps) ] else []));
    features = mkFeatures (features."tower_make"."0.3.0" or {});
  };
  features_.tower_make."0.3.0" = deps: f: updateFeatures f (rec {
    tokio."${deps.tower_make."0.3.0".tokio}".default = true;
    tower_make = fold recursiveUpdate {} [
      { "0.3.0"."tokio" =
        (f.tower_make."0.3.0"."tokio" or false) ||
        (f.tower_make."0.3.0".connect or false) ||
        (tower_make."0.3.0"."connect" or false); }
      { "0.3.0".default = (f.tower_make."0.3.0".default or true); }
    ];
    tower_service."${deps.tower_make."0.3.0".tower_service}".default = true;
  }) [
    (features_.tokio."${deps."tower_make"."0.3.0"."tokio"}" deps)
    (features_.tower_service."${deps."tower_make"."0.3.0"."tower_service"}" deps)
  ];


# end
# tower-ready-cache-0.3.1

  crates.tower_ready_cache."0.3.1" = deps: { features?(features_.tower_ready_cache."0.3.1" deps {}) }: buildRustCrate {
    crateName = "tower-ready-cache";
    version = "0.3.1";
    description = "Caches a set of services\n";
    authors = [ "Tower Maintainers <team@tower-rs.com>" ];
    edition = "2018";
    sha256 = "108pmvh0g6vbdfb09qhvfpsd8328agfil4gjm09f3avns71yfsr5";
    dependencies = mapFeatures features ([
      (crates."futures_core"."${deps."tower_ready_cache"."0.3.1"."futures_core"}" deps)
      (crates."futures_util"."${deps."tower_ready_cache"."0.3.1"."futures_util"}" deps)
      (crates."indexmap"."${deps."tower_ready_cache"."0.3.1"."indexmap"}" deps)
      (crates."log"."${deps."tower_ready_cache"."0.3.1"."log"}" deps)
      (crates."tokio"."${deps."tower_ready_cache"."0.3.1"."tokio"}" deps)
      (crates."tower_service"."${deps."tower_ready_cache"."0.3.1"."tower_service"}" deps)
    ]);
  };
  features_.tower_ready_cache."0.3.1" = deps: f: updateFeatures f (rec {
    futures_core."${deps.tower_ready_cache."0.3.1".futures_core}".default = (f.futures_core."${deps.tower_ready_cache."0.3.1".futures_core}".default or false);
    futures_util = fold recursiveUpdate {} [
      { "${deps.tower_ready_cache."0.3.1".futures_util}"."alloc" = true; }
      { "${deps.tower_ready_cache."0.3.1".futures_util}".default = (f.futures_util."${deps.tower_ready_cache."0.3.1".futures_util}".default or false); }
    ];
    indexmap."${deps.tower_ready_cache."0.3.1".indexmap}".default = true;
    log."${deps.tower_ready_cache."0.3.1".log}".default = true;
    tokio = fold recursiveUpdate {} [
      { "${deps.tower_ready_cache."0.3.1".tokio}"."sync" = true; }
      { "${deps.tower_ready_cache."0.3.1".tokio}".default = true; }
    ];
    tower_ready_cache."0.3.1".default = (f.tower_ready_cache."0.3.1".default or true);
    tower_service."${deps.tower_ready_cache."0.3.1".tower_service}".default = true;
  }) [
    (features_.futures_core."${deps."tower_ready_cache"."0.3.1"."futures_core"}" deps)
    (features_.futures_util."${deps."tower_ready_cache"."0.3.1"."futures_util"}" deps)
    (features_.indexmap."${deps."tower_ready_cache"."0.3.1"."indexmap"}" deps)
    (features_.log."${deps."tower_ready_cache"."0.3.1"."log"}" deps)
    (features_.tokio."${deps."tower_ready_cache"."0.3.1"."tokio"}" deps)
    (features_.tower_service."${deps."tower_ready_cache"."0.3.1"."tower_service"}" deps)
  ];


# end
# tower-retry-0.3.0

  crates.tower_retry."0.3.0" = deps: { features?(features_.tower_retry."0.3.0" deps {}) }: buildRustCrate {
    crateName = "tower-retry";
    version = "0.3.0";
    description = "Retry failed requests.\n";
    authors = [ "Tower Maintainers <team@tower-rs.com>" ];
    edition = "2018";
    sha256 = "06gnbd435f10blv6w2lzdrsshm01rfsfpvx1hazcdq8srvcj6i90";
    dependencies = mapFeatures features ([
      (crates."futures_core"."${deps."tower_retry"."0.3.0"."futures_core"}" deps)
      (crates."pin_project"."${deps."tower_retry"."0.3.0"."pin_project"}" deps)
      (crates."tokio"."${deps."tower_retry"."0.3.0"."tokio"}" deps)
      (crates."tower_layer"."${deps."tower_retry"."0.3.0"."tower_layer"}" deps)
      (crates."tower_service"."${deps."tower_retry"."0.3.0"."tower_service"}" deps)
    ]);
  };
  features_.tower_retry."0.3.0" = deps: f: updateFeatures f (rec {
    futures_core."${deps.tower_retry."0.3.0".futures_core}".default = (f.futures_core."${deps.tower_retry."0.3.0".futures_core}".default or false);
    pin_project."${deps.tower_retry."0.3.0".pin_project}".default = true;
    tokio = fold recursiveUpdate {} [
      { "${deps.tower_retry."0.3.0".tokio}"."time" = true; }
      { "${deps.tower_retry."0.3.0".tokio}".default = true; }
    ];
    tower_layer."${deps.tower_retry."0.3.0".tower_layer}".default = true;
    tower_retry."0.3.0".default = (f.tower_retry."0.3.0".default or true);
    tower_service."${deps.tower_retry."0.3.0".tower_service}".default = true;
  }) [
    (features_.futures_core."${deps."tower_retry"."0.3.0"."futures_core"}" deps)
    (features_.pin_project."${deps."tower_retry"."0.3.0"."pin_project"}" deps)
    (features_.tokio."${deps."tower_retry"."0.3.0"."tokio"}" deps)
    (features_.tower_layer."${deps."tower_retry"."0.3.0"."tower_layer"}" deps)
    (features_.tower_service."${deps."tower_retry"."0.3.0"."tower_service"}" deps)
  ];


# end
# tower-service-0.3.0

  crates.tower_service."0.3.0" = deps: { features?(features_.tower_service."0.3.0" deps {}) }: buildRustCrate {
    crateName = "tower-service";
    version = "0.3.0";
    description = "Trait representing an asynchronous, request / response based, client or server.\n";
    authors = [ "Tower Maintainers <team@tower-rs.com>" ];
    edition = "2018";
    sha256 = "1dr8kzzad13ayc15bam7fpwvpn2c2bsqaybhjf3xiybxgcp3516n";
  };
  features_.tower_service."0.3.0" = deps: f: updateFeatures f (rec {
    tower_service."0.3.0".default = (f.tower_service."0.3.0".default or true);
  }) [];


# end
# tower-timeout-0.3.0

  crates.tower_timeout."0.3.0" = deps: { features?(features_.tower_timeout."0.3.0" deps {}) }: buildRustCrate {
    crateName = "tower-timeout";
    version = "0.3.0";
    description = "Apply a timeout to requests, ensuring completion within a fixed time duration.\n";
    authors = [ "Tower Maintainers <team@tower-rs.com>" ];
    edition = "2018";
    sha256 = "0gljlmhcmrabamf32067kycs5pnh5pq7dar1i71ra879vzvnqgg5";
    dependencies = mapFeatures features ([
      (crates."pin_project"."${deps."tower_timeout"."0.3.0"."pin_project"}" deps)
      (crates."tokio"."${deps."tower_timeout"."0.3.0"."tokio"}" deps)
      (crates."tower_layer"."${deps."tower_timeout"."0.3.0"."tower_layer"}" deps)
      (crates."tower_service"."${deps."tower_timeout"."0.3.0"."tower_service"}" deps)
    ]);
  };
  features_.tower_timeout."0.3.0" = deps: f: updateFeatures f (rec {
    pin_project."${deps.tower_timeout."0.3.0".pin_project}".default = true;
    tokio = fold recursiveUpdate {} [
      { "${deps.tower_timeout."0.3.0".tokio}"."time" = true; }
      { "${deps.tower_timeout."0.3.0".tokio}".default = true; }
    ];
    tower_layer."${deps.tower_timeout."0.3.0".tower_layer}".default = true;
    tower_service."${deps.tower_timeout."0.3.0".tower_service}".default = true;
    tower_timeout."0.3.0".default = (f.tower_timeout."0.3.0".default or true);
  }) [
    (features_.pin_project."${deps."tower_timeout"."0.3.0"."pin_project"}" deps)
    (features_.tokio."${deps."tower_timeout"."0.3.0"."tokio"}" deps)
    (features_.tower_layer."${deps."tower_timeout"."0.3.0"."tower_layer"}" deps)
    (features_.tower_service."${deps."tower_timeout"."0.3.0"."tower_service"}" deps)
  ];


# end
# tower-util-0.3.1

  crates.tower_util."0.3.1" = deps: { features?(features_.tower_util."0.3.1" deps {}) }: buildRustCrate {
    crateName = "tower-util";
    version = "0.3.1";
    description = "Utilities for working with `Service`.\n";
    authors = [ "Tower Maintainers <team@tower-rs.com>" ];
    edition = "2018";
    sha256 = "1s0bqch8zgz3822a3fmdszrzxvdnkjz4mydbpfqpx10r60szq2vr";
    dependencies = mapFeatures features ([
      (crates."futures_core"."${deps."tower_util"."0.3.1"."futures_core"}" deps)
      (crates."pin_project"."${deps."tower_util"."0.3.1"."pin_project"}" deps)
      (crates."tower_service"."${deps."tower_util"."0.3.1"."tower_service"}" deps)
    ]
      ++ (if features.tower_util."0.3.1".futures-util or false then [ (crates.futures_util."${deps."tower_util"."0.3.1".futures_util}" deps) ] else []));
    features = mkFeatures (features."tower_util"."0.3.1" or {});
  };
  features_.tower_util."0.3.1" = deps: f: updateFeatures f (rec {
    futures_core."${deps.tower_util."0.3.1".futures_core}".default = (f.futures_core."${deps.tower_util."0.3.1".futures_core}".default or false);
    futures_util = fold recursiveUpdate {} [
      { "${deps.tower_util."0.3.1".futures_util}"."alloc" = true; }
      { "${deps.tower_util."0.3.1".futures_util}".default = (f.futures_util."${deps.tower_util."0.3.1".futures_util}".default or false); }
    ];
    pin_project."${deps.tower_util."0.3.1".pin_project}".default = true;
    tower_service."${deps.tower_util."0.3.1".tower_service}".default = true;
    tower_util = fold recursiveUpdate {} [
      { "0.3.1"."call-all" =
        (f.tower_util."0.3.1"."call-all" or false) ||
        (f.tower_util."0.3.1".default or false) ||
        (tower_util."0.3.1"."default" or false); }
      { "0.3.1"."futures-util" =
        (f.tower_util."0.3.1"."futures-util" or false) ||
        (f.tower_util."0.3.1".call-all or false) ||
        (tower_util."0.3.1"."call-all" or false); }
      { "0.3.1".default = (f.tower_util."0.3.1".default or true); }
    ];
  }) [
    (features_.futures_core."${deps."tower_util"."0.3.1"."futures_core"}" deps)
    (features_.futures_util."${deps."tower_util"."0.3.1"."futures_util"}" deps)
    (features_.pin_project."${deps."tower_util"."0.3.1"."pin_project"}" deps)
    (features_.tower_service."${deps."tower_util"."0.3.1"."tower_service"}" deps)
  ];


# end
# tracing-0.1.13

  crates.tracing."0.1.13" = deps: { features?(features_.tracing."0.1.13" deps {}) }: buildRustCrate {
    crateName = "tracing";
    version = "0.1.13";
    description = "Application-level tracing for Rust.\n";
    authors = [ "Eliza Weisman <eliza@buoyant.io>" "Tokio Contributors <team@tokio.rs>" ];
    edition = "2018";
    sha256 = "0rb6mvfp9pkzrrjxc5mgxac4hgn255fk5i3pq6915xsf1qpl7n6j";
    dependencies = mapFeatures features ([
      (crates."cfg_if"."${deps."tracing"."0.1.13"."cfg_if"}" deps)
      (crates."tracing_core"."${deps."tracing"."0.1.13"."tracing_core"}" deps)
    ]
      ++ (if features.tracing."0.1.13".log or false then [ (crates.log."${deps."tracing"."0.1.13".log}" deps) ] else [])
      ++ (if features.tracing."0.1.13".tracing-attributes or false then [ (crates.tracing_attributes."${deps."tracing"."0.1.13".tracing_attributes}" deps) ] else []));
    features = mkFeatures (features."tracing"."0.1.13" or {});
  };
  features_.tracing."0.1.13" = deps: f: updateFeatures f (rec {
    cfg_if."${deps.tracing."0.1.13".cfg_if}".default = true;
    log."${deps.tracing."0.1.13".log}".default = true;
    tracing = fold recursiveUpdate {} [
      { "0.1.13"."attributes" =
        (f.tracing."0.1.13"."attributes" or false) ||
        (f.tracing."0.1.13".default or false) ||
        (tracing."0.1.13"."default" or false); }
      { "0.1.13"."log" =
        (f.tracing."0.1.13"."log" or false) ||
        (f.tracing."0.1.13".log-always or false) ||
        (tracing."0.1.13"."log-always" or false); }
      { "0.1.13"."std" =
        (f.tracing."0.1.13"."std" or false) ||
        (f.tracing."0.1.13".default or false) ||
        (tracing."0.1.13"."default" or false); }
      { "0.1.13"."tracing-attributes" =
        (f.tracing."0.1.13"."tracing-attributes" or false) ||
        (f.tracing."0.1.13".attributes or false) ||
        (tracing."0.1.13"."attributes" or false); }
      { "0.1.13".default = (f.tracing."0.1.13".default or true); }
    ];
    tracing_attributes."${deps.tracing."0.1.13".tracing_attributes}".default = true;
    tracing_core = fold recursiveUpdate {} [
      { "${deps.tracing."0.1.13".tracing_core}"."std" =
        (f.tracing_core."${deps.tracing."0.1.13".tracing_core}"."std" or false) ||
        (tracing."0.1.13"."std" or false) ||
        (f."tracing"."0.1.13"."std" or false); }
      { "${deps.tracing."0.1.13".tracing_core}".default = (f.tracing_core."${deps.tracing."0.1.13".tracing_core}".default or false); }
    ];
  }) [
    (features_.cfg_if."${deps."tracing"."0.1.13"."cfg_if"}" deps)
    (features_.log."${deps."tracing"."0.1.13"."log"}" deps)
    (features_.tracing_attributes."${deps."tracing"."0.1.13"."tracing_attributes"}" deps)
    (features_.tracing_core."${deps."tracing"."0.1.13"."tracing_core"}" deps)
  ];


# end
# tracing-attributes-0.1.7

  crates.tracing_attributes."0.1.7" = deps: { features?(features_.tracing_attributes."0.1.7" deps {}) }: buildRustCrate {
    crateName = "tracing-attributes";
    version = "0.1.7";
    description = "Procedural macro attributes for automatically instrumenting functions.\n";
    authors = [ "Tokio Contributors <team@tokio.rs>" "Eliza Weisman <eliza@buoyant.io>" "David Barsky <dbarsky@amazon.com>" ];
    edition = "2018";
    sha256 = "1lfsmzhq5sqkxzkp0jxvwfmiyl33vqg3338dx7l4wqsz8qjfbnia";
    procMacro = true;
    dependencies = mapFeatures features ([
      (crates."quote"."${deps."tracing_attributes"."0.1.7"."quote"}" deps)
      (crates."syn"."${deps."tracing_attributes"."0.1.7"."syn"}" deps)
    ]);
    features = mkFeatures (features."tracing_attributes"."0.1.7" or {});
  };
  features_.tracing_attributes."0.1.7" = deps: f: updateFeatures f (rec {
    quote."${deps.tracing_attributes."0.1.7".quote}".default = true;
    syn = fold recursiveUpdate {} [
      { "${deps.tracing_attributes."0.1.7".syn}"."extra-traits" = true; }
      { "${deps.tracing_attributes."0.1.7".syn}"."full" = true; }
      { "${deps.tracing_attributes."0.1.7".syn}".default = true; }
    ];
    tracing_attributes."0.1.7".default = (f.tracing_attributes."0.1.7".default or true);
  }) [
    (features_.quote."${deps."tracing_attributes"."0.1.7"."quote"}" deps)
    (features_.syn."${deps."tracing_attributes"."0.1.7"."syn"}" deps)
  ];


# end
# tracing-core-0.1.10

  crates.tracing_core."0.1.10" = deps: { features?(features_.tracing_core."0.1.10" deps {}) }: buildRustCrate {
    crateName = "tracing-core";
    version = "0.1.10";
    description = "Core primitives for application-level tracing.\n";
    authors = [ "Tokio Contributors <team@tokio.rs>" ];
    edition = "2018";
    sha256 = "0ilmnlfirylknnrwxfi38hs2000d8c60ax5zgd7ydc0bxkb8hisn";
    dependencies = mapFeatures features ([
    ]
      ++ (if features.tracing_core."0.1.10".lazy_static or false then [ (crates.lazy_static."${deps."tracing_core"."0.1.10".lazy_static}" deps) ] else []));
    features = mkFeatures (features."tracing_core"."0.1.10" or {});
  };
  features_.tracing_core."0.1.10" = deps: f: updateFeatures f (rec {
    lazy_static."${deps.tracing_core."0.1.10".lazy_static}".default = true;
    tracing_core = fold recursiveUpdate {} [
      { "0.1.10"."lazy_static" =
        (f.tracing_core."0.1.10"."lazy_static" or false) ||
        (f.tracing_core."0.1.10".std or false) ||
        (tracing_core."0.1.10"."std" or false); }
      { "0.1.10"."std" =
        (f.tracing_core."0.1.10"."std" or false) ||
        (f.tracing_core."0.1.10".default or false) ||
        (tracing_core."0.1.10"."default" or false); }
      { "0.1.10".default = (f.tracing_core."0.1.10".default or true); }
    ];
  }) [
    (features_.lazy_static."${deps."tracing_core"."0.1.10"."lazy_static"}" deps)
  ];


# end
# tracing-futures-0.2.3

  crates.tracing_futures."0.2.3" = deps: { features?(features_.tracing_futures."0.2.3" deps {}) }: buildRustCrate {
    crateName = "tracing-futures";
    version = "0.2.3";
    description = "Utilities for instrumenting `futures` with `tracing`.\n";
    authors = [ "Eliza Weisman <eliza@buoyant.io>" "Tokio Contributors <team@tokio.rs>" ];
    edition = "2018";
    sha256 = "0z0j7qzk4kgyhkd30qv4dyj45b6ylfpk5zgx5pkiir7n9v4rj072";
    dependencies = mapFeatures features ([
      (crates."tracing"."${deps."tracing_futures"."0.2.3"."tracing"}" deps)
    ]
      ++ (if features.tracing_futures."0.2.3".pin-project or false then [ (crates.pin_project."${deps."tracing_futures"."0.2.3".pin_project}" deps) ] else []));
    features = mkFeatures (features."tracing_futures"."0.2.3" or {});
  };
  features_.tracing_futures."0.2.3" = deps: f: updateFeatures f (rec {
    pin_project."${deps.tracing_futures."0.2.3".pin_project}".default = true;
    tracing = fold recursiveUpdate {} [
      { "${deps.tracing_futures."0.2.3".tracing}"."std" =
        (f.tracing."${deps.tracing_futures."0.2.3".tracing}"."std" or false) ||
        (tracing_futures."0.2.3"."std" or false) ||
        (f."tracing_futures"."0.2.3"."std" or false); }
      { "${deps.tracing_futures."0.2.3".tracing}".default = (f.tracing."${deps.tracing_futures."0.2.3".tracing}".default or false); }
    ];
    tracing_futures = fold recursiveUpdate {} [
      { "0.2.3"."futures" =
        (f.tracing_futures."0.2.3"."futures" or false) ||
        (f.tracing_futures."0.2.3".futures-03 or false) ||
        (tracing_futures."0.2.3"."futures-03" or false); }
      { "0.2.3"."futures-task" =
        (f.tracing_futures."0.2.3"."futures-task" or false) ||
        (f.tracing_futures."0.2.3".futures-03 or false) ||
        (tracing_futures."0.2.3"."futures-03" or false); }
      { "0.2.3"."futures_01" =
        (f.tracing_futures."0.2.3"."futures_01" or false) ||
        (f.tracing_futures."0.2.3".futures-01 or false) ||
        (tracing_futures."0.2.3"."futures-01" or false); }
      { "0.2.3"."pin-project" =
        (f.tracing_futures."0.2.3"."pin-project" or false) ||
        (f.tracing_futures."0.2.3".std-future or false) ||
        (tracing_futures."0.2.3"."std-future" or false); }
      { "0.2.3"."std" =
        (f.tracing_futures."0.2.3"."std" or false) ||
        (f.tracing_futures."0.2.3".default or false) ||
        (tracing_futures."0.2.3"."default" or false) ||
        (f.tracing_futures."0.2.3".futures-03 or false) ||
        (tracing_futures."0.2.3"."futures-03" or false); }
      { "0.2.3"."std-future" =
        (f.tracing_futures."0.2.3"."std-future" or false) ||
        (f.tracing_futures."0.2.3".default or false) ||
        (tracing_futures."0.2.3"."default" or false) ||
        (f.tracing_futures."0.2.3".futures-03 or false) ||
        (tracing_futures."0.2.3"."futures-03" or false); }
      { "0.2.3".default = (f.tracing_futures."0.2.3".default or true); }
    ];
  }) [
    (features_.pin_project."${deps."tracing_futures"."0.2.3"."pin_project"}" deps)
    (features_.tracing."${deps."tracing_futures"."0.2.3"."tracing"}" deps)
  ];


# end
# try-lock-0.2.2

  crates.try_lock."0.2.2" = deps: { features?(features_.try_lock."0.2.2" deps {}) }: buildRustCrate {
    crateName = "try-lock";
    version = "0.2.2";
    description = "A lightweight atomic lock.";
    authors = [ "Sean McArthur <sean@seanmonstar.com>" ];
    sha256 = "1k8xc0jpbrmzp0fwghdh6pwzjb9xx2p8yy0xxnnb8065smc5fsrv";
  };
  features_.try_lock."0.2.2" = deps: f: updateFeatures f (rec {
    try_lock."0.2.2".default = (f.try_lock."0.2.2".default or true);
  }) [];


# end
# unicode-segmentation-1.6.0

  crates.unicode_segmentation."1.6.0" = deps: { features?(features_.unicode_segmentation."1.6.0" deps {}) }: buildRustCrate {
    crateName = "unicode-segmentation";
    version = "1.6.0";
    description = "This crate provides Grapheme Cluster, Word and Sentence boundaries\naccording to Unicode Standard Annex #29 rules.\n";
    authors = [ "kwantam <kwantam@gmail.com>" "Manish Goregaokar <manishsmail@gmail.com>" ];
    sha256 = "1i9a9gzj4i7iqwrgfs3dagf3h2b9qxdy7bviykhnsjrxm3azgsyc";
    features = mkFeatures (features."unicode_segmentation"."1.6.0" or {});
  };
  features_.unicode_segmentation."1.6.0" = deps: f: updateFeatures f (rec {
    unicode_segmentation."1.6.0".default = (f.unicode_segmentation."1.6.0".default or true);
  }) [];


# end
# unicode-xid-0.2.0

  crates.unicode_xid."0.2.0" = deps: { features?(features_.unicode_xid."0.2.0" deps {}) }: buildRustCrate {
    crateName = "unicode-xid";
    version = "0.2.0";
    description = "Determine whether characters have the XID_Start\nor XID_Continue properties according to\nUnicode Standard Annex #31.\n";
    authors = [ "erick.tryzelaar <erick.tryzelaar@gmail.com>" "kwantam <kwantam@gmail.com>" ];
    sha256 = "1c85gb3p3qhbjvfyjb31m06la4f024jx319k10ig7n47dz2fk8v7";
    features = mkFeatures (features."unicode_xid"."0.2.0" or {});
  };
  features_.unicode_xid."0.2.0" = deps: f: updateFeatures f (rec {
    unicode_xid."0.2.0".default = (f.unicode_xid."0.2.0".default or true);
  }) [];


# end
# void-1.0.2

  crates.void."1.0.2" = deps: { features?(features_.void."1.0.2" deps {}) }: buildRustCrate {
    crateName = "void";
    version = "1.0.2";
    description = "The uninhabited void type for use in statically impossible cases.";
    authors = [ "Jonathan Reem <jonathan.reem@gmail.com>" ];
    sha256 = "0h1dm0dx8dhf56a83k68mijyxigqhizpskwxfdrs1drwv2cdclv3";
    features = mkFeatures (features."void"."1.0.2" or {});
  };
  features_.void."1.0.2" = deps: f: updateFeatures f (rec {
    void = fold recursiveUpdate {} [
      { "1.0.2"."std" =
        (f.void."1.0.2"."std" or false) ||
        (f.void."1.0.2".default or false) ||
        (void."1.0.2"."default" or false); }
      { "1.0.2".default = (f.void."1.0.2".default or true); }
    ];
  }) [];


# end
# want-0.3.0

  crates.want."0.3.0" = deps: { features?(features_.want."0.3.0" deps {}) }: buildRustCrate {
    crateName = "want";
    version = "0.3.0";
    description = "Detect when another Future wants a result.";
    authors = [ "Sean McArthur <sean@seanmonstar.com>" ];
    edition = "2018";
    sha256 = "0gwk8ybv6c2irgbmk0p3vc81vw71imkvy1vmrrx95kys925wsk2x";
    dependencies = mapFeatures features ([
      (crates."log"."${deps."want"."0.3.0"."log"}" deps)
      (crates."try_lock"."${deps."want"."0.3.0"."try_lock"}" deps)
    ]);
  };
  features_.want."0.3.0" = deps: f: updateFeatures f (rec {
    log."${deps.want."0.3.0".log}".default = true;
    try_lock."${deps.want."0.3.0".try_lock}".default = true;
    want."0.3.0".default = (f.want."0.3.0".default or true);
  }) [
    (features_.log."${deps."want"."0.3.0"."log"}" deps)
    (features_.try_lock."${deps."want"."0.3.0"."try_lock"}" deps)
  ];


# end
# wasi-0.9.0+wasi-snapshot-preview1

  crates.wasi."0.9.0+wasi-snapshot-preview1" = deps: { features?(features_.wasi."0.9.0+wasi-snapshot-preview1" deps {}) }: buildRustCrate {
    crateName = "wasi";
    version = "0.9.0+wasi-snapshot-preview1";
    description = "Experimental WASI API bindings for Rust";
    authors = [ "The Cranelift Project Developers" ];
    edition = "2018";
    sha256 = "0xa6b3rnsmhi13nvs9q51wmavx51yzs5qdbc7bvs0pvs6iar3hsd";
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."wasi"."0.9.0+wasi-snapshot-preview1" or {});
  };
  features_.wasi."0.9.0+wasi-snapshot-preview1" = deps: f: updateFeatures f (rec {
    wasi = fold recursiveUpdate {} [
      { "0.9.0+wasi-snapshot-preview1"."compiler_builtins" =
        (f.wasi."0.9.0+wasi-snapshot-preview1"."compiler_builtins" or false) ||
        (f.wasi."0.9.0+wasi-snapshot-preview1".rustc-dep-of-std or false) ||
        (wasi."0.9.0+wasi-snapshot-preview1"."rustc-dep-of-std" or false); }
      { "0.9.0+wasi-snapshot-preview1"."core" =
        (f.wasi."0.9.0+wasi-snapshot-preview1"."core" or false) ||
        (f.wasi."0.9.0+wasi-snapshot-preview1".rustc-dep-of-std or false) ||
        (wasi."0.9.0+wasi-snapshot-preview1"."rustc-dep-of-std" or false); }
      { "0.9.0+wasi-snapshot-preview1"."rustc-std-workspace-alloc" =
        (f.wasi."0.9.0+wasi-snapshot-preview1"."rustc-std-workspace-alloc" or false) ||
        (f.wasi."0.9.0+wasi-snapshot-preview1".rustc-dep-of-std or false) ||
        (wasi."0.9.0+wasi-snapshot-preview1"."rustc-dep-of-std" or false); }
      { "0.9.0+wasi-snapshot-preview1"."std" =
        (f.wasi."0.9.0+wasi-snapshot-preview1"."std" or false) ||
        (f.wasi."0.9.0+wasi-snapshot-preview1".default or false) ||
        (wasi."0.9.0+wasi-snapshot-preview1"."default" or false); }
      { "0.9.0+wasi-snapshot-preview1".default = (f.wasi."0.9.0+wasi-snapshot-preview1".default or true); }
    ];
  }) [];


# end
# which-3.1.1

  crates.which."3.1.1" = deps: { features?(features_.which."3.1.1" deps {}) }: buildRustCrate {
    crateName = "which";
    version = "3.1.1";
    description = "A Rust equivalent of Unix command \"which\". Locate installed executable in cross platforms.";
    authors = [ "Harry Fei <tiziyuanfang@gmail.com>" ];
    sha256 = "0wcp6rz1h94z382nmywwmcyyrj7bqzq279jg7n6b1aih8a0pbrjz";
    dependencies = mapFeatures features ([
      (crates."libc"."${deps."which"."3.1.1"."libc"}" deps)
    ]);
  };
  features_.which."3.1.1" = deps: f: updateFeatures f (rec {
    libc."${deps.which."3.1.1".libc}".default = true;
    which = fold recursiveUpdate {} [
      { "3.1.1"."failure" =
        (f.which."3.1.1"."failure" or false) ||
        (f.which."3.1.1".default or false) ||
        (which."3.1.1"."default" or false); }
      { "3.1.1".default = (f.which."3.1.1".default or true); }
    ];
  }) [
    (features_.libc."${deps."which"."3.1.1"."libc"}" deps)
  ];


# end
# winapi-0.2.8

  crates.winapi."0.2.8" = deps: { features?(features_.winapi."0.2.8" deps {}) }: buildRustCrate {
    crateName = "winapi";
    version = "0.2.8";
    description = "Types and constants for WinAPI bindings. See README for list of crates providing function bindings.";
    authors = [ "Peter Atashian <retep998@gmail.com>" ];
    sha256 = "0a45b58ywf12vb7gvj6h3j264nydynmzyqz8d8rqxsj6icqv82as";
  };
  features_.winapi."0.2.8" = deps: f: updateFeatures f (rec {
    winapi."0.2.8".default = (f.winapi."0.2.8".default or true);
  }) [];


# end
# winapi-0.3.8

  crates.winapi."0.3.8" = deps: { features?(features_.winapi."0.3.8" deps {}) }: buildRustCrate {
    crateName = "winapi";
    version = "0.3.8";
    description = "Raw FFI bindings for all of Windows API.";
    authors = [ "Peter Atashian <retep998@gmail.com>" ];
    sha256 = "084ialbgww1vxry341fmkg5crgpvab3w52ahx1wa54yqjgym0vxs";
    build = "build.rs";
    dependencies = (if kernel == "i686-pc-windows-gnu" then mapFeatures features ([
      (crates."winapi_i686_pc_windows_gnu"."${deps."winapi"."0.3.8"."winapi_i686_pc_windows_gnu"}" deps)
    ]) else [])
      ++ (if kernel == "x86_64-pc-windows-gnu" then mapFeatures features ([
      (crates."winapi_x86_64_pc_windows_gnu"."${deps."winapi"."0.3.8"."winapi_x86_64_pc_windows_gnu"}" deps)
    ]) else []);
    features = mkFeatures (features."winapi"."0.3.8" or {});
  };
  features_.winapi."0.3.8" = deps: f: updateFeatures f (rec {
    winapi = fold recursiveUpdate {} [
      { "0.3.8"."impl-debug" =
        (f.winapi."0.3.8"."impl-debug" or false) ||
        (f.winapi."0.3.8".debug or false) ||
        (winapi."0.3.8"."debug" or false); }
      { "0.3.8".default = (f.winapi."0.3.8".default or true); }
    ];
    winapi_i686_pc_windows_gnu."${deps.winapi."0.3.8".winapi_i686_pc_windows_gnu}".default = true;
    winapi_x86_64_pc_windows_gnu."${deps.winapi."0.3.8".winapi_x86_64_pc_windows_gnu}".default = true;
  }) [
    (features_.winapi_i686_pc_windows_gnu."${deps."winapi"."0.3.8"."winapi_i686_pc_windows_gnu"}" deps)
    (features_.winapi_x86_64_pc_windows_gnu."${deps."winapi"."0.3.8"."winapi_x86_64_pc_windows_gnu"}" deps)
  ];


# end
# winapi-build-0.1.1

  crates.winapi_build."0.1.1" = deps: { features?(features_.winapi_build."0.1.1" deps {}) }: buildRustCrate {
    crateName = "winapi-build";
    version = "0.1.1";
    description = "Common code for build.rs in WinAPI -sys crates.";
    authors = [ "Peter Atashian <retep998@gmail.com>" ];
    sha256 = "1lxlpi87rkhxcwp2ykf1ldw3p108hwm24nywf3jfrvmff4rjhqga";
    libName = "build";
  };
  features_.winapi_build."0.1.1" = deps: f: updateFeatures f (rec {
    winapi_build."0.1.1".default = (f.winapi_build."0.1.1".default or true);
  }) [];


# end
# winapi-i686-pc-windows-gnu-0.4.0

  crates.winapi_i686_pc_windows_gnu."0.4.0" = deps: { features?(features_.winapi_i686_pc_windows_gnu."0.4.0" deps {}) }: buildRustCrate {
    crateName = "winapi-i686-pc-windows-gnu";
    version = "0.4.0";
    description = "Import libraries for the i686-pc-windows-gnu target. Please don't use this crate directly, depend on winapi instead.";
    authors = [ "Peter Atashian <retep998@gmail.com>" ];
    sha256 = "05ihkij18r4gamjpxj4gra24514can762imjzlmak5wlzidplzrp";
    build = "build.rs";
  };
  features_.winapi_i686_pc_windows_gnu."0.4.0" = deps: f: updateFeatures f (rec {
    winapi_i686_pc_windows_gnu."0.4.0".default = (f.winapi_i686_pc_windows_gnu."0.4.0".default or true);
  }) [];


# end
# winapi-util-0.1.3

  crates.winapi_util."0.1.3" = deps: { features?(features_.winapi_util."0.1.3" deps {}) }: buildRustCrate {
    crateName = "winapi-util";
    version = "0.1.3";
    description = "A dumping ground for high level safe wrappers over winapi.";
    authors = [ "Andrew Gallant <jamslam@gmail.com>" ];
    edition = "2018";
    sha256 = "106v0s03m17lsxiznchghp6z1wzxmwim25d7jc9l7kqmhm88brmn";
    dependencies = (if kernel == "windows" then mapFeatures features ([
      (crates."winapi"."${deps."winapi_util"."0.1.3"."winapi"}" deps)
    ]) else []);
  };
  features_.winapi_util."0.1.3" = deps: f: updateFeatures f (rec {
    winapi = fold recursiveUpdate {} [
      { "${deps.winapi_util."0.1.3".winapi}"."consoleapi" = true; }
      { "${deps.winapi_util."0.1.3".winapi}"."errhandlingapi" = true; }
      { "${deps.winapi_util."0.1.3".winapi}"."fileapi" = true; }
      { "${deps.winapi_util."0.1.3".winapi}"."minwindef" = true; }
      { "${deps.winapi_util."0.1.3".winapi}"."processenv" = true; }
      { "${deps.winapi_util."0.1.3".winapi}"."std" = true; }
      { "${deps.winapi_util."0.1.3".winapi}"."winbase" = true; }
      { "${deps.winapi_util."0.1.3".winapi}"."wincon" = true; }
      { "${deps.winapi_util."0.1.3".winapi}"."winerror" = true; }
      { "${deps.winapi_util."0.1.3".winapi}"."winnt" = true; }
      { "${deps.winapi_util."0.1.3".winapi}".default = true; }
    ];
    winapi_util."0.1.3".default = (f.winapi_util."0.1.3".default or true);
  }) [
    (features_.winapi."${deps."winapi_util"."0.1.3"."winapi"}" deps)
  ];


# end
# winapi-x86_64-pc-windows-gnu-0.4.0

  crates.winapi_x86_64_pc_windows_gnu."0.4.0" = deps: { features?(features_.winapi_x86_64_pc_windows_gnu."0.4.0" deps {}) }: buildRustCrate {
    crateName = "winapi-x86_64-pc-windows-gnu";
    version = "0.4.0";
    description = "Import libraries for the x86_64-pc-windows-gnu target. Please don't use this crate directly, depend on winapi instead.";
    authors = [ "Peter Atashian <retep998@gmail.com>" ];
    sha256 = "0n1ylmlsb8yg1v583i4xy0qmqg42275flvbc51hdqjjfjcl9vlbj";
    build = "build.rs";
  };
  features_.winapi_x86_64_pc_windows_gnu."0.4.0" = deps: f: updateFeatures f (rec {
    winapi_x86_64_pc_windows_gnu."0.4.0".default = (f.winapi_x86_64_pc_windows_gnu."0.4.0".default or true);
  }) [];


# end
# ws2_32-sys-0.2.1

  crates.ws2_32_sys."0.2.1" = deps: { features?(features_.ws2_32_sys."0.2.1" deps {}) }: buildRustCrate {
    crateName = "ws2_32-sys";
    version = "0.2.1";
    description = "Contains function definitions for the Windows API library ws2_32. See winapi for types and constants.";
    authors = [ "Peter Atashian <retep998@gmail.com>" ];
    sha256 = "1zpy9d9wk11sj17fczfngcj28w4xxjs3b4n036yzpy38dxp4f7kc";
    libName = "ws2_32";
    build = "build.rs";
    dependencies = mapFeatures features ([
      (crates."winapi"."${deps."ws2_32_sys"."0.2.1"."winapi"}" deps)
    ]);

    buildDependencies = mapFeatures features ([
      (crates."winapi_build"."${deps."ws2_32_sys"."0.2.1"."winapi_build"}" deps)
    ]);
  };
  features_.ws2_32_sys."0.2.1" = deps: f: updateFeatures f (rec {
    winapi."${deps.ws2_32_sys."0.2.1".winapi}".default = true;
    winapi_build."${deps.ws2_32_sys."0.2.1".winapi_build}".default = true;
    ws2_32_sys."0.2.1".default = (f.ws2_32_sys."0.2.1".default or true);
  }) [
    (features_.winapi."${deps."ws2_32_sys"."0.2.1"."winapi"}" deps)
    (features_.winapi_build."${deps."ws2_32_sys"."0.2.1"."winapi_build"}" deps)
  ];


# end
# yaml-rust-0.4.3

  crates.yaml_rust."0.4.3" = deps: { features?(features_.yaml_rust."0.4.3" deps {}) }: buildRustCrate {
    crateName = "yaml-rust";
    version = "0.4.3";
    description = "The missing YAML 1.2 parser for rust";
    authors = [ "Yuheng Chen <yuhengchen@sensetime.com>" ];
    sha256 = "09p179lz1gjdpa0c58164dc4cs7ijw3j1aqflpshnl1zwvfsgwyx";
    dependencies = mapFeatures features ([
      (crates."linked_hash_map"."${deps."yaml_rust"."0.4.3"."linked_hash_map"}" deps)
    ]);
  };
  features_.yaml_rust."0.4.3" = deps: f: updateFeatures f (rec {
    linked_hash_map."${deps.yaml_rust."0.4.3".linked_hash_map}".default = true;
    yaml_rust."0.4.3".default = (f.yaml_rust."0.4.3".default or true);
  }) [
    (features_.linked_hash_map."${deps."yaml_rust"."0.4.3"."linked_hash_map"}" deps)
  ];


# end
}
