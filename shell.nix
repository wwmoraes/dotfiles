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
    pkgs.bash
    pkgs.cocogitto # cog
    pkgs.diffutils # diff
    pkgs.editorconfig-checker
    pkgs.fd
    pkgs.fzf
    pkgs.git
    pkgs.gitleaks
    pkgs.gron
    pkgs.jd-diff-patch # jd
    pkgs.jq
    pkgs.moreutils # ifne, sponge
    pkgs.omnix # om
    pkgs.remake
    pkgs.tree
    pkgs.unstable.sops
    pkgs.uutils-coreutils-noprefix
    pkgs.yq-go
    # keep-sorted end
  ];
}
