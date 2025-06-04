{
  pkgs,
  lib,
  ...
}:
let
  helixPackage = pkgs.unstable.helix;
in
{
  home.sessionVariables =
    let
      helixBin = lib.getExe helixPackage;
    in
    {
      SUDO_EDITOR = helixBin;
      VISUAL = helixBin;
    };

  programs.helix =
    let
      defaultLanguages = builtins.fromTOML (builtins.readFile ./default-languages.toml);
      languageAttrs = builtins.foldl' (
        attrs: entry:
        attrs
        // {
          "${entry.name}" = builtins.removeAttrs entry [ "name" ];
        }
      ) { } defaultLanguages.language;
    in
    {
      enable = true;
      defaultEditor = true;
      package = helixPackage;

      extraPackages = lib.mkMerge [
        [
          pkgs.unstable.bash-language-server
          # pkgs.unstable.buf-language-server
          pkgs.unstable.efm-langserver
          pkgs.unstable.lua-language-server
          pkgs.unstable.nil
          pkgs.unstable.taplo
          pkgs.unstable.texlab
          pkgs.unstable.typescript-language-server
          pkgs.unstable.vscode-langservers-extracted
          pkgs.unstable.yaml-language-server
        ]
      ];

      # TODO plantUML support (https://github.com/ptdewey/plantuml-lsp)
      languages = (builtins.removeAttrs defaultLanguages [ "language" ]) // {
        language = lib.mapAttrsToList (k: v: { name = k; } // v) (
          lib.recursiveUpdate languageAttrs {
            env = {
              ## TODO use mkDefault/mkMerge to make this more modular
              file-types = languageAttrs.env.file-types ++ [
                { glob = ".*.env"; }
                { glob = ".*.envrc"; }
              ];
              grammar = "sh";
            };
            git-config = {
              ## TODO use mkDefault/mkMerge to make this more modular
              file-types = languageAttrs.git-config.file-types ++ [
                { glob = ".config/git/*"; }
              ];
            };
            go = {
              formatter.command = "goimports";
              indent.tab-width = 2;
            };
            json = {
              ## TODO use mkDefault/mkMerge to make this more modular
              file-types = languageAttrs.json.file-types ++ [
                { glob = "*.json.tmpl"; }
              ];
            };
            nix = {
              ## TODO use mkDefault/mkMerge to make this more modular
              file-types = languageAttrs.nix.file-types ++ [
                { glob = "*.nix.tmpl"; }
              ];
            };
            rego = {
              language-servers = languageAttrs.rego.language-servers ++ [
                "regal"
              ];
            };
            rust = {
              formatter.command = "rustfmt";
            };
          }
        );
        language-server = lib.recursiveUpdate defaultLanguages.language-server {
          efm = {
            command = "efm-langserver";
          };
          regal = {
            command = "regal";
            args = [ "language-server" ];
            config.provideFormatter = true;
          };
          vscode-json-language-server.config.json = {
            format.enable = true;
            schemaDownload.enable = true;
            schemas = [
              {
                fileMatch = [ "/package.json" ];
                url = "https://json.schemastore.org/package.json";
              }
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
          yaml-language-server.config.yaml = {
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
