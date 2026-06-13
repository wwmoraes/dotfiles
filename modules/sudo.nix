{
  lib,
  ...
}:
{
  flake.modules.darwin.default =
    {
      config,
      ...
    }:
    let
      username = config.system.primaryUser;
    in
    {
      security.sudo = {
        # enable = false;
        extraConfigFiles = {
          common = {
            enable = true;
            target = "~darwin-common";
            text = ''
              Defaults env_delete += "LD_PRELOAD LD_LIBRARY_PATH LD_AUDIT PYTHONPATH RUBYLIB PERL5LIB"
              ${username} ALL = PASSWD: /bin/rm -rf /Library/Developer/CommandLineTools
              ${username} ALL = PASSWD: /usr/bin/xcode-select --install
              ${username} ALL = PASSWD: /usr/bin/xcodebuild -license accept
              ${username} ALL = PASSWD: /usr/sbin/DevToolsSecurity -enable
            '';
          };
          homebrew = {
            enable = true;
            target = "~darwin-homebrew";
            text = ''
              ### for global installations (default brew setting)
              ${username} ALL = PASSWD:SETENV: /bin/mkdir -p /Applications
              ${username} ALL = PASSWD:SETENV: /bin/mv /usr/local/Caskroom/*.app /Applications/*.app
              ${username} ALL = PASSWD:SETENV: /bin/mv /opt/homebrew/Caskroom/*.app /Applications/*.app

              ### internally used by brew to (un)install casks
              ${username} ALL = PASSWD:SETENV: /usr/sbin/installer -pkg /opt/homebrew/Caskroom/*.pkg -target /
              ${username} ALL = PASSWD:SETENV: /usr/bin/env * /usr/sbin/installer -pkg /usr/local/Caskroom/*.pkg -target /
              ${username} ALL = PASSWD:SETENV: /usr/bin/env * /usr/sbin/installer -pkg /opt/homebrew/Caskroom/*.pkg -target /
              ${username} ALL = PASSWD:SETENV: /usr/sbin/pkgutil --forget *
              ${username} ALL = PASSWD:SETENV: /usr/local/Caskroom/*/*/uninstall.tool
              ${username} ALL = PASSWD:SETENV: /opt/homebrew/Caskroom/*/*/uninstall.tool

              ### cleanup permissions
              ### TODO reduce this scope, it is too broad...
              ${username} ALL = PASSWD:SETENV: /usr/bin/xargs -0 -- /bin/rm --
              ${username} ALL = PASSWD:SETENV: /usr/bin/xargs -0 -- /usr/local/Homebrew/Library/Homebrew/cask/utils/rmdir.sh
            '';
          };
          mas = {
            enable = true;
            target = "~darwin-mas";
            text = ''
              ${username} ALL = PASSWD: /usr/local/bin/mas uninstall *
            '';
          };
        };
        keepTerminfo = false;
      };
    };

  flake.modules.darwin.work =
    {
      config,
      ...
    }:
    let
      username = config.system.primaryUser;
      home = config.system.primaryUserHome;
      group = "staff";
    in
    {
      security.sudo = {
        extraConfigFiles = {
          work = {
            enable = true;
            target = "~darwin-work";
            text = ''
              ### User defaults to fix CISO's approved󰩸 copy-pasta from StackOverflow.
              ###
              ### For instance, absolutely great idea from CISO to ask for sudo password every
              ### fucking time. I've leaked my password to the logs twice in one day just
              ### because of this. Secure, right?
              ###
              ### Now we're back to the standard 5 minutes timestamp.
              Defaults:${username} timestamp_timeout=5
              ###
              ### Re-enables the option to set environment variables with -E.
              Defaults:${username} setenv

              ### using a graphical application that assigns you to the wheel group to be able
              ### to sudo is so retarded that I decided to risk myself :D
              # Cmnd_Alias UNSAFE_WORK_CMDS = /usr/bin/su, /bin/cp *
              # Cmnd_Alias SAFE_WORK_CMDS = /usr/bin/true "", /usr/bin/renice *, /usr/sbin/taskpolicy *

              # ${username} ALL = PASSWD: UNSAFE_WORK_CMDS
              # ${username} ALL = NOPASSWD: SAFE_WORK_CMDS
              # ${username} ALL = PASSWD: /bin/launchctl config user path *

              ### why wouldn't I be able to change the ownership of my own fucking files?
              # ${username} WORK = SETENV: /usr/sbin/chown -R ${username}\:${group} ${home}/*

              ### now I can work in peace without requesting elevation and waiting an entire
              ### day to get it, update tools I need and resume coding
              ${username} ALL = (ALL) PASSWD:ALL
              ${username} ALL = PASSWD: /usr/bin/sfltool *
              ${username} ALL = PASSWD: /usr/sbin/dseditgroup -o edit -a ${username} -t user admin
              ${username} ALL = PASSWD: /usr/sbin/dseditgroup -o edit -d ${username} -t user admin
            '';
          };
        };
      };
    };

  # TODO further harden sudo https://www.systemshardening.com/articles/linux/sudo-hardening/
  flake.modules.nixos.default = {
    security.sudo.extraConfig = lib.mkBefore ''
      Defaults env_reset
      Defaults env_delete += "LD_PRELOAD LD_LIBRARY_PATH LD_AUDIT PYTHONPATH RUBYLIB PERL5LIB"
      Defaults env_keep += "CHARSET LANG LANGUAGE LC_ALL LC_COLLATE LC_CTYPE"
      Defaults env_keep += "LC_MESSAGES LC_MONETARY LC_NUMERIC LC_TIME"
      Defaults env_keep += "LSCOLORS"
      Defaults env_keep += "SSH_AUTH_SOCK"
      Defaults env_keep += "TZ"
      Defaults env_keep += "EDITOR VISUAL"
      Defaults env_keep += "HOME MAIL"
      Defaults requiretty
      Defaults use_pty
    '';
  };
}
