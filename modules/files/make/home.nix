{
  lib,
  self,
  ...
}:
{
  perSystem = {
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
          	@touch -h $@
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

              .roots/${username}@${hostname}: .roots/home/${username}@${hostname}
              	ln -sf $(realpath $<) $@

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
    };
  };
}
