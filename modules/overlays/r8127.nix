{
  self,
  ...
}:
{
  flake.overlays.r8127 =
    final: prev:
    prev.lib.optionalAttrs prev.stdenv.hostPlatform.isLinux {
      linuxPackages = prev.linuxPackages.extend (
        final: prev: {
          r8127 = prev.callPackage ./_r8127.nix { };
        }
      );
    };

  flake.modules.nixos.default = {
    nixpkgs.overlays = [
      self.overlays.r8127
    ];
  };
}
