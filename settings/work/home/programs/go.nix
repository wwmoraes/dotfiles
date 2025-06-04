{
  config,
  lib,
  ...
}:
lib.mkIf config.programs.go.enable {
  home.sessionVariables = {
    GOPROXY = "https://p-nexus-3.development.nl.eu.abnamro.com:8443/repository/go-group,https://goproxy.io,direct";
    GOSUMDB = "sum.golang.org https://p-nexus-3.development.nl.eu.abnamro.com:8443/repository/go-sumdb";
  };

  programs.go = {
    goPrivate = [
      "https://dev.azure.com/cbsp-abnamro/*"
    ];
  };
}
