{
  lib,
  ...
}:
{
  flake.modules.generic.shell =
    {
      config,
      ...
    }:
    {
      home-manager.sharedModules = [
        {
          programs.ssh = {
            settings = lib.optionalAttrs (config.networking.domain != null) {
              ${config.networking.domain} = {
                SendEnv = [
                  "ZELLIJ"
                ];
              };
            };
            # matchBlocks = lib.optionalAttrs (config.networking.domain != null) {
            #   "*.${config.networking.domain}" = {
            #     sendEnv = [
            #       "ZELLIJ"
            #     ];
            #   };
            # };
          };
        }
      ];
    };

  flake.modules.nixos.shell = {
    security.sudo.extraConfig = ''
      Defaults:root,%wheel env_keep+=ZELLIJ
    '';

    services.openssh.settings.AcceptEnv = [
      "ZELLIJ"
    ];
  };

  flake.modules.homeManager.shell =
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
            ".f" = "zellij action new-tab -c ~/.local/share/dotfiles/ -n dotfiles";
            ztab = "zellij action new-tab -c";
            zifm = "zellij run -i -n yazi -- direnv exec . yazi";
            zihx = "zellij run -i -n helix -- direnv exec . hx -w .";
            zilg = "zellij run -i -n lazygit -- direnv exec . lazygit";
            zfm = "zellij run -c -n yazi -- yazi";
            zhx = "zellij run -c -n helix -- hx -w .";
            zlg = "zellij run -c -n lazygit -- lazygit";
            zi = "zellij run -i";
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
      };
    };
}
