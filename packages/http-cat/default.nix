{
  runCommand,
  fetchFromGitHub,
}:
let
  src = fetchFromGitHub {
    owner = "httpcats";
    repo = "http.cat";
    rev = "59271bec6d16afee554691b1bad092d68a8bf7ae";
    hash = "sha256-2PRLV0/hpEXeuz4HcmSpvLj33SAaVV/+8rsF+XFFRtU=";
  };
in

runCommand "http-cat" { } ''
  mkdir $out
  cp -r ${src}/public/images/. $out/
''
