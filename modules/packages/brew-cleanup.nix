{
  perSystem =
    {
      pkgs,
      ...
    }:
    {
      ## nix-homebrew doesn't export the package, it is added directly to the system packages...
      ## builtins.filter (pkg: pkg.name == "brew") darwinConfigurations.M1Cabuk.config.environment.systemPackages
      packages.brew-cleanup = pkgs.writeShellScriptBin "brew-cleanup" ''
        brew update
        brew bundle --cleanup
      '';
    };
}
