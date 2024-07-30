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
  pkgs = import nixpkgs {
    config = {
      packageOverrides = pkgs: {
        unstable = import nixpkgs-unstable {};
      };
    };

    overlays = [];
  };
  inherit (pkgs) mkShell;
in mkShell {
  packages = with pkgs; [
    ## TODO nix-daemon
    # skhd

    ## globals
    # cfssl
    # checkmake
    # dmarc-report-converter
    # docker-client
    # doctl
    # editorconfig-checker
    # ejson
    # fd
    # flyctl
    # gcc
    # gh
    # go-task
    # graphviz
    # gron
    # grpcurl
    # grype
    # hadolint
    # haskellPackages.ghcup
    # hlint
    # hub
    # imagemagick
    # imapfilter
    # inetutils
    # lefthook
    # lua54Packages.lua
    # lua54Packages.luarocks
    # markdownlint-cli
    # mimir
    # mosh
    # natscli
    # nodePackages.lerna
    # pipenv
    # plantuml-c4
    # pulumi-bin
    # qpdf
    # redis
    # reviewdog
    # shellcheck
    # skopeo
    # sloth
    # socat
    # syft
    # tree
    # trivy
    # typos
    # unixtools.watch
    # unstable.container-structure-test
    # unzip
    # vale
    # watchman
    # yamllint
    # yq-go
    # ytt
    # yubico-piv-tool
    # yubikey-manager
    # yubikey-personalization

    ## Haskell projects
    # stack
    # stylish-haskell

    ## Node projects
    # nodejs-slim

    ## Golang projects
    # air
    # gnostic
    # go
    # gofumpt
    # golangci-lint
    # gomarkdoc
    # goreleaser
    # grpc-gateway
    # impl
    # oapi-codegen
    # protoc-gen-doc
    # protoc-gen-go
    # protoc-gen-go-grpc
    # tinygo
    # wire

    ## Rust projects
    # cargo-watch
    # rustup # (contains cargo, rustc, rustfmt, clippy, rust-analyzer)

    # bat
    # coreutils
    # delta
    # dive
    # git
    # gnupg
    # moreutils
    # powerline-go
    # unstable._1password

    unstable.lazygit
  ];
}
