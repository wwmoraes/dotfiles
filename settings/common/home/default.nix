{
  home-manager.sharedModules = [
    # keep-sorted start
    ./languages
    ./programs
    ./stylix
    # keep-sorted end
    # keep-sorted start
    ./editorconfig.nix
    ./environment.nix
    ./language.nix
    ./xdg.nix
    # keep-sorted end
  ];
}
