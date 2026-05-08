{
  inputs,
  self,
  ...
}:
{
  flake-file.inputs.unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  flake.overlays.unstable = final: prev: {
    unstable = import inputs.unstable { inherit (prev.stdenv.hostPlatform) system; };
  };

  flake.modules.generic.default = {
    nixpkgs.overlays = [
      self.overlays.unstable
    ];

    nix.registry.unstable.to = {
      type = "path";
      path = inputs.unstable;
    };
  };
}
