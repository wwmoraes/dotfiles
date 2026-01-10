{
  inputs,
  ...
}:
{
  flake.modules.darwin.default = {
    imports = [
      (inputs.nixpkgs + /nixos/modules/programs/less.nix)
    ];
  };

  flake.modules.homeManager.default = {
    disabledModules = [
      "programs/less.nix"
    ];
  };
}
