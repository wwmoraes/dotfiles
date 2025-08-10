{
  pkgs,
  ...
}:
{
  imports = [
    pkgs.nur.repos.wwmoraes.treefmtModules.checkmake
  ];

  projectRootFile = "flake.nix";

  programs.checkmake.enable = true;
  ## TODO custom: golangci-lint
  programs.gofmt.enable = true;
  programs.gofumpt.enable = true;
  programs.goimports.enable = true;
  programs.golines.enable = true;
  programs.keep-sorted.enable = true;
  programs.mdformat = {
    enable = true;
    package = pkgs.mdformat.withPlugins (
      ps: with ps; [
        mdformat-frontmatter
      ]
    );
    settings = {
      number = true;
      wrap = 80;
    };
  };
  programs.nixf-diagnose.enable = true;
  programs.nixfmt.enable = true;
  programs.statix.enable = true;
  programs.typos = {
    enable = true;
    excludes = [
      ".golangci.yaml"
      "CHANGELOG.md"
      "go.mod"
      "go.sum"
    ];
    configFile = builtins.toString ./.typos.toml;
  };
  programs.yamlfmt = {
    enable = true;
    settings = {
      gitignore_excludes = true;
      formatter = {
        type = "basic";
        indentless_arrays = true;
        retain_line_breaks_single = true;
        scan_folded_as_literal = true;
        trim_trailing_whitespace = true;
      };
    };
  };
  settings.global.excludes = [
    ".direnv"
    ".tmp"
  ];
}
