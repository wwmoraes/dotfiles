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

  programs.fzf =
    let
      batBin = lib.getExe config.programs.bat.package;
      fdBin = lib.getExe config.programs.fd.package;
      treeBin = lib.getExe pkgs.tree;
    in
    {
      enable = true;
      changeDirWidgetCommand = "${fdBin} --type d";
      changeDirWidgetOptions = [
        "--preview '${treeBin} -C {} | head -200'"
      ];
      defaultCommand = "${fdBin} --unrestricted --type f";
      defaultOptions = [
        "--bind ctrl-b:preview-page-up"
        "--bind ctrl-d:preview-down"
        "--bind ctrl-f:preview-page-down"
        "--bind ctrl-u:preview-up"
        "--height=50%"
        "--layout=reverse"
      ];
      fileWidgetCommand = "${fdBin} --hidden --exclude .git --type f";
      fileWidgetOptions = [
        "--preview '${batBin} --force-colorization --style=-header-filename {}'"
      ];
      historyWidgetOptions = [
        "--sort"
        "--exact"
      ];
    };
}
