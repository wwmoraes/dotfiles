{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.git = {
    attributes = [
      "*.gen.go merge=golang-generate"
      "*.go diff=golang"
      "go.sum merge=golang-tidy"
    ];
    extraConfig.merge = {
      golang-generate = {
        name = "golang generate driver";
        driver = "go generate ./...";
      };
      golang-tidy = {
        name = "golang modules tidy driver";
        driver = "go mod tidy";
      };
    };
  };

  programs.go = {
    enable = true;
    goBin = ".go/bin";
    goPath = ".go";
  };

  home.sessionVariables = lib.mkIf config.programs.go.enable {
    CGO_ENABLED = "0";
  };

  programs.helix.extraPackages = lib.mkIf config.programs.go.enable [
    pkgs.unstable.delve
    pkgs.unstable.gopls
    # pkgs.unstable.gotools
  ];

  home.sessionPath = lib.mkIf (config.programs.go.enable && config.programs.go.goBin != null) [
    "${config.home.homeDirectory}/${config.programs.go.goBin}"
  ];
}
