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

  flake.modules.darwin.default = {
    nixpkgs.overlays = [
      inputs.nur.overlays.default
    ];
  };

  flake.modules.nixos.default = {
    nixpkgs.overlays = [
      inputs.nur.overlays.default
      (final: prev: prev.nur.repos.wwmoraes.overlays.r8127 final prev)
    ];
  };
}
