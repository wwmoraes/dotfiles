{
  nixpkgs.config.allowUnfreePackages = [
    "plexmediaserver"
  ];

  services.plex = {
    enable = true;
  };

  system.stateVersion = "25.05";
}
