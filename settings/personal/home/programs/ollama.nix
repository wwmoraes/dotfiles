{
  config,
  lib,
  pkgs,
  ...
}:
{
  home.packages = [
    pkgs.ollama
  ];

  launchd.agents = {
    ollama = {
      enable = true;
      config = {
        EnvironmentVariables = {
          OLLAMA_FLASH_ATTENTION = "1";
          OLLAMA_HOST = "127.0.0.1:11434";
          OLLAMA_KEEP_ALIVE = "5m";
          OLLAMA_KV_CACHE_TYPE = "q8_0";
        };
        KeepAlive = false;
        Label = "dev.artero.ollama";
        ProcessType = "Adaptive";
        ProgramArguments = [
          "${lib.getExe pkgs.ollama}"
          "serve"
        ];
        RunAtLoad = false;
        Sockets.Listeners = {
          SockNodeName = "127.0.0.1";
          SockPassive = false;
          SockServiceName = "11434";
        };
        StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/dev.artero.ollama.err.log";
        StandardOutPath = "${config.home.homeDirectory}/Library/Logs/dev.artero.ollama.out.log";
      };
    };
  };
}
