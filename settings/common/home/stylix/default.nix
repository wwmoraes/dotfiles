{
  pkgs,
  ...
}:
let
  schemes = pkgs.fetchFromGitHub {
    owner = "tinted-theming";
    repo = "schemes";
    rev = "spec-0.11";
    hash = "sha256-LI+BnRoFNRa2ffbe3dcuIRYAUcGklBx0+EcFxlHj0SY=";
  };
in
{
  stylix = {
    enable = true;

    base16Scheme = "${schemes}/base16/ashes.yaml";
    # base16Scheme = "${schemes}/base16/ia-dark.yaml";
    # base16Scheme = "${schemes}/base16/rose-pine-moon.yaml";
    # base16Scheme = "${schemes}/base16/danqing.yaml";

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
      gtk.enable = false;
    };
  };
}
