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

      cfg = config.programs.tree;
    in
    {
      meta.maintainers = [
        lib.maintainers.wwmoraes or "wwmoraes"
      ];

      options = {
        programs.tree = {
          enable = mkEnableOption "Command to produce a depth indented directory listing";

          package = mkPackageOption pkgs "tree" {
            default = [ "tree" ];
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
