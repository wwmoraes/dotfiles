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
  flake.modules.darwin.personal = {
    homebrew.casks = [
      "macfuse" # # needed by resilio-sync
      "resilio-sync"
    ];
  };

  flake.modules.nixos.nas =
    {
      pkgs,
      ...
    }:
    {
      containers.resilio = {
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
          "/srv/resilio" = {
            hostPath = "/srv/resilio";
            isReadOnly = false;
          };
          "/var/lib/resilio" = {
            hostPath = "/var/lib/resilio";
            isReadOnly = false;
          };
        };
        forwardPorts = [
          {
            protocol = "tcp";
            hostPort = 9000;
            containerPort = 9000;
          }
        ];
      };
    };
}
