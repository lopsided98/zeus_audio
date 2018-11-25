{ buildPythonPackage, grpcio-tools, flask, flask-cors, grpcio, pyyaml }:
  
buildPythonPackage rec {
  pname = "audio_recorder";
  version = "0.3.0";
  
  src = { outPath = ./.; revCount = 1234; shortRev = "abcdef"; };
        
  nativeBuildInputs = [
    grpcio-tools
  ];

  propagatedBuildInputs = [
    flask
    flask-cors
    grpcio
    pyyaml
  ];
}
