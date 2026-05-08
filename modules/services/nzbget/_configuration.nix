{
  nixpkgs.config.allowUnfreePackages = [
    "unrar"
  ];

  services.nzbget = {
    enable = true;
  };

  system.stateVersion = "25.05";
}
