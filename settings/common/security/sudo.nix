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
          ${username} ALL = NOPASSWD: /bin/rm -rf /Library/Developer/CommandLineTools
          ${username} ALL = NOPASSWD: /usr/bin/xcode-select --install
          ${username} ALL = NOPASSWD: /usr/bin/xcodebuild -license accept
          ${username} ALL = NOPASSWD: /usr/sbin/DevToolsSecurity -enable
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
  };
}
