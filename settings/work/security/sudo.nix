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
          ### User defaults to fix CISO's approved  copy-pasta from StackOverflow.
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
}
