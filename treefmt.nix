{
  imports = [
    # keep-sorted start
    ./modules/treefmt
    # keep-sorted end
  ];

  projectRootFile = "flake.nix";

  programs.fish_indent.enable = true;
  programs.jsonfmt.enable = true;
  programs.keep-sorted.enable = true;
  programs.mdformat = {
    enable = true;
  };
  programs.nixf-diagnose.enable = true;
  programs.shellcheck-posix.enable = true;
  programs.shellcheck-bash.enable = true;
  programs.statix.enable = true;
  programs.nixfmt.enable = true;
  programs.typos = {
    enable = true;
    excludes = [
      "*.asc"
      "secrets.yaml"
      "settings/common/darwin/programs/finicky/finicky.js"
    ];
    configFile = builtins.toString ./.typos.toml;
  };
  programs.yamlfmt = {
    enable = true;
    excludes = [
      "secrets.yaml"
    ];
    settings = {
      formatter = {
        type = "basic";
        indentless_arrays = true;
        scan_folded_as_literal = true;
      };
    };
  };
}
