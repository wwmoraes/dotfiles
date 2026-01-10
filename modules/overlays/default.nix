let
  mkLocal =
    lib:
    lib.makeExtensible (final: {
      globalCask = name: {
        inherit name;
        args = {
          appdir = "/Applications";
        };
      };
      foldString = final.foldStringWith " ";
      foldStringWith =
        sep: str: lib.strings.concatMapStringsSep sep lib.trim (lib.splitString "\n" (lib.trim str));
      listDirRegularPaths =
        root:
        map (lib.path.append root) (
          builtins.attrNames (lib.filterAttrs (_: v: v == "regular") (builtins.readDir root))
        );
    });
in
{
  flake.overlays.default =
    final: prev:
    with prev.lib;
    foldl' (flip extends) (_: prev) [
      ## add wwmoraes maintainer
      (final: prev: {
        lib = prev.lib.extend (
          final: prev: {
            maintainers = prev.maintainers // {
              wwmoraes = {
                email = "nixpkgs@artero.dev";
                github = "wwmoraes";
                githubId = 682095;
                keys = [ { fingerprint = "32B4 330B 1B66 828E 4A96  9EEB EED9 9464 5D7C 9BDE"; } ];
                matrix = "@wwmoraes:hachyderm.io";
                name = "William Artero";
              };
            };
          }
        );
      })
      ## unleash fortune's messages
      (final: prev: {
        fortune = prev.fortune.override {
          withOffensive = true;
        };
      })
      ## helper functions
      (final: prev: {
        lib = prev.lib.extend (
          final: prev: {
            local = mkLocal final;
          }
        );
      })
    ] final;
}
