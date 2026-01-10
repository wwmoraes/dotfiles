{
  inputs,
  ...
}:
{
  flake-file.inputs.nur = {
    inputs.nixpkgs.follows = "nixpkgs";
    inputs.flake-parts.follows = "flake-parts";
    url = "github:nix-community/NUR";
  };

  flake.overlays.nur = inputs.nur.overlays.default;
}
