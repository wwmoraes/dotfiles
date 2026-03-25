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
        mkOption
        ;

      cfg = config.programs.crush;
    in
    {
      meta.maintainers = [
        lib.maintainers.wwmoraes or "wwmoraes"
      ];

      options = {
        programs.crush = {
          enable = mkEnableOption "Glamourous agentic coding for all 💘";

          package = mkPackageOption pkgs "crush" {
            default = [ "crush" ];
          };

          settings = mkOption {
            type = import ./_config.nix { inherit pkgs lib; };
            default = { };
          };
        };
      };

      config = mkIf cfg.enable {
        home.packages = mkIf (cfg.package != null) [
          cfg.package
        ];

        xdg.configFile."crush/crush.json".text = builtins.toJSON cfg.settings;
      };
    };
}
