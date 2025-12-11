{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkPackageOption
    types
    mkOption
    ;
  inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;

  cfg = config.services.docker;
  configText = lib.generators.toJSON { } cfg.settings;
in
{
  meta.maintainers = [
    lib.maintainers.wwmoraes or "wwmoraes"
  ];

  options = {
    services.docker = {
      enable = mkEnableOption "Docker daemon to run containerized applications";

      package = mkPackageOption pkgs "docker" {
        nullable = true;
        default = "docker";
      };

      settings = mkOption {
        default = { };
        type = with types; attrsOf anything;
      };

      desktopSettings = mkOption {
        default = { };
        type = with types; attrsOf anything;
      };
    };
  };

  ## TODO converge docker settings with NixOS options
  ## see https://search.nixos.org/options?channel=25.05&show=virtualisation.docker.daemon.settings&from=0&size=50&sort=relevance&type=packages&query=virtualisation.docker
  config = mkIf cfg.enable {
    ## TODO move rootless docker configuration to virtualisation group
    ## https://github.com/NixOS/nixpkgs/blob/nixos-25.05/nixos/modules/virtualisation/docker-rootless.nix
    environment.etc."docker/daemon.json".text = mkIf isLinux configText;

    environment.systemPackages = lib.optional cfg.enable cfg.package;

    home-manager.sharedModules = [
      (
        { config, lib, ... }:
        {
          home.activation.unlinkDockerDesktop = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
            ## replaces links with file copy otherwise Docker Desktop fails to start...

            run sed --in-place= ';' "${config.home.homeDirectory}/Library/Group Containers/group.com.docker/settings-store.json"
            run chmod u+w "${config.home.homeDirectory}/Library/Group Containers/group.com.docker/settings-store.json"

            run sed --in-place= ';' "${config.home.homeDirectory}/.docker/daemon.json"
            run chmod u+w "${config.home.homeDirectory}/.docker/daemon.json"

            run sed --in-place= ';' "${config.home.homeDirectory}/.docker/config.json"
            run chmod u+w "${config.home.homeDirectory}/.docker/config.json"
          '';

          ## TODO configure credentials for work
          # security add-internet-password -a C82334 -s p-nexus-3.development.nl.eu.abnamro.com -r htps -P 18447 -l "Docker Credentials" -w 'SECRET'

          home.file.".docker/daemon.json".text = mkIf isDarwin configText;

          home.file."Library/Group Containers/group.com.docker/settings-store.json" = {
            text = lib.mkIf isDarwin (
              builtins.toJSON (
                {
                  CredentialHelper = "docker-credential-${if isDarwin then "osxkeychain" else "desktop"}";
                  DataFolder = "${config.home.homeDirectory}/Library/Containers/com.docker.docker/Data/vms/0/data";
                  DockerAppLaunchPath = "${config.home.homeDirectory}/Applications/Docker.app";
                }
                // cfg.desktopSettings
                // config.programs.docker.desktopSettings
              )
            );
          };

          xdg.configFile."docker/daemon.json" = mkIf isLinux {
            text = configText;
          };
        }
      )
    ];

    homebrew.casks = lib.optional cfg.enable "docker-desktop";
  };
}
