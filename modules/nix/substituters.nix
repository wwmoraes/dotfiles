{
  flake-file.nixConfig = {
    substituters = [
      "https://cache.nixos.org/"
      "https://nix-community.cachix.org/"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  flake.modules.generic.default = {
    nix.settings = {
      substituters = [
        "https://wwmoraes.cachix.org/"
        "https://nix-community.cachix.org/"
      ];
      trusted-public-keys = [
        "wwmoraes.cachix.org-1:N38Kgu19R66Jr62aX5rS466waVzT5p/Paq1g6uFFVyM="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };
}
