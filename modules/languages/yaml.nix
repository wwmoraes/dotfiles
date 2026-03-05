{
  flake.modules.homeManager.default =
    {
      pkgs,
      ...
    }:
    {
      editorconfig.settings."*.{yaml,yml}" = {
        indent_size = 2;
        indent_style = "space";
        tab_width = 2;
      };

      programs.helix = {
        extraPackages = [
          pkgs.unstable.yaml-language-server
        ];

        languages.language-server.yaml-language-server = {
          args = [ "--stdio" ];
          command = "yaml-language-server";
          config = {
            # provideFormatter = true;
            yaml = {
              format.enable = true;
              schemas = {
                # kubernetes = "/*.yaml"
                # "https://json.schemastore.org/github-action.json" = "/.github/**/actions.yml"
                "https://json.schemastore.org/github-workflow.json" = "/.github/workflows/*.{yml,yaml}";
              };
              schemaStore.url = "https://json.schemastore.org/package.json";
            };
          };
        };

        properties.languages.yaml.file-types = [
          "yaml"
          "yaml.gotmpl"
          "yml"
          "yml.gotmpl"
        ];
      };
    };
}
