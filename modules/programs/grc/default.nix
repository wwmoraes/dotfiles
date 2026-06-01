{
  flake.modules.darwin.shell'personal =
    {
      config,
      ...
    }:
    {
      system.defaults.CustomSystemPreferences."/Library/Preferences/com.apple.TimeMachine".SkipPaths =
        config.users.users
        |> builtins.attrValues
        |> builtins.concatMap (user: [
          "${user.home}/.grc"
        ]);
    };

  flake.modules.homeManager.shell'personal =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      home.file = {
        ".grc/conf.dockerstats".source = ./conf.dockerstats;
        ".grc/conf.env".source = ./conf.env;
        ".grc/conf.golang".source = ./conf.golang;
        ".grc/grc.conf".source = ./grc.conf;
      };

      home.packages = [
        pkgs.grc
      ]
      ++ lib.optional config.programs.fish.enable pkgs.fishPlugins.grc;

      home.sessionVariables = {
        grc_plugin_extras = builtins.concatStringsSep " " [
          "cc"
          "docker"
          "g++"
          "go"
          "journalctl"
          "lastb"
          "lastlog"
          "printenv"
          "w"
          "who"
        ];
        grc_plugin_ignore_execs = builtins.concatStringsSep " " [
          "env"
        ];
      };
    };
}
