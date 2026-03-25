{
  flake.modules.darwin.gui =
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
          "${user.home}/.librewolf"
        ]);
    };

  flake.modules.homeManager.gui = {
    programs.librewolf = {
      enable = true;
      profiles.default = { };
      settings = {
        "privacy.clearOnShutdown.cookies" = false;
        "privacy.clearOnShutdown.history" = false;
      };
    };

    stylix.targets.librewolf.profileNames = [ "default" ];
  };
}
