_: {
  #Bluetooth.
  environment.persistence."/pst".directories = [ "/var/lib/bluetooth" ];

  #Enable bluetooth
  hardware.bluetooth.enable = true;
}
