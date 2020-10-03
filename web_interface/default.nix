{ buildPythonPackage, python, flask, flask-cors, grpcio, pyyaml }:
  
buildPythonPackage rec {
  pname = "audio_recorder";
  version = "0.4.0";
  
  src = ./.;
        
  nativeBuildInputs = with python.pythonForBuild.pkgs; [
    grpcio-tools
    flask
  ];

  propagatedBuildInputs = [
    flask
    flask-cors
    grpcio
    pyyaml
  ];

  # False positive due to both build and host grpcio on PYTHONPATH
  dontUsePythonCatchConflicts = true;

  postShellHook = ''
    export PYTHONPATH="${toString ./.}:$PYTHONPATH"
  '';
}
