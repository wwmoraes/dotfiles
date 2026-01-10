{
  perSystem =
    {
      lib,
      pkgs,
      ...
    }:
    {
      apps.list-modules = {
        type = "app";
        meta.description = "lists all flake parts' modules declared without classes";
        program = pkgs.writeShellApplication {
          name = "list-flake-parts-modules";
          text = ''
            # shellcheck disable=SC2016
            nix eval --raw --extra-experimental-features pipe-operators --apply ${
              lib.escapeShellArg (
                builtins.replaceStrings [ "\n" ] [ " " ] ''
                  modules:
                  modules
                  |> builtins.mapAttrs (_: classModules: builtins.attrNames classModules)
                  |> builtins.attrValues
                  |> builtins.concatMap (v: v)
                  |> builtins.foldl' (attrs: v: attrs // { "''${v}" = null; }) { }
                  |> builtins.attrNames
                  |> builtins.concatStringsSep "\n"
                ''
              )
            } .#modules
          '';
        };
      };
    };
}
