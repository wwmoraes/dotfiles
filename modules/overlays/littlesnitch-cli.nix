{
  self,
  ...
}:
{
  flake.overlays.littlesnitch-cli =
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

  flake.modules.generic.default = {
    nixpkgs.overlays = [
      self.overlays.littlesnitch-cli
    ];
  };
}
