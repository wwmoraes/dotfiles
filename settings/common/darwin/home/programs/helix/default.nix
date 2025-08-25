{
  config,
  pkgs,
  lib,
  ...
}:
{
  home.sessionVariables = {
    SUDO_EDITOR = lib.getExe config.programs.helix.package;
    VISUAL = "hx";
  };

  programs.helix = {
    enable = true;
    defaultEditor = true;
    package = pkgs.unstable.helix;

    extraPackages = lib.mkMerge [
      [
        pkgs.awk-language-server
        pkgs.ctags-lsp
        pkgs.unstable.bash-language-server
        # pkgs.unstable.buf-language-server
        pkgs.unstable.efm-langserver
        pkgs.unstable.lua-language-server
        pkgs.unstable.taplo
        pkgs.unstable.texlab
        pkgs.unstable.typescript-language-server
        pkgs.unstable.vscode-langservers-extracted
        pkgs.unstable.yaml-language-server
      ]
    ];

    ignores = [
      "!.env*"
      "!*.env"
    ];

    languages = lib.mkMerge [
      {
        language-server = {
          efm = {
            command = "efm-langserver";
          };
          regal = {
            command = "regal";
            args = [ "language-server" ];
            config.provideFormatter = true;
          };
          vscode-json-language-server = {
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
          yaml-language-server = {
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
        };
      }
    ];

    languageSettings = lib.mkMerge [
      {
        env = {
          file-types = lib.mkMerge [
            [
              { glob = ".*.env"; }
              { glob = ".*.envrc"; }
              { glob = ".env"; }
              { glob = ".envrc"; }
            ]
          ];
        };
        git-config = {
          file-types = lib.mkMerge [
            [
              { glob = ".config/git/*"; }
              { glob = ".git/config"; }
              { glob = ".gitattributes"; }
              { glob = ".gitconfig"; }
            ]
          ];
        };
        go = {
          formatter.command = "goimports";
          indent = {
            tab-width = 2;
            unit = "\t";
          };
          language-servers = lib.mkMerge [
            [
              "gopls"
              # "efm-langserver"
              "golangci-lint-lsp" # broken; efm-langserver replaces it
              "ctags-lsp"
            ]
          ];
        };
        json = {
          file-types = lib.mkMerge [
            [
              "json"
              "json.gotmpl"
              "webmanifest"
              { glob = "flake.lock"; }
            ]
          ];
        };
        yaml = {
          file-types = lib.mkMerge [
            [
              "yaml"
              "yaml.gotmpl"
              "yml"
              "yml.gotmpl"
            ]
          ];
        };
        rego = {
          language-servers = lib.mkMerge [
            [
              "regal"
              "regols"
            ]
          ];
        };
        rust = {
          formatter.command = "rustfmt";
        };
        # TODO plantUML support (https://github.com/ptdewey/plantuml-lsp)
      }
    ];

    settings = {
      editor = {
        # auto-save = {
        #   focus-lost = true;
        #   after-delay.enable = true;
        # };
        auto-save = true;
        bufferline = "always";
        cursorcolumn = true;
        cursorline = true;
        idle-timeout = 0;
        middle-click-paste = true;
        mouse = true;
        rulers = [
          80
          120
        ];
        shell = [
          "fish"
          "-l"
          "-c"
        ];
        text-width = 80;
        true-color = true;
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
        file-picker = {
          hidden = false;
        };
        gutters = {
          layout = [
            "diff"
            "diagnostics"
            "line-numbers"
            "spacer"
          ];
          line-numbers = {
            min-width = 3;
          };
        };
        ## https://github.com/helix-editor/helix/pull/6652
        # indent = {
        #   tab-width = 2;
        #   unit = "t";
        # };
        indent-guides = {
          character = "┆";
          render = true;
          skip-levels = 1;
        };
        lsp = {
          display-messages = true;
          display-inlay-hints = true;
        };
        soft-wrap = {
          enable = true;
        };
        statusline = {
          center = [
            "version-control"
            "file-name"
            "read-only-indicator"
            "file-modification-indicator"
          ];
          left = [
            "mode"
            "spinner"
            "workspace-diagnostics"
            "diagnostics"
          ];
          mode = {
            insert = "INSERT";
            normal = "NORMAL";
            select = "SELECT";
          };
          right = [
            "file-type"
            "selections"
            "register"
            "position"
            "file-encoding"
          ];
          separator = "|";
        };
      };
      keys = {
        insert = {
          S-tab = "move_parent_node_start";
        };
        normal = {
          ";" = "command_mode";
          "A-," = "goto_previous_buffer";
          "A-." = "goto_next_buffer";
          "A-/" = "repeat_last_motion";
          A-J = [
            "extend_to_line_bounds"
            "yank"
            "paste_after"
          ];
          A-K = [
            "extend_to_line_bounds"
            "yank"
            "paste_before"
          ];
          A-S-down = [
            "extend_to_line_bounds"
            "yank"
            "paste_after"
          ];
          A-S-up = [
            "extend_to_line_bounds"
            "yank"
            "paste_before"
          ];
          A-down = [
            "extend_to_line_bounds"
            "delete_selection"
            "paste_after"
          ];
          A-j = [
            "extend_to_line_bounds"
            "delete_selection"
            "paste_after"
          ];
          A-k = [
            "extend_to_line_bounds"
            "delete_selection"
            "move_line_up"
            "paste_before"
          ];
          A-up = [
            "extend_to_line_bounds"
            "delete_selection"
            "move_line_up"
            "paste_before"
          ];
          A-w = ":buffer-close";
          # P = ":clipboard-paste-before";
          # R = ":clipboard-paste-replace";
          # Y = ":clipboard-yank";
          # d = [":clipboard-yank-join" "delete_selection"];
          # p = ":clipboard-paste-after";
          # y = ":clipboard-yank-join";
          A-q = ":reflow";
          C-g = [
            ":new"
            ":insert-output lazygit"
            ":redraw"
            ":buffer-close"
          ];
          S-tab = "move_parent_node_start";
          X = [
            "extend_line_up"
            "extend_to_line_bounds"
          ];
          a = [
            "append_mode"
            "collapse_selection"
          ];
          i = [
            "insert_mode"
            "collapse_selection"
          ];
          ins = "insert_mode";
          space = {
            F = "file_picker_in_current_buffer_directory";
          };
          tab = "move_parent_node_end";
          "," = {
            "," = "keep_primary_selection";
            c = ":buffer-close";
            q = ":quit";
            r = ":config-reload";
            s = [
              "split_selection_on_newline"
              ":sort"
              "merge_selections"
            ];
          };
          "[" = {
            j = "jump_backward";
          };
          "]" = {
            j = "jump_forward";
          };
        };
        select = {
          # P = ":clipboard-paste-before";
          # R = ":clipboard-paste-replace";
          # Y = ":clipboard-yank";
          # d = [":clipboard-yank-join" "delete_selection"];
          # p = ":clipboard-paste-after";
          # y = ":clipboard-yank-join";
          S-tab = "extend_parent_node_start";
          X = [
            "extend_line_up"
            "extend_to_line_bounds"
          ];
          tab = "extend_parent_node_end";
        };
      };
    };
  };
}
