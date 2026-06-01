{
  flake.modules.darwin.gui'personal =
    {
      config,
      ...
    }:
    {
      system.defaults.CustomSystemPreferences."/Library/Preferences/com.apple.TimeMachine".SkipPaths =
        config.users.users
        |> builtins.attrValues
        |> builtins.concatMap (user: [
          "${user.home}/.librewolf"
        ]);
    };

  flake.modules.homeManager.gui'disabled = {
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
