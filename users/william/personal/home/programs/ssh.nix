{
  programs.ssh = {
    matchBlocks = {
      "gateway gateway.home.arpa" = {
        user = "william";
      };
    };
  };
}
