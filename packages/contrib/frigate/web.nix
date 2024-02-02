{ buildNpmPackage
, src
, version
, lib
}:

buildNpmPackage {
  pname = "frigate-web";
  inherit version src;

  sourceRoot = "${src.name}/web";

  postPatch = ''
    substituteInPlace package.json \
      --replace "--base=/BASE_PATH/" ""

    substituteInPlace src/routes/Storage.jsx \
      --replace "/media/frigate" "/var/lib/frigate" \
      --replace "/tmp/cache" "/var/cache/frigate"
  '';

  npmDepsHash = "sha256-+36quezGArqIM9dM+UihwcIgmE3EVmJQThuicLgDW4A=";

  installPhase = ''
    cp -rv dist/ $out
  '';
}
