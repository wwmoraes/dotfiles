{
  flake.modules.darwin.william = {
    services = {
      docker.enable = false;
    };
  };

  flake.modules.homeManager.william = {
    services = {
      ollama.enable = true;
      tldr-update.enable = true;
    };
  };
}
