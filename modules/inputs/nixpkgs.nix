{
  inputs,
  self,
  ...
}:
let
  # sets common options for a nixpkgs import/config setup
  nixpkgsCommonArgs = {
    overlays = builtins.attrValues self.overlays;
  };
in
{
  flake-file.inputs.nixpkgs.url = "github:NixOS/nixpkgs/25.11";

  perSystem =
    { system, ... }:
    {
      _module.args.pkgs = import inputs.nixpkgs (nixpkgsCommonArgs // { inherit system; });
    };

  flake.modules.generic.default = {
    nixpkgs = nixpkgsCommonArgs;
  };

  flake.modules.generic.personal =
    {
      lib,
      ...
    }:
    {
      nixpkgs.config.allowUnfreePredicate =
        pkg:
        builtins.elem (lib.getName pkg) [
          # keep-sorted start
          "slack"
          # keep-sorted end
        ];
    };

  flake.modules.generic.work =
    {
      lib,
      ...
    }:
    {
      nixpkgs.config.allowUnfreePredicate =
        pkg:
        builtins.elem (lib.getName pkg) [
          # keep-sorted start
          "vscode"
          # keep-sorted end
        ];
    };
}
