{
  lib,
  ...
}:
{
  flake.modules.darwin.default =
    _:
    {
      system.defaults.timemachine.perUser.home.SkipPaths = [
        ".dlv"
        ".go"
        "go"
      ];
    };

  flake.modules.homeManager.default =
    {
      pkgs,
      ...
    }:
    {
      editorconfig.settings = builtins.listToAttrs (
        map
          (name: {
            inherit name;
            value = {
              indent_size = "tab";
              indent_style = "tab";
              tab_width = 4;
            };
          })
          [
            "*.go"
            "go.{mod,work}"
          ]
      );

      programs = {
        fish.completions.gomod2nix.body =
          pkgs.runCommandLocal "gomod2nix-completions.fish" { }
            "${lib.getExe' pkgs.gomod2nix "gomod2nix"} completion fish > $out"
          |> builtins.getAttr "out"
          |> builtins.readFile;

        git = {
          attributes = [
            "*.gen.go merge=golang-generate"
            "*.go diff=golang"
            "go.sum merge=golang-tidy"
          ];

          settings.merge = {
            golang-generate = {
              name = "golang generate driver";
              driver = "go generate ./...";
            };
            golang-tidy = {
              name = "golang modules tidy driver";
              driver = "go mod tidy";
            };
          };
        };

        helix = {
          extraPackages = [
            pkgs.golangci-lint-langserver
            pkgs.unstable.delve
            pkgs.unstable.gopls
            # pkgs.unstable.buf-language-server
            # pkgs.unstable.gotools
          ];

          properties.languages.go = {
            auto-format = true;
            formatter = {
              command = "golangci-lint";
              args = [
                "fmt"
                "--stdin"
              ];
            };
            indent = {
              tab-width = 2;
              unit = "\t";
            };
            language-servers = [
              "gopls"
              "golangci-lint-lsp"
            ];
          };

          languages.language-server.golangci-lint-lsp = {
            command = "golangci-lint-langserver";
            config.command = [
              "golangci-lint"
              "run"
              "--output.text.path=/dev/null"
              "--output.json.path=stdout"
              "--show-stats=false"
              "--issues-exit-code=1"
            ];
          };
        };
      };
    };
}
