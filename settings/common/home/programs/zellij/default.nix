{
  config,
  lib,
  ...
}:
{
  programs.fish = {
    ## ensures this exec is at the very end
    interactiveShellInit = lib.mkIf config.programs.zellij.enable (
      lib.mkOrder 2000 (
        let
          zellijBin = lib.getExe config.programs.zellij.package;
          rgBin = lib.getExe config.programs.ripgrep.package;
        in
        ''
          ## skip if in Apple Terminal.app
          string match -q "Apple_Terminal" $TERM_PROGRAM; and return

          ## skip if inside a tmux/GNU screen session
          string match -q "screen*" $TERM; and return

          ## skip if inside a zellij session
          set -Sq ZELLIJ; and return

          ## remove dead session as zellij fails to resurrect it
          ${zellijBin} list-sessions --no-formatting | ${rgBin} "^main\b"
          or ${zellijBin} delete-session main

          exec ${zellijBin} attach -c main
        ''
      )
    );

    shellAbbrs = lib.mkMerge [
      {
        ".f" = "zellij action new-tab -c ~/.local/share/dotfiles/ -l development -n dot";
        zdev = "zellij action new-tab -l development -c";
        zfm = "zellij run -i -n yazi -- direnv exec . yazi";
        zhx = "zellij run -i -n helix -- direnv exec . hx -w .";
        zlg = "zellij run -i -n lazygit -- direnv exec . lazygit";
        zri = "zellij run -i";
      }
    ];
  };

  programs.zellij = {
    enable = true;
    # attachExistingSession = true;
    # exitShellOnExit = true;
    # enableFishIntegration = true;
  };

  ## TODO create some typings to generate KDL
  xdg.configFile = {
    "zellij/config.kdl".source = ./config.kdl;
    "zellij/layouts/development.kdl".source = ./layouts/development.kdl;
  };
}
