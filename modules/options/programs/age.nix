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

      cfg = config.programs.age;
    in
    {
      meta.maintainers = [
        lib.maintainers.wwmoraes or "wwmoraes"
      ];

      options = {
        programs.age = {
          enable = mkEnableOption "Modern encryption tool with small explicit keys";

          package = mkPackageOption pkgs "age" {
            default = [ "age" ];
          };
        };
      };

      config = mkIf cfg.enable {
        home.packages = mkIf (cfg.package != null) [
          cfg.package
        ];
      };
    };
}
