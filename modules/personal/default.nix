{
  flake.modules.generic.personal = {
    time.timeZone = "Europe/Amsterdam";
  };

  flake.modules.darwin.personal = {
    system.primaryUser = "william";
  };

  flake.modules.homeManager.personal =
    {
      config,
      lib,
      ...
    }:
    {
      programs.ssh = {
        matchBlocks = {
          "gateway gateway.home.arpa" = {
            user = lib.mkDefault config.home.username;
          };
        };
      };
    };
}
