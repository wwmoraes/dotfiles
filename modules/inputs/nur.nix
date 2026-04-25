{
  inputs,
  ...
}:
{
  flake-file = {
    inputs.nur = {
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
      url = "github:nix-community/NUR";
    };
    nixConfig = {
      extra-substituters = [
        "https://wwmoraes.cachix.org/"
      ];
      extra-trusted-public-keys = [
        "wwmoraes.cachix.org-1:N38Kgu19R66Jr62aX5rS466waVzT5p/Paq1g6uFFVyM="
      ];
    };
  };

  flake.overlays.nur = inputs.nur.overlays.default;
}
