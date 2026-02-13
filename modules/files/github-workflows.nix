{
  config,
  ...
}:
{
  perSystem =
    {
      pkgs,
      ...
    }:
    let
      withHeaderText =
        file:
        pkgs.concatTextFile {
          name = "generated-${file.name}";
          files = [
            (pkgs.writeTextFile {
              name = "header-text";
              text = ''
                # yaml-language-server: $schema=https://www.schemastore.org/github-workflow.json
                # DO-NOT-EDIT. This file was auto-generated using github:mightyiam/files.
                # Use `nix run .#write-files` to regenerate it.
              '';
            })
            file
          ];
        };
      generateYAML = name: content: withHeaderText (pkgs.writers.writeYAML name content);
    in
    {
      files.files = [
        {
          path_ = ".github/workflows/integration.yml";
          drv = generateYAML "github-integration-workflow.yaml" {
            name = "Integration";
            on.push.branches = [
              "master"
              "trunk"
            ];
            jobs.integrate = {
              strategy = {
                fail-fast = true;
                matrix = {
                  system = config.systems;
                  include = [
                    {
                      system = "aarch64-darwin";
                      os = "macos-latest";
                    }
                    {
                      system = "aarch64-linux";
                      os = "ubuntu-24.04-arm";
                    }
                    {
                      system = "x86_64-linux";
                      os = "ubuntu-latest";
                    }
                  ];
                };
              };
              runs-on = ''''${{ matrix.os }}'';
              name = ''''${{ matrix.system }}'';
              steps = [
                {
                  name = "checkout";
                  uses = "actions/checkout@v4";
                }
                {
                  name = "setup";
                  uses = "JRMurr/direnv-nix-action@v4.2.0";
                  "with" = {
                    install-nix = true;
                    cache-store = true;
                  };
                }
                {
                  name = "lock";
                  run = "nix flake lock --no-update-lock-file";
                }
                {
                  name = "build";
                  run = builtins.concatStringsSep " " [
                    "om ci run"
                    "--extra-experimental-features flakes"
                    "--extra-experimental-features nix-command"
                    "--extra-experimental-features pipe-operators"
                    "--no-link"
                    "."
                    "--"
                    "--accept-flake-config"
                    # "--print-build-logs"
                  ];
                }
              ];
            };
          };
        }
      ];
    };
}
