{
  flake.modules.generic.shell = {
    home-manager.sharedModules = [
      (
        {
          pkgs,
          ...
        }:
        {
          programs.helix.package = pkgs.unstable.helix;
        }
      )
    ];
  };

  flake.modules.homeManager.shell =
    {
      config,
      lib,
      pkgs,
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

        extraPackages = lib.mkMerge [
          [
            pkgs.awk-language-server
            pkgs.unstable.bash-language-server
            pkgs.unstable.lua-language-server
            pkgs.unstable.texlab
            pkgs.unstable.typescript-language-server
          ]
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
        };
      };
    };
}
