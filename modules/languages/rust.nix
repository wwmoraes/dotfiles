{
  flake.modules.homeManager.default = {
    # home.sessionPath = lib.mkMerge [
    #   (lib.mkBefore [
    #     "${config.home.homeDirectory}/.cargo/bin"
    #   ])
    # ];

    programs.helix = {
      languageSettings.rust.formatter.command = "rustfmt";
    };
  };
}
