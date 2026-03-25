{
  lib,
  ...
}:
{
  flake.modules.homeManager.ai'personal =
    {
      pkgs,
      ...
    }:
    {
      programs.crush = {
        enable = true;
        settings = {
          lsp = {
            go = {
              command = lib.getExe pkgs.unstable.gopls;
              # env = {
              #   "GOTOOLCHAIN" = "go1.24.5";
              # };
            };
            typescript = {
              command = lib.getExe pkgs.unstable.typescript-language-server;
              args = [ "--stdio" ];
            };
            nil.command = lib.getExe pkgs.unstable.nil;
            nixd.command = lib.getExe pkgs.unstable.nixd;
          };
          options = {
            disable_provider_auto_update = true;
            disabled_tools = [
              "bash"
              "fish"
              "sh"
            ];
          };
          providers.ollama = {
            name = "Ollama";
            base_url = "http://localhost:11434/v1/";
            type = "openai-compat";
            models = [
              {
                name = "DeepSeek R1";
                id = "deepseek-r1:latest";
                context_window = 128000;
                default_max_tokens = 8192;
              }
              {
                name = "Mistral 7B";
                id = "mistral:7b-instruct-v0.3-q5_K_M";
                context_window = 32000;
                default_max_tokens = 8192;
              }
              {
                name = "Qwen Coder 2.5 7B";
                id = "qwen2.5-coder:7b-instruct-q5_K_M";
                context_window = 32000;
                default_max_tokens = 8192;
              }
              {
                name = "Qwen 3.5 4B";
                id = "qwen3.5:4b";
                context_window = 256000;
                default_max_tokens = 8192;
              }
              {
                name = "StarCoder 7B";
                id = "starcoder:7b-base-q5_K_M";
                context_window = 8000;
                default_max_tokens = 8192;
              }
              {
                name = "StarCoder2 15B";
                id = "starcoder2:15b-q4_K_M";
                context_window = 16000;
                default_max_tokens = 8192;
              }
              {
                name = "GLM 4.7 30B";
                id = "glm-4.7-flash:q4_K_M";
                context_window = 198000;
                default_max_tokens = 8192;
              }
            ];
          };
        };
      };
    };
}
