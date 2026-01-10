{
  inputs,
  ...
}:
{
  flake-file.inputs.treefmt-nix = {
    inputs.nixpkgs.follows = "nixpkgs";
    url = "github:numtide/treefmt-nix";
  };

  imports = [
    inputs.treefmt-nix.flakeModule
  ];
}
