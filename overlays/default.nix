{
  default =
    final: prev:
    with prev.lib;
    foldl' (flip extends) (_: prev) [
      ## add wwmoraes maintainer
      (
        final: prev:
        prev.lib.recursiveUpdate prev {
          lib.maintainers.wwmoraes = {
            email = "nixpkgs@artero.dev";
            github = "wwmoraes";
            githubId = 682095;
            keys = [ { fingerprint = "32B4 330B 1B66 828E 4A96  9EEB EED9 9464 5D7C 9BDE"; } ];
            matrix = "@wwmoraes:hachyderm.io";
            name = "William Artero";
          };
        }
      )
      ## unleash fortune's messages
      (final: prev: {
        fortune = prev.fortune.override {
          withOffensive = true;
        };
      })
      ## helper functions
      (
        final: prev:
        prev.lib.recursiveUpdate prev {
          lib.local = rec {
            globalCask = name: {
              inherit name;
              args = {
                appdir = "/Applications";
              };
            };
            unindent =
              str:
              let
                indent = builtins.head (builtins.match "^[\n]*([[:space:]]*).*" str);
              in
              if indent == "" then
                str
              else
                (prev.lib.concatLines (
                  map (prev.lib.removePrefix indent) (prev.lib.splitString "\n" (prev.lib.trim str))
                ));
            unindentTrim = str: unindent (prev.lib.removePrefix "\n" (prev.lib.removeSuffix "\n" str));
            foldString = foldStringWith " ";
            foldStringWith =
              sep: str:
              prev.lib.strings.concatMapStringsSep sep prev.lib.trim (
                prev.lib.splitString "\n" (prev.lib.trim str)
              );
            # listModules = root: map
            #   (prev.lib.path.append root)
            #   (prev.lib.attrNames (prev.lib.filterAttrs (name: type: type == "directory" || (type == "regular" && name != "default.nix" && prev.lib.hasSuffix ".nix" name)) (builtins.readDir root)));
            # listDirRegularPaths = root: map (lib.path.append root) (builtins.attrNames (lib.filterAttrs (_: v: v == "regular") (builtins.readDir root)));
            # readPathsFromFiles = files: lib.flatten (map readPathsFromFile files);
            # readPathsFromFile = f: filter pathExists (map (p: /. + p) (filter (v: v != "") (lib.splitString "\n" (readFile f))));
          };
        }
      )
    ] final;
}
