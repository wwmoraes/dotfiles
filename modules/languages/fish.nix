{
  flake.modules.homeManager.shell =
    {
      pkgs,
      ...
    }:
    {
      editorconfig.settings."*.fish" = {
        indent_size = 4;
        indent_style = "space";
        tab_width = 4;
      };

      programs.helix.extraPackages = [
        pkgs.fish-lsp
      ];

      xdg.configFile."fish/conf.d/fish-lsp.fish".text = ''
        set -gx fish_lsp_commit_characters '\t' ';' ' '
        set -gx fish_lsp_diagnostic_disable_error_codes 4001
        set -gx fish_lsp_show_client_popups false
      '';
    };
}
