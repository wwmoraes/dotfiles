{
  flake.modules.homeManager.default = {
    programs.man = {
      enable = true;
    };
  };

  flake.modules.nixos.default = {
    # TODO fix man cache generation
    # https://discourse.nixos.org/t/slow-build-at-building-man-cache/52365/2
    documentation.man.generateCaches = false;
  };
}
