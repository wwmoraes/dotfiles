{
  perSystem =
    {
      pkgs,
      ...
    }:
    {
      packages.switch-home = pkgs.writeShellScriptBin "switch-home" ''
        HOSTNAME=$(scutil --get LocalHostName)
        ROOT="''${1:-.}"
        exec nix run $ROOT#darwinConfigurations.$HOSTNAME.config.home-manager.users.$USER.home.activationPackage
      '';
    };
}
