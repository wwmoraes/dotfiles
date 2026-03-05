{
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
