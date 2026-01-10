{
  lib,
  ...
}:
let
  inherit (lib)
    mkBefore
    mkMerge
    mkOption
    mkOrder
    types
    ;
  makeDrvManPath = lib.concatMapStringsSep ":" (p: if lib.isDerivation p then "${p}/man" else p);
in
{
  flake.modules.darwin.default =
    {
      config,
      ...
    }:
    let
      cfg = config.environment;
    in
    {
      meta.maintainers = [
        lib.maintainers.wwmoraes or "wwmoraes"
      ];

      options = {
        # TODO documentation.man.mandoc.manPath
        environment.manPath = mkOption {
          type = with types; listOf (either path str);
          default = [ ];
          example = [ "$HOME/.local/share/man" ];
          description = "The set of paths that are added to MANPATH.";
          apply = x: if lib.isList x then makeDrvManPath x else x;
        };
      };

      config = {
        environment.manPath = mkMerge [
          (mkBefore (map (s: s + "/share/man") cfg.profiles))
          (mkOrder 2000 [
            "/usr/local/share/man"
            "/usr/share/man"
          ])
        ];

        environment.variables = {
          MANPATH = cfg.manPath;
        };
      };
    };
}
