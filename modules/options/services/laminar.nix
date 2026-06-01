{
  flake.modules.homeManager.default =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      cfg = config.services.laminar;
    in
    {
      meta.maintainers = [ lib.maintainers.wwmoraes ];

      options.services.laminar =
        let
          inherit (lib)
            mkEnableOption
            mkPackageOption
            mkOption
            types
            ;
        in
        {
          enable = mkEnableOption "Lightweight and modular continuous integration service";
          package = mkPackageOption pkgs "laminar" { };
          settings = mkOption {
            type = with types; attrsOf str;
            default = { };
          };
          user = mkOption {
            type = types.str;
            default = config.home.username;
          };
        };

      config = lib.mkIf cfg.enable {
        assertions = [
          (lib.hm.assertions.assertPlatform "services.laminar" pkgs lib.platforms.linux)
        ];

        xdg.configFile."home-services/laminar/laminar.conf".text =
          lib.generators.toKeyValue { }
            cfg.settings;

        systemd.user.services.laminar = {
          Unit = {
            Description = "Laminar continuous integration service";
            After = "network.target";
            Documentation = [
              "man:laminard(8)"
              "https://laminar.ohwg.net/docs.html"
            ];
          };
          Service = {
            User = cfg.user;
            EnvironmentFile = "-${config.xdg.configHome}/home-services/laminar/laminar.conf";
            ExecStart = "${lib.getExe' cfg.package "laminard"} -v";
          };
          Install = {
            WantedBy = [ "default.target" ];
          };
        };
      };
    };
}
