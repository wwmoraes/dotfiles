{
  lib,
  ...
}:
let
  inherit (lib)
    mkMerge
    mkOrder
    ;
in
{
  environment.systemPath = mkMerge [
    # (lib.mkOrder 1100 (readPathsFromFiles (listDirRegularPaths /etc/paths.d)))
    (mkOrder 1100 [
      "/Library/Apple/usr/bin" # # rvictl
      # "/Applications/Keybase.app/Contents/SharedSupport/bin" ## TODO Keybase
      # "/Library/TeX/texbin" ## TODO tex path
    ])
    (mkOrder 1200 [ "/usr/local/sbin" ])
  ];
}
