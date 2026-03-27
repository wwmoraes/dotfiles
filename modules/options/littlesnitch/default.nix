{
  flake.overlays.littlesnitch =
    final: prev:
    prev.lib.optionalAttrs prev.stdenv.hostPlatform.isDarwin {
      littlesnitch-cli = prev.stdenv.mkDerivation {
        pname = "littlesnitch-cli";
        version = "1.0.0";
        phases = [
          "\${preInstallPhases[*]:-}"
          "installPhase"
          "installCheckPhase"
          "\${postPhases[*]:-}"
        ];
        installPhase = ''
          runHook preInstall

          mkdir -p $out/bin
          ln -sf ${prev.lib.escapeShellArg "/Applications/Little Snitch.app/Contents/Components/littlesnitch"} $out/bin/littlesnitch

          runHook postInstall
        '';
      };
    };

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
