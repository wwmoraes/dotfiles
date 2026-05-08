{
  config,
  inputs,
  lib,
  ...
}:
let
  nixpkgsConfig = config.nixpkgs.config;
in
{
  flake.modules.nixos.media-server =
    {
      pkgs,
      ...
    }:
    {
      containers.nzbget = {
        autoStart = true;
        # TODO review IFD and factor it out if possible
        config =
          { config, ... }:
          {
            imports = [
              ./_configuration.nix
            ];
            nixpkgs = {
              config.allowUnfreePredicate =
                pkg:
                builtins.elem (lib.getName pkg) (
                  # NixOS compatibility + forward compatibility once nix-darwin supports a mergeable config prop
                  nixpkgsConfig.allowUnfreePackages ++ (config.nixpkgs.config.allowUnfreePackages or [ ])
                );
              flake.source = lib.mkForce inputs.nixpkgs;
            };
          };
        nixpkgs = pkgs.path;
        privateNetwork = true;
        privateUsers = "pick";
        bindMounts = {
          "/var/lib/nzbget" = {
            hostPath = "/var/lib/nzbget";
            isReadOnly = false;
          };
        };
        forwardPorts = [
          {
            protocol = "tcp";
            hostPort = 6791;
            containerPort = 6791;
          }
        ];
      };
    };
}
