{
  imports = [
    ./modules/treefmt
  ];

  projectRootFile = "flake.nix";

  # beautysh
  programs.fish_indent.enable = true;
  # gofmt
  # gofumpt
  # goimports
  # golines
  programs.jsonfmt.enable = true;
  # keep-sorted
  programs.mdformat.enable = true;
  programs.nixf-diagnose.enable = true;
  # oxipng
  # pinact
  programs.shellcheck-posix.enable = true;
  programs.shellcheck-bash.enable = true;
  # shfmt
  programs.statix.enable = true;
  # programs.taplo = {
  #   enable = true;
  #   excludes = [
  #     "settings/common/home/programs/helix/default-languages.toml"
  #   ];
  # };
  programs.nixfmt.enable = true;
  programs.typos = {
    enable = true;
    excludes = [
      "*.asc"
      "settings/common/home/programs/helix/default-languages.toml"
      "settings/common/programs/finicky/finicky.js"
    ];
    configFile = builtins.toString ./.typos.toml;
  };
  programs.yamlfmt = {
    enable = true;
    settings = {
      formatter = {
        type = "basic";
        indentless_arrays = true;
        scan_folded_as_literal = true;
      };
    };
  };
}
