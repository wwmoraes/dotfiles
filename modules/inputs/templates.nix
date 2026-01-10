{
  inputs,
  ...
}:
{
  flake-file.inputs.templates = {
    inputs.flake-parts.follows = "flake-parts";
    inputs.nixpkgs.follows = "nixpkgs";
    inputs.systems.follows = "systems";
    inputs.treefmt-nix.follows = "treefmt-nix";
    url = "github:wwmoraes/templates";
  };

  flake.templates = inputs.templates.templates;

  flake.modules.generic.default = {
    nix.registry.templates.flake = inputs.templates;
  };
}
