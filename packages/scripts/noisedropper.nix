{
  curl,
  grepcidr,
  ipset,
  iptables,
  jq,
  writeShellApplication,
}:
writeShellApplication {
  name = "noisedropper";

  runtimeInputs = [
    curl
    grepcidr
    ipset
    iptables
    jq
  ];

  text = builtins.readFile ./noisedropper.sh;
}
