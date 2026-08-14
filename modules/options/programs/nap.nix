{
  flake.modules.homeManager.default =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib)
        mkEnableOption
        mkPackageOption
        mkIf
        ;

      cfg = config.programs.nap;
      yaml = pkgs.formats.yaml { };
    in
    {
      meta.maintainers = [
        lib.maintainers.wwmoraes or "wwmoraes"
      ];

      options = {
        programs.nap = {
          enable = mkEnableOption "Code snippets in your terminal";

          package = mkPackageOption pkgs "nap" {
            default = [ "nap" ];
          };
        };
      };

      config = mkIf cfg.enable {
        home.packages = mkIf (cfg.package != null) [
          cfg.package
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
      };
    };
}
