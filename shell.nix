{
  pkgs,
  ...
}:
let
  inherit (pkgs) mkShell;
in
mkShell {
  packages = [
    pkgs.cocogitto
    pkgs.editorconfig-checker
    pkgs.gitleaks
    pkgs.go-task
    pkgs.gron
    pkgs.lefthook
    pkgs.markdownlint-cli
    pkgs.shellcheck
    pkgs.typos
    pkgs.unstable.sops
    pkgs.yamllint
    pkgs.yq-go
  ];
}
