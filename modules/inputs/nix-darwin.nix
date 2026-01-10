{
  config,
  # inputs,
  ...
}:
{
  flake-file.inputs.nix-darwin = {
    inputs.nixpkgs.follows = "nixpkgs";
    url = "github:nix-darwin/nix-darwin/nix-darwin-25.11";
  };

  flake.modules.darwin.default =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        config.flake.packages.${pkgs.stdenv.hostPlatform.system}.darwin-rebuild
        config.flake.packages.${pkgs.stdenv.hostPlatform.system}.switch-system
      ];

      system.tools.darwin-rebuild.enable = false;
    };
}
