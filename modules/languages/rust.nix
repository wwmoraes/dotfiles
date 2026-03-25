{
  flake.modules.darwin.default =
    {
      config,
      ...
    }:
    {
      system.defaults.CustomSystemPreferences."/Library/Preferences/com.apple.TimeMachine".SkipPaths =
        config.users.users
        |> builtins.attrValues
        |> builtins.concatMap (user: [
          "${user.home}/.cargo"
          "${user.home}/.rustup"
        ]);
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
