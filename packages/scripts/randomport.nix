{ writeShellApplication, netcat }:
writeShellApplication {
  name = "randomport";

  runtimeInputs = [ netcat ];

  text = builtins.readFile ./randomport.sh;
}
