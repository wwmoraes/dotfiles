{
  programs.helix = {
    languages = {
      language-server = {
        vscode-json-language-server.config.json = {
          schemas = [
            {
              fileMatch = [
                "*.azure-pipelines.yaml"
                "*.azure-pipelines.yml"
                "azure-pipelines.yaml"
                "azure-pipelines.yml"
              ];
              url = "https://raw.githubusercontent.com/microsoft/azure-pipelines-vscode/master/service-schema.json";
            }
          ];
        };
      };
    };
  };
}
