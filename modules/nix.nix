{
  flake-file.nixConfig = {
    warn-dirty = false;
  };

  flake.modules.generic.default = {
    nix = {
      settings = {
        require-sigs = true;
        sandbox = true;
        sandbox-fallback = false;
        warn-dirty = false;
      };
    };
  };

  flake.modules.darwin.default = {
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
