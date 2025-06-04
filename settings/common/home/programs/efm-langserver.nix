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
      root-markers = [
        ".git"
      ];
      lint-debounce = "1s";
      tools = {
        golangci-lint = {
          lint-command = "golangci-lint run";
          lint-stdin = true;
          lint-workspace = true;
          format-stdin = true;
          root-markers = [
            ".golangci.yaml"
          ];
        };
      };
      languages = {
        go = [
          tools.golangci-lint
        ];
      };
    };
  };
}
