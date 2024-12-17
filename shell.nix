{ system ? builtins.currentSystem
, sources ? import ./nix/sources.nix
}: let
  pkgs = import sources.nixpkgs {
    inherit system;
    config.packageOverrides = pkgs: {
      nur = import sources.NUR { inherit pkgs; };
      unstable = import sources.unstable { inherit system pkgs; };
    };
  };
  inherit (pkgs) mkShell;
in mkShell {
  packages = (with pkgs; [
    bash
    chezmoi
    editorconfig-checker
    fish
    git
    go-task
    gron
    jq
    lefthook
    markdownlint-cli
    nur.repos.wwmoraes.ejson
    nur.repos.wwmoraes.go-commitlint
    shellcheck
    unstable.lazygit
    yamllint
  ]);
}
