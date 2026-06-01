{
  flake.modules.darwin.personal =
    {
      config,
      ...
    }:
    {
      homebrew.casks = [
        "das-keyboard-q"
      ];

      system.defaults.CustomSystemPreferences."/Library/Preferences/com.apple.TimeMachine".SkipPaths =
        config.users.users
        |> builtins.attrValues
        |> builtins.concatMap (user: [
          "${user.home}/.quio"
        ]);
    };
}
