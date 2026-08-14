{ inputs, ... }:
{
  flake.modules.homeManager.william = { pkgs, ... }: {
    programs.lazygit.settings.gui.authorColors."William Artero" = "#2cbdff";
    stylix = {
      base16Scheme = inputs.tinted-theming + /base16/ashes.yaml;
      fonts = {
        emoji = {
          package = pkgs.nerd-fonts.fira-code;
          name = "FiraCode Nerd Font";
        };
        monospace = {
          package = pkgs.nerd-fonts.fira-code;
          name = "FiraCode Nerd Font Propo";
        };
        sansSerif = {
          package = pkgs.nerd-fonts.fira-code;
          name = "FiraCode Nerd Font Propo";
        };
        serif = {
          package = pkgs.nerd-fonts.fira-code;
          name = "FiraCode Nerd Font Propo";
        };
        sizes = {
          applications = 16;
          desktop = 14;
          popups = 14;
          terminal = 16;
        };
      };
      targets = {
        lazygit.colors.override.withHashtag = {
          base03 = "#3E484F";
        };
        zellij.colors.override.withHashtag = {
          base04 = "#3E484F";
          base05 = "#6C7D89";
        };
      };
    };
  };
}
