{
  flake.modules.homeManager.ai'personal = {
    programs.aichat = {
      enable = true;
      settings = {
        model = "ollama:deepseek-r1:latest";
        clients = [
          {
            type = "openai-compatible";
            name = "ollama";
            api_base = "http://localhost:11434/v1";
            models = [
              { name = "deepseek-r1:latest"; }
              { name = "mistral:7b-instruct-v0.3-q5_K_M"; }
              { name = "qwen2.5-coder:7b-instruct-q5_K_M"; }
              { name = "starcoder:7b-base-q5_K_M"; }
            ];
          }
        ];
      };
    };
  };

  flake.modules.homeManager.ai'work'disabled =
    {
      lib,
      pkgs,
      ...
    }:
    {
      home.packages = [
        pkgs.cocopilot
      ];

      programs.aichat = {
        settings = {
          stream = false;
          model = "copilot:gpt-4.1";
          clients = [
            {
              type = "openai-compatible";
              name = "copilot";
              api_base = "https://api.business.githubcopilot.com";
              patch = {
                chat_completions = {
                  ".*" = {
                    headers = {
                      "Copilot-Integration-Id" = "vscode-chat";
                      "Editor-Version" = "vscode/0.1.0";
                    };
                  };
                };
              };
            }
          ];
        };
      };

      programs.fish = {
        shellAliases = lib.mkMerge [
          {
            aichat = "env COPILOT_API_KEY=(${lib.getExe pkgs.cocopilot}) aichat";
          }
        ];
      };
    };
}
