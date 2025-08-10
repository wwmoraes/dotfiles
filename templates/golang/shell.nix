{
  pkgs,
  ...
}:
let
  goEnv = pkgs.mkGoEnv { pwd = ./.; };
in
rec {
  default = pkgs.mkShell {
    nativeBuildInputs = [
      # keep-sorted start
      goEnv
      pkgs.cocogitto
      pkgs.goreleaser
      pkgs.unstable.go
      # keep-sorted end
    ];
  };

  ci = default.overrideAttrs (
    final: prev: {
      nativeBuildInputs = [
        # keep-sorted start
        pkgs.go-junit-report
        pkgs.nur.repos.wwmoraes.codecov-cli-bin
        # keep-sorted end
      ] ++ prev.nativeBuildInputs;

      shellHook = ''
        export GOCACHE=$(go env GOCACHE)
        export GOMODCACHE=$(go env GOMODCACHE)
      '';
    }
  );

  terminal = default.overrideAttrs (
    final: prev: {
      nativeBuildInputs = [
        # keep-sorted start
        pkgs.gomod2nix
        pkgs.gotestdox
        pkgs.nix-update
        pkgs.unstable.golangci-lint
        pkgs.unstable.gotests
        pkgs.unstable.gotools
        # keep-sorted end
      ] ++ prev.nativeBuildInputs;

      shellHook = ''
        cog install-hook --all --overwrite
      '';
    }
  );
}
