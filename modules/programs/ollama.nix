{
  flake.modules.darwin.ai'personal =
    {
      config,
      ...
    }:
    let
      inherit (config.homebrew) prefix;
    in
    {
      homebrew.casks = [
        "ollama-app"
      ];

      home-manager.sharedModules = [
        (
          {
            config,
            ...
          }:
          {
            ## NOTE this package cannot be built in a sandbox + has missing files ("pattern app/dist: no matching files found")
            # home.packages = [
            #   pkgs.ollama
            # ];

            launchd.agents = {
              ollama = {
                enable = true;
                config = rec {
                  EnvironmentVariables = {
                    OLLAMA_FLASH_ATTENTION = "1";
                    OLLAMA_HOST = "127.0.0.1:11434";
                    OLLAMA_KEEP_ALIVE = "5m";
                    OLLAMA_KV_CACHE_TYPE = "q8_0";
                  };
                  KeepAlive = {
                    SuccessfulExit = false;
                    Crashed = true;
                  };
                  Label = "com.ollama.ollama";
                  ProcessType = "Adaptive";
                  ProgramArguments = [
                    "${prefix}/ollama"
                    "serve"
                  ];
                  RunAtLoad = false;
                  Sockets.Listeners = {
                    SockNodeName = "127.0.0.1";
                    SockPassive = false;
                    SockServiceName = "11434";
                  };
                  StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/${Label}.err.log";
                  StandardOutPath = "${config.home.homeDirectory}/Library/Logs/${Label}.out.log";
                };
              };
            };
          }
        )
      ];

      system.defaults.timemachine.perUser.home.SkipPaths = [
        ".ollama"
      ];
    };
}
