{
  flake.modules.darwin.gui'personal'disabled =
    {
      config,
      ...
    }:
    {
      system.defaults.CustomSystemPreferences."/Library/Preferences/com.apple.TimeMachine".SkipPaths =
        config.users.users
        |> builtins.attrValues
        |> builtins.concatMap (user: [
          "${user.home}/.logseq"
        ]);
    };

  flake.modules.homeManager.gui'personal =
    {
      pkgs,
      ...
    }:
    {
      home.packages = [
        pkgs.logseq
      ];
    };
}
