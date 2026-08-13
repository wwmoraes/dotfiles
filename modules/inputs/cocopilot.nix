{
  inputs,
  ...
}:
{
  flake-file.inputs.cocopilot = {
    inputs.flake-parts.follows = "flake-parts";
    inputs.flake-utils.follows = "flake-utils";
    inputs.gomod2nix.follows = "gomod2nix";
    inputs.nixpkgs.follows = "nixpkgs";
    inputs.nur.follows = "nur";
    inputs.systems.follows = "systems";
    inputs.treefmt-nix.follows = "treefmt-nix";
    inputs.unstable.follows = "unstable";
    url = "github:wwmoraes/cocopilot";
  };

  flake.modules.generic.default = {
    nixpkgs.overlays = [
      inputs.cocopilot.overlays.default
    ];
  };
}
