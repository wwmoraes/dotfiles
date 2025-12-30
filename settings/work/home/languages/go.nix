{
  programs.go = {
    env = {
      GOPRIVATE = [
        "https://dev.azure.com/cbsp-abnamro/*"
      ];
      GOPROXY = "https://p-nexus-3.development.nl.eu.abnamro.com:8443/repository/go-group,https://goproxy.io,direct";
      GOSUMDB = "sum.golang.org https://p-nexus-3.development.nl.eu.abnamro.com:8443/repository/go-sumdb";
    };
  };
}
