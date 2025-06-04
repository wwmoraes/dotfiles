{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkAfter
    mkBefore
    mkEnableOption
    mkPackageOption
    types
    mkIf
    mkOption
    ;

  cfg = config.programs.powerline-go;
in
{
  meta.maintainers = [
    lib.maintainers.wwmoraes or "wwmoraes"
  ];

  options = {
    programs.powerline-go = {
      enable = mkEnableOption "Powerline-go, a beautiful and useful low-latency prompt for your shell";

      package = mkPackageOption pkgs "powerline-go" {
        nullable = true;
        default = "powerline-go";
      };

      enableBashIntegration = lib.hm.shell.mkBashIntegrationOption { inherit config; };
      enableFishIntegration = lib.hm.shell.mkFishIntegrationOption { inherit config; };
      enableZshIntegration = lib.hm.shell.mkZshIntegrationOption { inherit config; };

      modules = mkOption {
        default = null;
        type = with types; nullOr (listOf str);
        description = ''
          List of module names to load. The list of all available
          modules as well as the choice of default ones are at
          <https://github.com/justjanne/powerline-go>.
        '';
        example = [
          "host"
          "ssh"
          "cwd"
          "gitlite"
          "jobs"
          "exit"
        ];
      };

      modulesRight = mkOption {
        default = null;
        type = with types; nullOr (listOf str);
        description = ''
          List of module names to load to be displayed on the right side.
          Currently not supported by bash. Specifying a value for this
          option will force powerline-go to use the eval format to set
          the prompt.
        '';
        example = [
          "host"
          "venv"
          "git"
        ];
      };

      newline = mkOption {
        default = false;
        type = types.bool;
        description = "Set to true if the prompt should be on a line of its own.";
        example = true;
      };

      pathAliases = mkOption {
        default = null;
        type = with types; nullOr (attrsOf str);
        description = "Pairs of full-path and corresponding desired short name.";
        example = lib.literalExpression ''
          {
            "~/projects/home-manager" = "prj:home-manager";
          }
        '';
      };

      settings = mkOption {
        default = { };
        type =
          with types;
          attrsOf (oneOf [
            bool
            int
            str
            (listOf str)
          ]);
        description = ''
          This can be any key/value pair as described in
          <https://github.com/justjanne/powerline-go>.
        '';
        example = lib.literalExpression ''
          {
            hostname-only-if-ssh = true;
            numeric-exit-codes = true;
            cwd-max-depth = 7;
            ignore-repos = [ "/home/me/big-project" "/home/me/huge-project" ];
          }
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages = [
      cfg.package
    ];

    programs.bash.initExtra = mkIf cfg.enableBashIntegration (
      lib.mkBefore ''
        function _update_ps1() {
          local old_exit_status=$?
          STARTTIME=$(HISTTIMEFORMAT='%s ' history 1 | awk '{print $2}')
          duration=$((EPOCHSECONDS - STARTTIME))
          eval "$(${lib.getExe config.programs.powerline-go.package} -shell bash -eval -duration $duration -error $old_exit_status -jobs $(jobs -p | wc -l) -vi-mode viins)"
          return $old_exit_status
        }

        if [ "$TERM" != "linux" ]; then
          PROMPT_COMMAND="_update_ps1;$PROMPT_COMMAND"
        fi
      ''
    );

    programs.zsh.initContent = mkIf cfg.enableZshIntegration (mkBefore ''
      zmodload zsh/datetime

      function __cmdtime_save_time_preexec() {
        __cmdtime_cmd_start_time=$EPOCHREALTIME
      }

      function __powerline_precmd() {
        local old_exit_status=$?
        local cmd_end_time=$EPOCHREALTIME
        local duration=$((cmd_end_time - __cmdtime_cmd_start_time))
        unset __cmdtime_cmd_start_time
        eval "$(${lib.getExe config.programs.powerline-go.package} -shell zsh -eval -duration $duration -error $old_exit_status -jobs ''${''${(%):%j}:-0} -vi-mode "$KEYMAP")"
      }

      if [ "$TERM" != "linux" ]; then
        add-zsh-hook preexec __cmdtime_save_time_preexec
        add-zsh-hook precmd __powerline_precmd
      fi
    '');

    programs.fish.functions.fish_prompt.body = mkIf cfg.enableFishIntegration (mkAfter ''
      switch $fish_bind_mode
        case insert
          set vimode viins
        case '*'
          set vimode vicmd
      end

      ${lib.getExe config.programs.powerline-go.package} -shell bare -duration (math -s6 "$CMD_DURATION / 1000") -error $status -jobs (count (jobs -p)) -vi-mode $vimode
    '');

    xdg.configFile."powerline-go/config.json" = {
      text = builtins.toJSON (
        builtins.removeAttrs (
          cfg.settings
          // {
            inherit (cfg) modules;
            modules-right = cfg.modulesRight;
            path-aliases = cfg.pathAliases;
          }
        ) [ "shell" ]
      );
    };
  };
}
