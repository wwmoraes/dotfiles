{
  flake.modules.darwin.default =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib)
        mkEnableOption
        mkIf
        mkOption
        ;

      cfg = config.services.littlesnitch;
    in
    {
      meta.maintainers = [
        lib.maintainers.wwmoraes or "wwmoraes"
      ];

      options.services.littlesnitch = {
        enable = mkEnableOption "Host-based application firewall";

        settings = mkOption {
          type = import ./_lsbackup.nix { inherit lib; };
          default = { };
        };
      };

      config = mkIf cfg.enable {
        environment.systemPackages = [
          pkgs.littlesnitch-cli
        ];

        homebrew.casks = [
          {
            name = "little-snitch";
            args = {
              appdir = "/Applications";
            };
          }
        ];
      };
    };
}
