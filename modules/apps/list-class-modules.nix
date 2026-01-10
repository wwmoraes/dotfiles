{
  perSystem =
    {
      lib,
      pkgs,
      ...
    }:
    {
      apps.list-class-modules = {
        type = "app";
        meta.description = "lists all flake parts' modules declared per each class";
        program = pkgs.writeShellApplication {
          name = "list-flake-parts-per-class-modules";
          text = ''
            # shellcheck disable=SC2016
            nix eval --raw --extra-experimental-features pipe-operators --apply ${
              lib.escapeShellArg (
                builtins.replaceStrings [ "\n" ] [ " " ] ''
                  modules:
                  modules
                  |> builtins.mapAttrs (
                    class: classModules: (builtins.attrNames classModules |> map (name: "''${class}.''${name}"))
                  )
                  |> builtins.attrValues
                  |> builtins.concatMap (v: v)
                  |> builtins.concatStringsSep "\n"
                ''
              )
            } .#modules
          '';
        };
      };
    };
}
