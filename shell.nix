{
  pkgs,
  ...
}:
let
  inherit (pkgs) mkShell;
in
mkShell {
  packages = [
    # keep-sorted start
    pkgs.cocogitto
    pkgs.editorconfig-checker
    pkgs.gitleaks
    pkgs.gnumake
    pkgs.gron
    pkgs.omnix
    pkgs.unstable.sops
    pkgs.yq-go
    # keep-sorted end
  ];
}
