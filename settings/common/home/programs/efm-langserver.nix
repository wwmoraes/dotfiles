{
  pkgs,
  ...
}:
let
  format = pkgs.formats.yaml { };
in
{
  xdg.configFile."efm-langserver/config.yaml" = {
    ## https://raw.githubusercontent.com/mattn/efm-langserver/refs/heads/master/schema.json
    source = format.generate "efm-langserver-config.yaml" rec {
      version = 2;
      format-debound = "3s";
      languages = {
        go = [
          tools.golangci-lint
        ];
      };
      lint-debounce = "3s";
      root-markers = [
        ".git"
      ];
      tools = {
        golangci-lint = {
          format-command = "golangci-lint run --fix";
          format-stdin = true;
          lint-command = "golangci-lint run";
          lint-stdin = true;
          lint-on-save = true;
          lint-source = "golangci-lint";
          lint-workspace = true;
          root-markers = [
            ".golangci.yaml"
            "go.mod"
          ];
        };
      };
    };
  };
}
