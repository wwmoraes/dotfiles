{
  imports = [
    ## TODO figure out a way to import here that doesn't cause an inf recursion
    # (config.nixpkgs.source + /nixos/modules/programs/less.nix)
  ];

  home-manager.sharedModules = [
    {
      disabledModules = [
        "programs/less.nix"
      ];
    }
  ];
}
