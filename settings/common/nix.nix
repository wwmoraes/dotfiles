{
  config,
  lib,
  pkgs,
  ...
}:
{
  environment.systemPackages = [
    pkgs.nix
    pkgs.nix-init
    pkgs.nixos-rebuild
    pkgs.nurl
  ];

  nix = {
    package = pkgs.nixVersions.git;
    registry.nixpkgs.to = lib.mkDefault {
      # # see nixpkgs.flake.setFlakeRegistry
      type = "path";
      path = config.nixpkgs.flake.source;
    };
    settings = {
      require-sigs = true;
      sandbox = true;
      substituters = [
        "https://wwmoraes.cachix.org/"
        "https://nix-community.cachix.org/"
        "https://cache.nixos.org/"
      ];
      trusted-public-keys = [
        "wwmoraes.cachix.org-1:N38Kgu19R66Jr62aX5rS466waVzT5p/Paq1g6uFFVyM="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      ];
      trusted-users = [
        "@root"
        "@wheel"
      ];
      warn-dirty = false;
    };
  };
}
