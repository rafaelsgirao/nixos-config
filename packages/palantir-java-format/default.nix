{ jdk17, gradle, fetchFromGitHub, makeWrapper, stdenv, gnutar }:
let

  # This is what makes everything work:
  # --write-verification-metadata forces discovered dependencies to be fetched to cache
  GRADLE_ARGS = "--console plain --no-daemon --write-verification-metadata sha512";
  jdk = jdk17;


  version = "2.50.0";
  src = fetchFromGitHub {
    owner = "palantir";
    repo = "palantir-java-format";
    rev = "${version}";
    hash = "sha256-LMibcs7m3a79WjtmwNMd0laYzVfTC2enTrMXDVUCTKU=";
  };

  CIRCLE_TAG = version;
  dependencies = stdenv.mkDerivation {
    name = "gradle-home-dependencies";
    nativeBuildInputs = [ jdk gradle ];
    inherit src CIRCLE_TAG;
    dontFixup = true;

    buildPhase = ''
      GRADLE_USER_HOME=$(pwd)/.gradle gradle ${GRADLE_ARGS} help
    '';
    installPhase = ''
      # See here for a mapping of gradle version and the respective cache paths:
      # https://docs.gradle.org/8.4/userguide/dependency_resolution.html#sub:ephemeral-ci-cache

      mkdir -p $out/caches/modules-2
      cp -a .gradle/caches/modules-2/. $out/caches/modules-2/

      # Delete extra files to ensure a stable hash
      find $out -type f -regex '.+\\(\\.lastUpdated\\|resolver-status\\.properties\\|_remote\\.repositories\\|\\.lock\\)' -delete
      find $out -type f \( -name "*.log" -o -name "*.lock" -o -name "gc.properties" \) -delete
    '';
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    # outputHash = lib.fakeHash;
    outputHash = "sha256-dWiNzrdRE4cAHsmlG5gtB8qCDQcoDXfSKlbX0GHVVW8=";
  };
in

stdenv.mkDerivation rec {
  pname = "palantir-java-format";
  inherit version;
  name = "${pname}-${version}";

  inherit src dependencies CIRCLE_TAG;
  nativeBuildInputs = [ jdk gradle gnutar makeWrapper ];


  patches = [ ./exclude-ide-plugins.patch ];
  buildPhase = ''
    mkdir .gradle
    # Copy the whole gradle cache to a writeable path, since gradle wants to write more files into the $GRADLE_USER_HOME folder.
    cp -R --no-preserve=all ${dependencies}/. .gradle/
    # Note: Nix Wiki makes use of $GRADLE_OPTS for setting additional gradle arguments, but this environment variable has since been deprecated:
    # https://nixos.wiki/wiki/Android#gradlew
    GRADLE_USER_HOME=$(pwd)/.gradle gradle palantir-java-format:assembleDist --exclude-task verifyLocks --exclude-task palantir-java-format:test --offline ${GRADLE_ARGS}
  '';

  installPhase = ''
    # create the bin directory
    mkdir -p $out
    tar xvf palantir-java-format/build/distributions/palantir-java-format-${version}.tar --strip-components=1 --directory $out 
  '';

  postFixup = ''
    wrapProgram $out/bin/palantir-java-format --set JAVA_HOME ${jdk.home}  \
      --set JAVA_OPTS "--add-opens=java.base/java.lang=ALL-UNNAMED \
        --add-opens=java.base/java.util=ALL-UNNAMED \
        --add-exports=jdk.compiler/com.sun.tools.javac.api=ALL-UNNAMED \
        --add-exports=jdk.compiler/com.sun.tools.javac.file=ALL-UNNAMED \
        --add-exports=jdk.compiler/com.sun.tools.javac.parser=ALL-UNNAMED \
        --add-exports=jdk.compiler/com.sun.tools.javac.tree=ALL-UNNAMED \
        --add-exports=jdk.compiler/com.sun.tools.javac.util=ALL-UNNAMED"
    rm $out/bin/palantir-java-format.bat
    cp $out/bin/palantir-java-format $out/bin/google-java-format # To allow usage with treefmt-nix
  '';

  meta = {
    mainProgram = "palantir-java-format";
  };


}
