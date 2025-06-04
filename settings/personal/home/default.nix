{
  home-manager.sharedModules = [
    ./programs

    ./llm.nix
  ];

  nixpkgs.config.allowUnfree = true;
}
