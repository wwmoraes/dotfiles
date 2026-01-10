{
  perSystem =
    {
      pkgs,
      self',
      ...
    }:
    {
      packages.default = self'.packages.switch-system;
      packages.switch-system = pkgs.writeShellScriptBin "switch-system" ''
        ROOT="''${1:-.}"
        exec sudo nix \
        --option accept-flake-config true \
        --option build-users-group "" \
        --extra-experimental-features "nix-command flakes" \
        run .#darwin-rebuild -- switch --no-remote --flake $ROOT
      '';
    };
}
