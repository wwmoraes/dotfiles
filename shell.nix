let
  ## nix-prefetch-url --unpack <url>
  pkgs = import (fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/refs/tags/24.05.tar.gz";
    sha256 = "1lr1h35prqkd1mkmzriwlpvxcb34kmhc9dnr48gkm8hh089hifmx";
  }) {};
  unstable = import (fetchTarball {
    name = "nixos-unstable-a14c5d651cee9ed70f9cd9e83f323f1e531002db";
    url = "https://github.com/NixOS/nixpkgs/archive/a14c5d651cee9ed70f9cd9e83f323f1e531002db.tar.gz";
    sha256 = "1b2dwbqm5vdr7rmxbj5ngrxm7sj5r725rqy60vnlirbbwks6aahb";
  }) {};
  kaizen = import (fetchTarball {
    name = "kaizen-8075b45edf93d8f95a00958fd3a1cc606ba3405c";
    url = "https://github.com/wwmoraes/kaizen/archive/8075b45edf93d8f95a00958fd3a1cc606ba3405c.tar.gz";
    sha256 = "1w6fkd5kqm2l2aij31kd9ddk84phbcir7flrbha6mxw2y4j36z09";
  }) { inherit pkgs; };
  inherit (pkgs) mkShell;
in mkShell {
  packages = with pkgs; [
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
    nixd
    shellcheck
    yamllint
  ] ++ (with unstable; [
    # _1password
    lazygit
  ]) ++ (with kaizen; [
    ejson
    go-commitlint
  ]);
}
