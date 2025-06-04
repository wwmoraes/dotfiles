{
  lib,
  ...
}:
let
  listPEMs =
    root:
    map (lib.path.append root) (
      builtins.attrNames (
        lib.filterAttrs (k: v: lib.hasSuffix ".pem" k && v == "regular") (builtins.readDir root)
      )
    );
in
{
  security.pki = {
    certificateFiles = lib.mkMerge [
      (listPEMs ./certificates)
    ];
  };
}
