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

  ## TODO set COPILOT_API_KEY, see https://github.com/sigoden/aichat/issues/1030
  xdg.configFile."aichat/config.yaml" = {
    ## see https://github.com/sigoden/aichat/blob/main/config.example.yaml
    source = yaml.generate "aichat-config.yaml" {
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
}
