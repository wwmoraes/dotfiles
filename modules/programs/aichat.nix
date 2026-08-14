{
  flake.modules.homeManager.personal = {
    programs.aichat.settings = {
      model = "ollama:deepseek-r1:latest";
      clients = [
        {
          type = "openai-compatible";
          name = "ollama";
          api_base = "http://localhost:11434/v1";
          models = map (name: { inherit name; }) [
            "deepseek-r1:latest"
            "mistral:7b-instruct-v0.3-q5_K_M"
            "qwen2.5-coder:7b-instruct-q5_K_M"
            "starcoder:7b-base-q5_K_M"
          ];
        }
      ];
    };
  };

  flake.modules.homeManager.work =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf config.programs.aichat.enable {
        home.packages = [
          pkgs.cocopilot
        ];

        programs.aichat.settings = {
          stream = false;
          model = "copilot:gpt-4.1";
          clients = [
            {
              type = "openai-compatible";
              name = "copilot";
              api_base = "https://api.business.githubcopilot.com";
              patch.chat_completions.".*".headers = {
                "Copilot-Integration-Id" = "vscode-chat";
                "Editor-Version" = "vscode/0.1.0";
              };
            }
          ];
        };

        programs.fish.shellAliases.aichat = "env COPILOT_API_KEY=(${lib.getExe pkgs.cocopilot}) aichat";
      };
    };
}
