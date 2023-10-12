{ writeScriptBin, inputs, ... }:
writeScriptBin "setupSecrets"
  (inputs.dsi-setupsecrets + "setupSecrets")

