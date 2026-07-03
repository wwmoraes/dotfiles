{
  lib,
  self,
  ...
}:
{
  perSystem =
    {
      ...
    }:
    {
      files.file = {
        ".make/50-home.gen.mk".text = lib.mkMerge [
          (lib.mkBefore ''
            # DO-NOT-EDIT. This file was auto-generated using github:mightyiam/files.
            # Use `nix run .#write-files` to regenerate it.
          '')
          (lib.mkAfter ''
            .roots/home/%: secrets.yaml ''${NIX_SOURCES}
            	@mkdir -p $(dir $@)
            	nom build --show-trace --accept-flake-config --out-link $@ .#homeConfigurations."$(subst @,',$*)".activationPackage
            	@touch $@
          '')
          (
            builtins.attrNames self.homeConfigurations
            |> map (
              name:
              let
                parts = lib.splitString "'" name;
                username = builtins.elemAt parts 0;
                hostname = builtins.elemAt parts 1;
              in
              ''
                host/${hostname}: home/${username}@${hostname}

                .PHONY: home/${username}@${hostname}
                #: Builds the target home's activation script.
                home/${username}@${hostname}: .roots/home/${username}@${hostname}

                #: Activates configuration over SSH.
                install/${hostname}:: home/${username}@${hostname}
                install/${hostname}::
                	export DRV=$$(shell readlink -f .roots/home/${username}@${hostname}); \
                	nix-copy-closure --to ${username}@${hostname} $$(DRV); \
                	ssh ${username}@${hostname} 'nix-env --profile /nix/var/nix/profiles/per-user/${username}/home-manager --set '$$(DRV)' && '$$(DRV)/activate" --driver-version 1"
              ''
            )
            |> builtins.concatStringsSep "\n"
          )
        ];
        ".make/50-darwin.gen.mk".text = lib.mkMerge [
          (lib.mkBefore ''
            # DO-NOT-EDIT. This file was auto-generated using github:mightyiam/files.
            # Use `nix run .#write-files` to regenerate it.
          '')
          (lib.mkAfter ''
            .roots/darwin/%: secrets.yaml ''${NIX_SOURCES}
            	@mkdir -p $(dir $@)
            	nom build --show-trace --accept-flake-config --out-link $@ .#darwinConfigurations.$*.config.system.build.toplevel
            	@touch $@
          '')
          (
            builtins.attrNames self.darwinConfigurations
            |> map (name: ''
              all: host/${name}

              .PHONY: host/${name}
              #: Builds host's nix-darwin activation script.
              host/${name}: .roots/darwin/${name}
            '')
            |> builtins.concatStringsSep "\n"
          )
        ];
        ".make/50-nixos.gen.mk".text = lib.mkMerge [
          (lib.mkBefore ''
            # DO-NOT-EDIT. This file was auto-generated using github:mightyiam/files.
            # Use `nix run .#write-files` to regenerate it.
          '')
          (lib.mkAfter ''
            .roots/nixos/%: secrets.yaml $(NIX_SOURCES)
            	@mkdir -p $(dir $@)
            	nom build --show-trace --accept-flake-config --out-link $@ .#nixosConfigurations.$*.config.system.build.toplevel
            	@touch $@
          '')
          (
            builtins.attrNames self.nixosConfigurations
            |> map (name: ''
              all: host/${name}

              .PHONY: host/${name}
              #: Builds host's NixOS activation script.
              host/${name}: .roots/nixos/${name}
            '')
            |> builtins.concatStringsSep "\n"
          )
          (
            self.nixosConfigurations
            |> builtins.mapAttrs (
              name: host: ''
                .PHONY: vm/${name}
                #: Builds host's VM activation script.
                vm/${name}: .roots/vm/${name}

                .roots/vm/${name}: secrets.yaml $(NIX_SOURCES)
                	@mkdir -p $(dir $@)
                	nom build --show-trace --accept-flake-config --out-link $@ .#legacyPackages.${host.pkgs.stdenv.hostPlatform.system}.${name}-image
                	@touch $@
              ''
            )
            |> builtins.attrValues
            |> builtins.concatStringsSep "\n"
          )
        ];
        ".make/80-install.gen.mk".text = lib.mkMerge [
          (lib.mkBefore ''
            # DO-NOT-EDIT. This file was auto-generated using github:mightyiam/files.
            # Use `nix run .#write-files` to regenerate it.
          '')

          (
            self.nixosConfigurations
            |> builtins.mapAttrs (
              name: host: ''
                .PHONY: install/${name}
                #: Activates configuration over SSH.
                install/${name}::
                	nix run nixpkgs#nixos-rebuild -- switch --build-host root@${host.config.networking.fqdn} --fast --flake .#${name} --target-host root@${host.config.networking.fqdn}
              ''
            )
            |> builtins.attrValues
            |> builtins.concatStringsSep "\n"
          )
        ];
      };
    };
}
