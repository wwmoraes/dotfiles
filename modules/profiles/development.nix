{
  flake.modules.generic.profile'development = {
    programs = {
      # keep-sorted start
      direnv.enable = true;
      direnv.nix-direnv.enable = true;
      # keep-sorted end
    };

    services = {
      # keep-sorted start
      # keep-sorted end
    };
  };

  flake.modules.homeManager.profile'development = {
    programs = {
      # keep-sorted start
      direnv.enable = true;
      direnv.nix-direnv.enable = true;
      # keep-sorted end
    };

    services = {
      # keep-sorted start
      # keep-sorted end
    };
  };
}
