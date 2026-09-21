{
  flake.modules.darwin.default =
    {
      config,
      ...
    }:
    {
      system.defaults.timemachine = {
        SkipPaths =
          config.home-manager.users
          |> builtins.mapAttrs (
            username: userConfig:
            if userConfig.programs.grc.enable then "${userConfig.home.homeDirectory}/.grc" else null
          )
          |> builtins.attrValues
          |> builtins.filter builtins.isString;
      };
    };

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

      cfg = config.programs.grc;
    in
    {
      meta.maintainers = [
        lib.maintainers.wwmoraes
      ];

      options = {
        programs.grc = {
          enable = mkEnableOption "Generic text colouriser";

          package = mkPackageOption pkgs "grc" {
            default = [ "grc" ];
          };
        };
      };

      config = mkIf cfg.enable {
        home.packages =
          mkIf (cfg.package != null) [
            cfg.package
          ]
          ++ lib.optional config.programs.fish.enable pkgs.fishPlugins.grc;
      };
    };
}
