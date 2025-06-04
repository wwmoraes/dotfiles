{
  pkgs,
  ...
}:
let
  yaml = pkgs.formats.yaml { };
in
{
  home.packages = [
    pkgs.aichat
  ];

  xdg.configFile."aichat/config.yaml" = {
    ## see https://github.com/sigoden/aichat/blob/main/config.example.yaml
    source = yaml.generate "aichat-config.yaml" {
      rag_embedding_model = "mxbai-embed-large:latest";
      model = "ollama:deepseek-coder:6.7b-instruct-q6_K";
      clients = [
        {
          type = "openai-compatible";
          name = "ollama";
          api_base = "http://localhost:11434/v1";
          models = [
            { name = "codegemma:7b-instruct-v1.1-q6_K"; }
            { name = "deepseek-coder:6.7b-instruct-q6_K"; }
            { name = "deepseek-r1:latest"; }
            { name = "llama2-uncensored:7b-chat-q6_K"; }
            { name = "llama3.1:8b-text-q5_K_M"; }
            { name = "mistral:7b-instruct-v0.3-q5_K_M"; }
            { name = "mxbai-embed-large:latest"; }
            { name = "nomic-embed-text:latest"; }
            { name = "qwen2.5-coder:7b-instruct-q5_K_M"; }
            { name = "qwen3:8b-q4_K_M"; }
            { name = "starcoder:7b-base-q5_K_M"; }
          ];
        }
      ];
    };
  };
}
