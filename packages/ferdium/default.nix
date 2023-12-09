{ lib, buildNpmPackage, fetchFromGitHub, ... }:
buildNpmPackage rec {
  pname = "ferdium-app";
  version = "6.4.1";

  src = fetchFromGitHub {
    owner = "ferdium";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-28n5lobipE6IegU6QyYJt6XnLja7aHK03CRu8EsqNF0=";
  };

  npmDepsHash = "sha256-28n5lobipE6IegU6QyYJt6XnLja7aHK03CRu8EsqNF0=";

  # The prepack script runs the build script, which we'd rather do in the build phase.
  # npmPackFlags = [ "--ignore-scripts" ];

  # NODE_OPTIONS = "--openssl-legacy-provider";

  meta = with lib; {
    # description = "A modern web UI for various torrent clients with a Node.js backend and React frontend";
    # homepage = "https://flood.js.org";
    # license = licenses.gpl3Only;
    # maintainers = with maintainers; [ winter ];
  };
}

