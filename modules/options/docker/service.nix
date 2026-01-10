{
  lib,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    types
    ;
in
{
  flake.modules.generic.default =
    {
      pkgs,
      ...
    }:
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
        };
      };
    };

  flake.modules.nixos.default =
    {
      config,
      ...
    }:
    let
      cfg = config.services.docker;
      configText = lib.generators.toJSON { } cfg.settings;
    in
    {
      config = mkIf cfg.enable {
        ## TODO move rootless docker configuration to virtualisation group
        ## https://github.com/NixOS/nixpkgs/blob/nixos-25.05/nixos/modules/virtualisation/docker-rootless.nix
        environment.etc."docker/daemon.json".text = configText;

        environment.systemPackages = cfg.package;
      };
    };

  flake.modules.darwin.default =
    {
      config,
      ...
    }:
    let
      cfg = config.services.docker;
      configText = lib.generators.toJSON { } cfg.settings;
    in
    {
      options = {
        services.docker = {
          desktopSettings = mkOption {
            default = { };
            type = with types; attrsOf anything;
          };
        };
      };
      config = {
        home-manager.sharedModules = [
          {
            options.programs.docker = {
              desktopSettings = mkOption {
                default = { };
                type = with types; attrsOf anything;
              };
            };
          }
          (
            {
              config,
              lib,
              ...
            }:
            mkIf cfg.enable {
              home.activation.unlinkDockerDesktop = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
                ## replaces links with file copy otherwise Docker Desktop fails to start...

                run sed --in-place= ';' "${config.home.homeDirectory}/Library/Group Containers/group.com.docker/settings-store.json"
                run chmod u+w "${config.home.homeDirectory}/Library/Group Containers/group.com.docker/settings-store.json"

                run sed --in-place= ';' "${config.home.homeDirectory}/.docker/daemon.json"
                run chmod u+w "${config.home.homeDirectory}/.docker/daemon.json"

                run sed --in-place= ';' "${config.home.homeDirectory}/.docker/config.json"
                run chmod u+w "${config.home.homeDirectory}/.docker/config.json"
              '';

              home.file.".docker/daemon.json" = {
                text = configText;
              };

              home.file."Library/Group Containers/group.com.docker/settings-store.json" = {
                text = builtins.toJSON (
                  {
                    CredentialHelper = "docker-credential-osxkeychain";
                    DataFolder = "${config.home.homeDirectory}/Library/Containers/com.docker.docker/Data/vms/0/data";
                    DockerAppLaunchPath = "${config.home.homeDirectory}/Applications/Docker.app";
                  }
                  // cfg.desktopSettings
                  // config.programs.docker.desktopSettings
                );
              };
            }
          )
        ];

        homebrew.casks = lib.optional cfg.enable "docker-desktop";
      };
    };
}
