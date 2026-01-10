{
  self,
  ...
}:
{
  perSystem = {
    treefmt = {
      imports = builtins.attrValues self.modules.treefmt;

      projectRootFile = "flake.nix";

      programs.fish_indent.enable = true;
      programs.jsonfmt.enable = true;
      programs.keep-sorted.enable = true;
      programs.mdformat = {
        enable = true;
        settings = {
          wrap = 80;
        };
      };
      programs.nixf-diagnose.enable = true;
      programs.shellcheck-posix.enable = true;
      programs.shellcheck-bash.enable = true;
      programs.statix.enable = true;
      programs.nixfmt.enable = true;
      programs.typos = {
        enable = true;
        excludes = [
          # keep-sorted start
          "*.asc"
          "CHANGELOG.md"
          "modules/programs/finicky/finicky.js"
          "secrets.yaml"
          # keep-sorted end
        ];
        configFile = toString ../.typos.toml;
      };
      programs.yamlfmt = {
        enable = true;
        excludes = [
          # keep-sorted start
          ".github/workflows/integration.yml"
          "secrets.yaml"
          # keep-sorted end
        ];
        settings = {
          formatter = {
            type = "basic";
            indentless_arrays = true;
            scan_folded_as_literal = true;
          };
        };
      };
    };
  };
}
