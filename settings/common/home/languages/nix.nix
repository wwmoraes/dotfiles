{
  pkgs,
  ...
}:
{
  editorconfig.settings = {
    "*.nix" = {
      indent_size = 2;
      indent_style = "space";
      tab_width = 2;
    };
    "flake.lock" = {
      charset = "unset";
      indent_size = "unset";
      indent_style = "unset";
      insert_final_newline = "unset";
      tab_width = "unset";
      trim_trailing_whitespace = "unset";
    };
  };

  home.packages = [
    pkgs.nixfmt
  ];

  programs.git = {
    attributes = [
      "*.nix diff=nix"
    ];
    settings = {
      diff.nix.xfuncname = ''^\s*(\S+)\s*=.*$'';
      mergetool.nixfmt = {
        cmd = ''nixfmt --mergetool "$BASE" "$LOCAL" "$REMOTE" "$MERGED"'';
        trustExitCode = true;
      };
    };
  };

  programs.helix = {
    languageSettings.nix = {
      auto-format = true;
      formatter = {
        command = "nixfmt";
      };
    };
  };
}
