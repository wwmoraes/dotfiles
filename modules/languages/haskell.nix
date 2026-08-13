{
  flake.modules.darwin.default = {
    system.defaults.timemachine.perUser.home.SkipPaths = [
      ".cabal"
      ".stack"
    ];
  };

  flake.modules.homeManager.default = {
    # home.sessionPath = lib.mkMerge [
    #   (lib.mkBefore [
    #     "${config.home.homeDirectory}/.cabal/bin"
    #   ])
    # ];
  };
}
