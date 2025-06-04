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
  makeDrvManPath = lib.concatMapStringsSep ":" (p: if lib.isDerivation p then "${p}/man" else p);
  readAbsPathsFromFile =
    path:
    let
      splitLines = lib.splitString "\n";
      removeComments = lib.filter (line: line != "" && !(lib.hasPrefix "#" line));
      do = path: removeComments (splitLines (lib.readFile path));
    in
    lib.lists.optionals (lib.pathExists path) (do path);
  readAbsPathsFromDir =
    path:
    let
      inherit (builtins) readDir;
      isRegular = _: type: type == "regular";
      prefixWith = prefix: path: prefix + "/" + path;
      prefixAllWith = prefix: map (prefixWith prefix);
      listRegularFiles = attrs: lib.attrNames (lib.attrsets.filterAttrs isRegular attrs);
      readDirRegularFiles = path: prefixAllWith path (listRegularFiles (readDir path));
      do = path: lib.lists.flatten (map readAbsPathsFromFile (readDirRegularFiles path));
    in
    lib.lists.optionals (lib.pathExists path) (do path);
in
{
  meta.maintainers = [
    lib.maintainers.wwmoraes or "wwmoraes"
  ];

  options = {
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
      (mkOrder 2000 (readAbsPathsFromFile "/etc/manpaths"))
      (mkOrder 1500 (readAbsPathsFromDir "/etc/manpaths.d"))
    ];

    environment.variables = {
      MANPATH = cfg.manPath;
    };
  };
}
