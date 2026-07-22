{
  flake.modules.darwin.default =
    {
      ...
    }:
    {
      system.defaults.timemachine.perUser.home.SkipPaths = [
        ".cargo"
        ".rustup"
      ];
    };

  flake.modules.homeManager.default = {
    # home.sessionPath = lib.mkMerge [
    #   (lib.mkBefore [
    #     "${config.home.homeDirectory}/.cargo/bin"
    #   ])
    # ];

    programs.helix = {
      properties.languages.rust.formatter.command = "rustfmt";
    };
  };
}
