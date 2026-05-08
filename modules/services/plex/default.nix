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
      "plex-htpc"
      "plexamp"
    ];
  };

  flake.modules.nixos.media-server =
    {
      pkgs,
      ...
    }:
    {
      containers.plex = {
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
          "/var/lib/plex" = {
            hostPath = "/var/lib/plex";
            isReadOnly = false;
          };
        };
        forwardPorts =
          (map
            (port: {
              protocol = "tcp";
              hostPort = port;
              containerPort = port;
            })
            [
              32400
              3005
              8324
              32469
            ]
          )
          ++ (map
            (port: {
              protocol = "udp";
              hostPort = port;
              containerPort = port;
            })
            [
              1900
              5353
              32410
              32412
              32413
              32414
            ]
          );
      };
    };
}
