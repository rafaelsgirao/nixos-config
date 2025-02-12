_: {
  services.polaris = {
    enable = true;
    port = 30901;
    settings = {
      settings.reindex_every_n_seconds = 7 * 24 * 60 * 60; # weekly, default is 1800

      settings.album_art_pattern = "(cover|front|folder)\.(jpeg|jpg|png|bmp|gif)";

      settings.mount_dirs = [
        {
          name = "RGMusic";
          source = "/library/Music";
        }
      ];

    };

  };

  environment.persistence."/pst".directories = [ "/var/lib/private/polaris" ];
}
