{
  flake.modules.homeManager.default =
    {
      pkgs,
      ...
    }:
    {
      editorconfig.settings."*.json" = {
        indent_size = 2;
        indent_style = "space";
        tab_width = 2;
      };

      programs.helix = {
        extraPackages = [
          pkgs.vscode-json-languageserver
        ];
        languages.language-server.vscode-json-language-server = {
          args = [ "--stdio" ];
          command = "vscode-json-language-server";
          config = {
            provideFormatter = true;
            json = {
              format.enable = true;
              schemaDownload.enable = true;
              schemas = [
                {
                  fileMatch = [ "/package.json" ];
                  url = "https://json.schemastore.org/package.json";
                }
              ];
              validate.enable = true;
            };
          };
        };

        properties.languages.json.file-types = [
          "json"
          "json.gotmpl"
          "webmanifest"
          { glob = "flake.lock"; }
        ];
      };
    };
}
