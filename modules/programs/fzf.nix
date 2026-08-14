{
  flake.modules.homeManager.shell =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      home.packages = lib.mkMerge [
        (lib.optionals config.programs.fzf.enable [
          pkgs.tree
        ])
      ];

      programs.fish.interactiveShellInit = lib.mkMerge [
        (lib.mkBefore ''
          ## rebind fzf keys
          if not set -q FZF_CTRL_T_COMMAND; or test -n "$FZF_CTRL_T_COMMAND"
            bind --erase ctrl-t
            bind --erase -M insert ctrl-t
            bind ctrl-f fzf-file-widget
            bind -M insert ctrl-f fzf-file-widget
          end

          if not set -q FZF_ALT_C_COMMAND; or test -n "$FZF_ALT_C_COMMAND"
            bind --erase alt-c
            bind --erase -M insert alt-c
            bind ctrl-v fzf-cd-widget
            bind -M insert ctrl-v fzf-cd-widget
          end
        '')
      ];

      programs.fzf = lib.mkMerge [
        {
          defaultOptions = [
            "--bind ctrl-b:preview-page-up"
            "--bind ctrl-d:preview-down"
            "--bind ctrl-f:preview-page-down"
            "--bind ctrl-u:preview-up"
            "--height=50%"
            "--layout=reverse"
          ];
          historyWidgetOptions = [
            "--sort"
            "--exact"
          ];
        }
        (lib.optionalAttrs config.programs.tree.enable {
          changeDirWidgetOptions = [
            "--preview '${lib.getExe config.programs.tree.package} -C {} | head -200'"
          ];
        })
        (lib.optionalAttrs config.programs.bat.enable {
          fileWidgetOptions = [
            "--preview '${lib.getExe config.programs.bat.package} --force-colorization --style=-header-filename {}'"
          ];
        })
        (lib.optionalAttrs config.programs.fd.enable (
          let
            fdBin = lib.getExe config.programs.fd.package;
          in
          {
            changeDirWidgetCommand = "${fdBin} --type d";
            defaultCommand = "${fdBin} --unrestricted --type f";
            fileWidgetCommand = "${fdBin} --hidden --exclude .git --type f";
          }
        ))
      ];
    };
}
