let
  ## nix-prefetch-url --unpack <url>
  nixpkgs = fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/refs/tags/24.05.tar.gz";
    sha256 = "1lr1h35prqkd1mkmzriwlpvxcb34kmhc9dnr48gkm8hh089hifmx";
  };
  nixpkgs-unstable = fetchTarball {
    name = "nixos-unstable-a14c5d651cee9ed70f9cd9e83f323f1e531002db";
    # url = "https://github.com/NixOS/nixpkgs/archive/refs/heads/nixpkgs-unstable.tar.gz";
    url = "https://github.com/NixOS/nixpkgs/archive/a14c5d651cee9ed70f9cd9e83f323f1e531002db.tar.gz";
    sha256 = "1b2dwbqm5vdr7rmxbj5ngrxm7sj5r725rqy60vnlirbbwks6aahb";
  };
  pkgs = import nixpkgs {};
  unstable = import nixpkgs-unstable {};
  inherit (pkgs) mkShell;
in mkShell {
  packages = with pkgs; [
    bash
    chezmoi
    editorconfig-checker
    # ejson
    fish
    # git
    markdownlint-cli
    shellcheck
    # unstable._1password
    unstable.lazygit
    yamllint
  ];
}
