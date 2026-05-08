{
  inputs,
  lib,
  ...
}:
{
  flake-file.inputs.nixpkgs.url = "github:NixOS/nixpkgs/release-25.11";

  flake.modules.generic.default = {
    nixpkgs.flake.source = lib.mkForce inputs.nixpkgs;
  };
}
