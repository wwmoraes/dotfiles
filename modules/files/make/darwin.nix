{
  lib,
  self,
  ...
}:
{
  perSystem = {
    files.file = {
      ".make/50-darwin.gen.mk".text = lib.mkMerge [
        (lib.mkBefore ''
          # DO-NOT-EDIT. This file was auto-generated using github:mightyiam/files.
          # Use `nix run .#write-files` to regenerate it.
        '')
        (lib.mkAfter ''
          .roots/darwin/%: secrets.yaml ''${NIX_SOURCES}
          	@mkdir -p $(dir $@)
          	nom build --show-trace --accept-flake-config --out-link $@ .#darwinConfigurations.$*.config.system.build.toplevel
          	@touch -h $@
        '')
        (
          builtins.attrNames self.darwinConfigurations
          |> map (name: ''
            all: host/${name}

            .roots/${name}: .roots/darwin/${name}
            	ln -sf $(realpath $<) $@

            .PHONY: host/${name}
            #: Builds host's Darwin activation script.
            host/${name}: .roots/darwin/${name}
          '')
          |> builtins.concatStringsSep "\n"
        )
      ];
    };
  };
}
