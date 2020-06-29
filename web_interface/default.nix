{ buildPythonPackage, grpcio-tools, flask, flask-cors, grpcio, pyyaml }:
  
buildPythonPackage rec {
  pname = "audio_recorder";
  version = "0.4.0";
  
  src = { outPath = ./.; revCount = 1234; shortRev = "abcdef"; };
        
  nativeBuildInputs = [
    grpcio-tools
    flask
  ];

  propagatedBuildInputs = [
    flask
    flask-cors
    grpcio
    pyyaml
  ];

  postShellHook = ''
    export PYTHONPATH="${toString ./.}:$PYTHONPATH"
  '';
}
