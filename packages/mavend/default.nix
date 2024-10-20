{
  lib,
  fetchFromGitHub,
  graalvm-ce,
  maven,
}:

maven.buildMavenPackage rec {
  pname = "mvnd";
  version = "1.0-m8";

  src = fetchFromGitHub {
    owner = "apache";
    repo = "maven-mvnd";
    rev = "1.0-m8";
    hash = "sha256-tC1nN81aimfA0CWQAU6J/QEXO2mmSQln+dkiB2jyqfI=";
  };

  mvnHash = "sha256-9RvtBhnZtNjjgZcnUIOt62ONRINyHp+GSfzshRbLNcw=";
  mvnFetchExtraArgs = {
    JAVA_HOME = "${graalvm-ce}";

    nativeBuildInputs = [
      maven
      graalvm-ce
    ];
  };

  JAVA_HOME = "${graalvm-ce}";

  nativeBuildInputs = [ graalvm-ce ];
  mvnDepsParameters = "-Dmaven.test.skip=true -Dmaven.buildNumber.revisionOnScmFailure=no-scm -Dmaven.buildNumber.doUpdate=false -Dmaven.buildNumber.doCheck=false -Dmaven.buildNumber.skip=true -Drat.skip=true";
  mvnParameters = "${mvnDepsParameters} -Pnative";
  installPhase = ''
    set -x
    mkdir -p $out
    cp -a dist-m39/target/maven-mvnd-1.0-m8-m39-linux-amd64/. $out/

  '';

  meta = with lib; {
    # description = "Simple command line wrapper around JD Core Java Decompiler project";
    # homepage = "https://github.com/intoolswetrust/jd-cli";
    # license = licenses.gpl3Plus;
    # maintainers = with maintainers; [ majiir ];
  };
}
