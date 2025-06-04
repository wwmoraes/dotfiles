{
  config,
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
  cfg = config.environment;
  makeDrvInfoPath = lib.concatMapStringsSep ":" (p: if lib.isDerivation p then "${p}/info" else p);
in
{
  meta.maintainers = [
    lib.maintainers.wwmoraes or "wwmoraes"
  ];

  options = {
    environment.infoPath = mkOption {
      type = with types; listOf (either path str);
      default = [ ];
      example = [ "$HOME/.local/share/info" ];
      description = "The set of paths that are added to INFOPATH.";
      apply = x: if lib.isList x then makeDrvInfoPath x else x;
    };
  };
  config = {
    environment.infoPath = mkMerge [
      (mkBefore (map (s: s + "/share/info") cfg.profiles))
      (mkOrder 2000 [
        "/usr/share/info"
        "/usr/local/share/info"
      ])
    ];

    environment.variables = {
      INFOPATH = cfg.infoPath;
    };
  };
}
