{
  flake.modules.homeManager.shell =
    {
      config,
      pkgs,
      ...
    }:
    {
      home.packages = [
        config.services.tldr-update.package
      ];

      services.tldr-update = {
        enable = true;
        package = pkgs.tlrc;
      };
    };

  flake.modules.darwin.shell =
    {
      config,
      ...
    }:
    {
      system.defaults.CustomSystemPreferences."/Library/Preferences/com.apple.TimeMachine".SkipPaths =
        config.users.users
        |> builtins.attrValues
        |> builtins.concatMap (user: [
          "${user.home}/.tldrc"
        ]);
    };
}
