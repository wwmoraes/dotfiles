{
  lib,
  self,
  ...
}:
{
  perSystem = {
    files.file = {
      ".make/50-nixos.gen.mk".text = lib.mkMerge [
        (lib.mkBefore ''
          # DO-NOT-EDIT. This file was auto-generated using github:mightyiam/files.
          # Use `nix run .#write-files` to regenerate it.
        '')
        (lib.mkAfter ''
          .roots/nixos/%: secrets.yaml $(NIX_SOURCES)
          	@mkdir -p $(dir $@)
          	nom build --show-trace --accept-flake-config --out-link $@ .#nixosConfigurations.$*.config.system.build.toplevel
          	@touch -h $@
        '')
        (
          self.nixosConfigurations
          |> builtins.mapAttrs (
            name: host: ''
              .PHONY: install/${name}
              #: Activates configuration over SSH.
              install/${name}::
              	nix run nixpkgs#nixos-rebuild -- switch --build-host root@${host.config.networking.fqdn} --no-reexec --flake .#${name} --target-host root@${host.config.networking.fqdn}

              all: host/${name}

              .roots/${name}: .roots/nixos/${name}
              	ln -sf $(realpath $<) $@

              .PHONY: host/${name}
              #: Builds host's NixOS activation script.
              host/${name}: .roots/nixos/${name}

              .PHONY: vm/${name}
              #: Builds host's VM activation script.
              vm/${name}: .roots/vm/${name}

              .roots/vm/${name}: secrets.yaml $(NIX_SOURCES)
              	@mkdir -p $(dir $@)
              	nom build --show-trace --accept-flake-config --out-link $@ .#legacyPackages.${host.pkgs.stdenv.hostPlatform.system}.${name}-image
              	@touch -h $@
            ''
          )
          |> builtins.attrValues
          |> builtins.concatStringsSep "\n"
        )
      ];
    };
  };
}
