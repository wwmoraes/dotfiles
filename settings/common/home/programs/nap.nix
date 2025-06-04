{
  config,
  pkgs,
  ...
}:
let
  yaml = pkgs.formats.yaml { };
in
{
  home.packages = [
    pkgs.nap
  ];

  home.sessionVariables = {
    NAP_CONFIG = "${config.xdg.configHome}/nap/config.yaml";
    NAP_HOME = "${config.xdg.configHome}/nap";
  };

  xdg.configFile."nap/config.yaml" = {
    source = yaml.generate "nap-config.yaml" {
      default_language = "fish";
      home = "${config.xdg.configHome}/nap";
    };
  };
}
