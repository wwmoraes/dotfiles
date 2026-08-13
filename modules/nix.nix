{
  flake-file.nixConfig = {
    warn-dirty = false;
  };

  flake.modules.generic.default = {
    nix = {
      settings = {
        accept-flake-config = true;
        require-sigs = true;
        sandbox = true;
        sandbox-fallback = false;
        warn-dirty = false;
      };
    };
  };

  flake.modules.darwin.multi-user = {
    ids.gids.nixbld = 350;
    nix.enable = true;
  };

  flake.modules.darwin.personal = {
    system.defaults.timemachine = {
      SkipPaths = [
        /nix
      ];

      perUser.home.SkipPaths = [
        ".nix-defexpr"
        ".nix-profile"
      ];
    };
  };
}
