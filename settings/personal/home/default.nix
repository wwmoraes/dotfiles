{
  home-manager.sharedModules = [
    ./programs
  ];

  nixpkgs.config.allowUnfree = true;
}
