let
  ## nix-prefetch-url --unpack <url>
  nixpkgs = fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/refs/tags/24.05.tar.gz";
    sha256 = "1lr1h35prqkd1mkmzriwlpvxcb34kmhc9dnr48gkm8hh089hifmx";
  };
  pkgs = import nixpkgs {};
  nixpkgs-unstable = fetchTarball {
    name = "nixos-unstable-a14c5d651cee9ed70f9cd9e83f323f1e531002db";
    # url = "https://github.com/NixOS/nixpkgs/archive/refs/heads/nixpkgs-unstable.tar.gz";
    url = "https://github.com/NixOS/nixpkgs/archive/a14c5d651cee9ed70f9cd9e83f323f1e531002db.tar.gz";
    sha256 = "1b2dwbqm5vdr7rmxbj5ngrxm7sj5r725rqy60vnlirbbwks6aahb";
  };
  unstable = import nixpkgs-unstable {};
  kaizen-src = fetchTarball {
    name = "kaizen-2dc5f25534649dcf7450fd8ea45413f7d7f92866";
    url = "https://github.com/wwmoraes/kaizen/archive/2dc5f25534649dcf7450fd8ea45413f7d7f92866.tar.gz";
    sha256 = "07cc53yqpsilc6mvb2jxgbjb80dafnl7n0my5wswg706rspimvr2";
  };
  kaizen = import kaizen-src { inherit pkgs; };
  inherit (pkgs) mkShell;
in mkShell {
  packages = with pkgs; [
    # unstable._1password
    bash
    chezmoi
    editorconfig-checker
    fish
    git
    kaizen.ejson
    kaizen.go-commitlint
    markdownlint-cli
    shellcheck
    unstable.lazygit
    yamllint
  ];
}
