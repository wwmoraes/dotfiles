{
  inputs,
  lib,
  ...
}:
{
  flake-file.inputs.nixpkgs.url = "github:NixOS/nixpkgs/release-26.05?shallow=1";

  flake.modules.generic.default = {
    nixpkgs.flake.source = lib.mkForce inputs.nixpkgs;
  };
}
