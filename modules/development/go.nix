{
  flake.modules.homeManager.development =
    {
      config,
      ...
    }:
    {
      home.sessionPath = [
        config.programs.go.env.GOBIN
      ];

      programs.go = {
        env = {
          CGO_ENABLED = "0";
          GOBIN = "${config.home.homeDirectory}/.go/bin";
          GOPATH = "${config.home.homeDirectory}/.go";
        };
      };
    };
}
