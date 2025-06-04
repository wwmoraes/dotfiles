{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkBefore mkMerge;
in
{
  home.sessionPath = mkMerge [
    (mkBefore [
      "${config.home.homeDirectory}/.local/bin"
      "${config.home.homeDirectory}/.cargo/bin"
      "${config.home.homeDirectory}/.cabal/bin"
    ])
  ];
}
