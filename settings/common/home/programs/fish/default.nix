{
  config,
  lib,
  pkgs,
  ...
}:
{
  home.packages = [
    pkgs.fortune
    pkgs.neo-cowsay
    # pkgs.fishPlugins.forgit
    pkgs.fishPlugins.sponge
    pkgs.fishPlugins.transient-fish
  ];

  programs.fish = {
    enable = true;
    preferAbbrs = true;

    # an attribute set isn't ideal in a modal input setup for a few reasons:
    #
    # 1) A user may want to set the same keys for multiple modes
    # (default/visual/insert/replace/replace_one). A modes option with a list
    # of modes would solve this.
    #
    # 2) A user may want to issue different commands in different modes for the
    # same keys. This requires a way to set the same key combination with
    # different properties (namely the mode), which also benefits to allow
    # separating other options. A list at the top level solves both this and
    # the previous requirements, namely:
    #
    # [
    #   {
    #     keys = "ctrl-z";
    #     mode = null;
    #     command = "fg";
    #     silent = true;
    #     repaint = true;
    #   }
    #   {
    #     keys = "ctrl-z";
    #     mode = "insert";
    #     command = "fg 2>/dev/null";
    #     silent = true;
    #     repaint = true;
    #   }
    # ]
    #
    # This would result in:
    #
    # bind -s ctrl-z fg repaint
    # bind -M insert -s ctrl-z 'fg 2>/dev/null' repaint
    #
    # The new submodule type could even support 1) to allow squashing those
    # definitions in case they're the same for multiple modes.
    #
    ## TODO contribute a list-based fish bind setting
    binds = {
      "ctrl-z" = {
        command = "fg 2>/dev/null";
        repaint = true;
        silent = true;
      };
      "ctrl-a" = {
        command = ''echo $history[1] | nap shell/(date +"%s").fish'';
        repaint = true;
      };
      "ctrl-down" = {
        command = ''commandline --replace -- (nap list | fzf | ifne xargs nap)'';
        repaint = true;
      };
    };

    shellAbbrs = lib.mkMerge [
      {
        ".d" = "projects dev";
        ".hx" = "hx -w .";
        # command -v xsel > /dev/null 2>&1 && { xsel --input --clipboard "$@"; exit 0; } # Unix/Linux
        # command -v xclip > /dev/null 2>&1 && { xclip -in -selection clipboard "$@"; exit 0; } # Unix/Linux
        # command -v wl-copy > /dev/null 2>&1 && { wl-copy "$@"; exit 0; } # Wayland
        # command -v powershell.exe > /dev/null 2>&1 && { powershell.exe Set-Clipboard "$@"; exit 0; } # WSL
        copy = "pbcopy";
        g = "git";
        lg = "lazygit";
        # command -v xsel > /dev/null 2>&1 && { xsel --output --clipboard "$@"; exit 0; } # Unix/Linux
        # command -v xclip > /dev/null 2>&1 && { xclip -out -selection clipboard "$@"; exit 0; } # Unix/Linux
        # command -v wl-paste > /dev/null 2>&1 && { wl-paste "$@"; exit 0; } # Wayland
        # command -v powershell.exe > /dev/null 2>&1 && { powershell.exe Get-Clipboard "$@"; exit 0; } # WSL
        paste = "pbpaste";
      }
    ];

    shellAliases = lib.mkMerge [
      {
        ls = "ls --classify=auto --color=auto";
      }
    ];

    functions = {
      ## TODO openssl s_client -showcerts -servername <domain> -connect <domain>:<port=443> 2>/dev/null | openssl x509 -inform pem -noout -text
      ## TODO ensure this is working as expected
      ## Apparently direnv now is doing it right. Check if packages are in
      ## set -S __fish_vendor_completionsdirs
      ## set -S __fish_vendor_confdirs
      ## set -S __fish_vendor_functionsdirs
      # __fish_in_nix_shell = {
      #   body = ''
      #     set --local packages (string match --regex "/nix/store/[\w.-]+" $PATH)

      #   test (count $packages) -gt 0; or return

      #   # fish_add_path --global --prepend $packages/bin
      #   # set --global --export PATH (__fish_unique_values $PATH)
      #   # set --universal fish_user_paths (__fish_unique_values $fish_user_paths)

      #   # ## reset the complete path with non-nix store entries
      #   # set --local temp_completions_path ( \
      #   #   string match --invert --regex "/nix/store/[\w.-]+/.*" $fish_complete_path \
      #   #   | string match --regex ".*/completions")
      #   # set --local temp_vendor_completions_path ( \
      #   #   string match --invert --regex "/nix/store/[\w.-]+/.*" $fish_complete_path \
      #   #   | string match --regex ".*/vendor_completions.d")
      #   # ## prepend nix store complete paths
      #   # set --append temp_completions_path \
      #   #   $packages/etc/fish/completions \
      #   #   $packages/share/fish/completions \
      #   #   ;
      #   # set --append temp_vendor_completions_path \
      #   #   $packages/share/fish/vendor_completions.d \
      #   #   ;
      #   # set --global fish_complete_path (__fish_unique_values $temp_completions_path $temp_vendor_completions_path)

      #   # ## reset the function path with non-nix store entries
      #   # set --local temp_functions_path ( \
      #   #   string match --invert --regex "/nix/store/[\w.-]+/.*" $fish_function_path \
      #   #   | string match --regex ".*/functions")
      #   # set --local temp_vendor_functions_path ( \
      #   #   string match --invert --regex "/nix/store/[\w.-]+/.*" $fish_function_path \
      #   #   | string match --regex ".*/vendor_functions.d")
      #   # ## prepend nix store function paths
      #   # set --append temp_functions_path \
      #   #   $packages/etc/fish/functions \
      #   #   $packages/share/fish/functions \
      #   #   ;
      #   # set --append temp_vendor_functions_path \
      #   #   $packages/share/fish/vendor_functions.d \
      #   #   ;
      #   # set --global fish_function_path (__fish_unique_values $temp_functions_path $temp_vendor_functions_path)

      #   ## reset the MANPATH with non-nix store entries
      #   set --local temp_MANPATH (string match --invert --regex "/nix/store/[\w.-]+/.*" $MANPATH)
      #   ## prepend nix store MANPATH paths
      #   set --append temp_MANPATH $packages/share/man
      #   set --global MANPATH (__fish_unique_values $temp_MANPATH)

      #   ## reset the INFOPATH with non-nix store entries
      #   set --local temp_INFOPATH (string match --invert --regex "/nix/store/[\w.-]+/.*" $INFOPATH)
      #   ## prepend nix store INFOPATH paths
      #   set --append temp_INFOPATH $packages/share/info
      #   set --global INFOPATH (__fish_unique_values $temp_INFOPATH)
      #   '';
      #   onVariable = "IN_NIX_SHELL";
      # };
      __fish_seen_subcommand_of = {
        body = builtins.readFile ./functions/__fish_seen_subcommand_of.fish;
      };
      __fish_store_last_status = {
        body = ''
          set -g __fish_last_status $status
        '';
        description = "stores the status of the last command before hooks execute";
        onEvent = "fish_postexec";
      };
      __fish_unique_values = {
        body = builtins.readFile ./functions/__fish_unique_values.fish;
        description = "removes duplicate values, keeping its first occurrence in order";
      };
      # __reload_completions = {
      #   body = ''
      #    for dir in (string split ":" $XDG_DATA_DIRS)
      #      test -d $dir/fish/vendor_completions.d; or continue

      #      set -l files $dir/fish/vendor_completions.d/*.fish
      #      count $files > /dev/null; or continue
      #      for file in $files
      #       test -f $file; or continue
      #       source $file
      #      end
      #    end
      #   '';
      #   onVariable = "XDG_DATA_DIRS";
      # };
      dockr = {
        argumentNames = "cmd";
        body = builtins.readFile ./functions/dockr.fish;
        description = "Docker CLI wrapper with extra commands";
        wraps = "docker";
      };
      domain = {
        argumentNames = "domain";
        body = ''
          dig +nocmd "$domain" <type=ANY> +multiline +noall +answer
        '';
        description = "Digs DNS records of a domain";
      };
      fconnect = {
        body = builtins.readFile ./functions/fconnect.fish;
        description = "fuzzy connect to a host";
      };
      fish_greeting = {
        body = ''
          ${lib.getExe pkgs.fortune} | ${lib.getExe pkgs.neo-cowsay} -n -W 80 --random
        '';
      };
      fish_mode_prompt = {
        body = builtins.readFile ./functions/fish_mode_prompt.fish;
      };
      fish_prompt = {
        body = builtins.readFile ./functions/fish_prompt.fish;
      };
      fish_user_key_bindings = lib.mkMerge [
        (lib.mkBefore ''
          # Execute this once per mode that emacs bindings should be used in
          fish_default_key_bindings -M insert

          # Then execute the vi-bindings so they take precedence when there's a conflict.
          # Without --no-erase fish_vi_key_bindings will default to
          # resetting all bindings.
          # The argument specifies the initial mode (insert, "default" or visual).
          fish_vi_key_bindings --no-erase insert

          bind -M insert ctrl-a '${config.programs.fish.binds."ctrl-a".command}' repaint
          bind -M insert ctrl-down '${config.programs.fish.binds."ctrl-down".command}' repaint
          bind -M insert ctrl-z '${config.programs.fish.binds."ctrl-z".command}' repaint
        '')
      ];
      fkill = {
        body = builtins.readFile ./functions/fkill.fish;
        description = "fuzzy kill processes";
      };
      golang = {
        argumentNames = "cmd";
        body = builtins.readFile ./functions/golang.fish;
        description = "go wrapper with commands that Google forgot";
        wraps = "go";
      };
      k8s = {
        argumentNames = "cmd";
        body = builtins.readFile ./functions/k8s.fish;
        description = "utilities for Kubernetes management";
      };
      nix-prehash = {
        body = builtins.readFile ./functions/nix-prehash.fish;
      };
      nixfmt = {
        body = builtins.readFile ./functions/nixfmt.fish;
        description = "pretty print formatting of nix values";
      };
      pgpz = {
        argumentNames = "cmd";
        body = builtins.readFile ./functions/pgpz.fish;
        description = "gpg for human beings";
        wraps = "gpg";
      };
      pkg = {
        argumentNames = "cmd";
        body = builtins.readFile ./functions/pkg.fish;
        description = "MacOS package management made easy";
        wraps = "pkgutil";
      };
      restart = {
        argumentNames = "name";
        body = builtins.readFile ./functions/restart.fish;
        description = "Restarts a MacOS bundle application";
      };
      sarcasm = {
        body = builtins.readFile ./functions/sarcasm.fish;
        description = "transforms text into the supreme form";
      };
      watchrun = {
        body = builtins.readFile ./functions/watchrun.fish;
        description = "watch for file changes and run command on events";
      };
    };

    shellInit = lib.mkMerge [
      (lib.mkBefore ''
        test -f /etc/fish/setEnvironment.fish
        and source /etc/fish/setEnvironment.fish

        test -f /etc/fish/config.fish
        and source /etc/fish/config.fish
      '')
    ];
    interactiveShellInit = lib.mkMerge [
      ''
        ## configure TTY tab stops
        command -q tabs; and tabs -2
      ''
    ];
  };

  xdg.configFile = builtins.listToAttrs (
    builtins.map (path: {
      name = "fish/completions/${builtins.baseNameOf path}";
      value = {
        executable = true;
        source = path;
      };
    }) (pkgs.lib.local.listDirRegularPaths ./completions)
  );
}
