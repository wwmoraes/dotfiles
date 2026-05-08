{
  self,
  ...
}:
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
      wrapText =
        {
          prefix ? "", # line comment prefix; also applies on block to indent lines
          start ? "", # block comment start
          end ? "", # block comment end
          text,
        }:
        let
          lines = builtins.filter builtins.isString (builtins.split "\n" text);
          prepend = prefix: lines: map (line: "${prefix}${line}") lines;
          optional = str: lib.optional (str != "") str;
        in
        builtins.concatStringsSep "\n" ((optional start) ++ (prepend prefix lines) ++ (optional end));
    });
in
{
  flake.overlays.local =
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

  flake.modules.generic.default = {
    nixpkgs.overlays = [
      self.overlays.local
    ];
  };
}
