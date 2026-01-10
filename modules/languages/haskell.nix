{
  flake.modules.homeManager.default = {
    # home.sessionPath = lib.mkMerge [
    #   (lib.mkBefore [
    #     "${config.home.homeDirectory}/.cabal/bin"
    #   ])
    # ];
  };
}
