{
  config,
  lib,
  pkgs,
  stdenvNoCC,
  ...
}:
let
  toGuest = builtins.replaceStrings [ "darwin" ] [ "linux" ];
  baseSshKeysPath = "${config.xdg.configHome}/nix/ssh/linux-builder";
  hostSshKeysPath = "${baseSshKeysPath}/host";
  builderSshKeysPath = "${baseSshKeysPath}/builder";
  hostPrivateKeyPath = "${hostSshKeysPath}/ed25519";
  hostPublicKeyPath = "${hostPrivateKeyPath}.pub";
  builderPrivateKeyPath = "${builderSshKeysPath}/ed25519";
  builderPublicKeyPath = "${builderPrivateKeyPath}.pub";
in
lib.makeOverridable (
  {
    modules ? [ ],
  }:
  let
    # TODO review IFD and factor it out if possible
    nixos = import (pkgs.path + /nixos) {
      configuration = {
        imports = [
          (pkgs.path + /nixos/modules/virtualisation/qemu-vm.nix)

          # Avoid a dependency on stateVersion
          {
            disabledModules = [
              (pkgs.path + /nixos/modules/virtualisation/nixos-containers.nix)
              (pkgs.path + /nixos/modules/services/x11/desktop-managers/xterm.nix)
            ];
            # swraid's default depends on stateVersion
            config.boot.swraid.enable = false;
            options.boot.isContainer = lib.mkOption {
              default = false;
              internal = true;
            };
            options.boot.isNspawnContainer = lib.mkOption {
              default = false;
              internal = true;
            };
          }
          (
            { config, ... }:
            {
              boot.binfmt.emulatedSystems = lib.optional config.virtualisation.rosetta.enable "x86_64-linux";
            }
          )
          {
            # The builder is not intended to be used interactively
            documentation.enable = false;

            environment.etc = {
              "ssh/ssh_host_ed25519_key" = {
                mode = "0600";

                source = hostPrivateKeyPath;
              };

              "ssh/ssh_host_ed25519_key.pub" = {
                mode = "0644";

                source = hostPublicKeyPath;
              };
            };

            # The linux builder is a lightweight VM for remote building; not evaluation.
            nix.channel.enable = false;

            services.openssh = {
              enable = true;

              authorizedKeysFiles = [ builderPublicKeyPath ];
            };

            # Deployment is by image.
            system.disableInstallerTools = true;

            # prevents gratuitous rebuilds on each change to Nixpkgs
            system.nixos.revision = null;

            # Allow the system derivation to be substituted, so that
            # users are less likely to run into a state where they need
            # the builder running to build the builder if they just want
            # to make a tweak that only affects the macOS side of things,
            # like changing the QEMU args.
            system.systemBuilderArgs.allowSubstitutes = true;

            system.stateVersion = "25.05";

            virtualisation = {
              forwardPorts = [
                {
                  from = "host";
                  guest.port = 22;
                  host.address = "127.0.0.1";
                  host.port = config.targets.darwin.linux-builder.hostPort;
                }
              ];
              rosetta.enable = lib.mkDefault (!stdenvNoCC.isx86_64);
            };
          }
        ]
        ++ modules;

        # If you need to override this, consider starting with the right Nixpkgs
        # in the first place, ie change `pkgs` in `pkgs.darwin.linux-builder`.
        # or if you're creating new wiring that's not `pkgs`-centric, perhaps use the
        # macos-builder profile directly.
        virtualisation.host = { inherit pkgs; };

        nixpkgs.hostPlatform = lib.mkDefault (toGuest stdenvNoCC.hostPlatform.system);
      };

      system = null;
    };
    runVM = pkgs.writeShellScriptBin "run-linux-builder-vm" ''
      set -euo pipefail

      # create-builder uses TMPDIR to share files with the builder, notably certs.
      # macOS will clean up files in /tmp automatically that haven't been accessed in 3+ days.
      # If we let it use /tmp, leaving the computer asleep for 3 days makes the certs vanish.
      # So we'll use /run/org.nixos.linux-builder instead and clean it up ourselves.
      export TMPDIR=${config.xdg.cacheHome}/linux-builder USE_TMPDIR=1
      rm -rf $TMPDIR
      mkdir -p $TMPDIR
      trap "rm -rf $TMPDIR" EXIT

      export NIX_DISK_IMAGE=${config.xdg.stateHome}/linux-builder/nixos.qcow2
      mkdir -p "$(dirname "''${NIX_DISK_IMAGE}")"

      # create SSH keys if they aren't provided by the user
      ${lib.getExe' pkgs.coreutils "mkdir"} --parent '${hostSshKeysPath}' '${builderSshKeysPath}'
      if [ ! -e '${hostPrivateKeyPath}' ] || [ ! -e '${hostPublicKeyPath}' ]; then
        ${lib.getExe' pkgs.coreutils "rm"} --force -- '${hostPrivateKeyPath}' '${hostPublicKeyPath}'
        ${lib.getExe' pkgs.openssh "ssh-keygen"} -q -f '${hostPrivateKeyPath}' -t ed25519 -N "" -C 'linux-builder'
      fi
      if [ ! -e '${builderPrivateKeyPath}' ] || [ ! -e '${builderPublicKeyPath}' ]; then
        ${lib.getExe' pkgs.coreutils "rm"} --force -- '${builderPrivateKeyPath}' '${builderPublicKeyPath}'
        ${lib.getExe' pkgs.openssh "ssh-keygen"} -q -f '${builderPrivateKeyPath}' -t ed25519 -N "" -C 'builder@linux-builder'
      fi

      exec ${lib.getExe nixos.config.system.build.vm}
    '';
  in
  runVM.overrideAttrs (old: {
    meta = (old.meta or { }) // {
      platforms = lib.platforms.darwin;
    };
    passthru = (old.passthru or { }) // {
      # Let users in the repl inspect the config
      nixosConfig = nixos.config;
      nixosOptions = nixos.options;
      inherit builderPublicKeyPath builderPrivateKeyPath;
      systems = [
        (toGuest stdenvNoCC.hostPlatform.system)
      ]
      ++ lib.optional (!stdenvNoCC.isx86_64 && nixos.config.virtualisation.rosetta.enable) "x86_64-linux";
    };
  })
) { }
