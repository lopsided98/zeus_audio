{ lib, buildPythonPackage, python, aiohttp, aiohttp-cors, aiohttp-jinja2, grpcio
, dev ? false, pylint, rope, black }:
  
buildPythonPackage rec {
  pname = "audio_recorder";
  version = "0.5.0";

  src = ./.;

  nativeBuildInputs = with python.pythonOnBuildForHost.pkgs; [
    grpcio-tools
  ] ++ lib.optionals dev [
    pylint
    rope
    black
  ];

  propagatedBuildInputs = [
    aiohttp
    aiohttp-cors
    aiohttp-jinja2
    grpcio
  ];

  outputs = [ "out" "dev" ];

  # False positive due to both build and host grpcio on PYTHONPATH
  dontUsePythonCatchConflicts = true;

  postShellHook = ''
    export PYTHONPATH="${toString ./.}:$PYTHONPATH"
  '';
}
