{
  pkgs,
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
    pkgs.fishPlugins.grc
  ];

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
}
