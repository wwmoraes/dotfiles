{ lib, ... }:
{
  flake.modules.darwin.default = {
    home-manager.sharedModules = [
      (
        { config, ... }:
        {
          config = lib.mkIf config.services.ollama.enable {
            launchd.agents.ollama = {
              config = {
                Label = "com.ollama.ollama";
                RunAtLoad = false;
                Sockets.Listeners = {
                  SockNodeName = config.services.ollama.host;
                  SockPassive = false;
                  SockServiceName = toString config.services.ollama.port;
                };
                StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/${config.launchd.agents.ollama.config.Label}.err.log";
                StandardOutPath = "${config.home.homeDirectory}/Library/Logs/${config.launchd.agents.ollama.config.Label}.out.log";
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
