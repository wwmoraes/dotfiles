{
  flake.modules.nixos.default = {
    system.stateVersion = "25.05";
  };

  flake.modules.darwin.default = {
    # Used for backwards compatibility, please read the changelog before changing.
    # $ darwin-rebuild changelog
    system.stateVersion = 4;
  };
}
