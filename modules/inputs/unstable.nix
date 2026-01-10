{
  inputs,
  ...
}:
{
  flake-file.inputs.unstable.url = "github:NixOS/nixpkgs";

  flake.overlays.unstable = final: prev: {
    unstable = import inputs.unstable { inherit (prev.stdenv.hostPlatform) system; };
  };
}
