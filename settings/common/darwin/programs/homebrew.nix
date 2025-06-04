{
  config,
  lib,
  ...
}:
with builtins;
let
  isSetString = str: lib.stringLength (toString str) > 0;
in
{
  environment.infoPath = lib.mkAfter [
    (toString (/. + "${config.homebrew.brewPrefix or ""}/../share/info"))
  ];

  environment.manPath = lib.mkAfter [
    (toString (/. + "${config.homebrew.brewPrefix}/../share/man"))
  ];

  environment.systemPath = lib.mkOrder 1100 [
    config.homebrew.brewPrefix
    (toString (/. + "${config.homebrew.brewPrefix}/../sbin"))
  ];

  environment.variables = {
    HOMEBREW_CASK_OPTS = lib.concatStringsSep " " (
      filter (v: v != "") [
        (lib.optionalString (isSetString config.homebrew.caskArgs.appdir) "--appdir=${config.homebrew.caskArgs.appdir}")
        "--keyboard-layoutdir=${lib.escapeShellArg "~/Library/Keyboard Layouts"}"
        (lib.optionalString config.homebrew.caskArgs.no_quarantine "--no-quarantine")
      ]
    );
    XDG_DATA_DIRS = lib.mkAfter [
      "/opt/homebrew/share"
    ];
  };

  homebrew = {
    enable = true;
    caskArgs = {
      appdir = "~/Applications";
      # keyboard_layoutdir = "~/Library/Keyboard Layouts";
      no_quarantine = true;
    };
    global = {
      autoUpdate = true;
      brewfile = true;
      lockfiles = false;
    };
    onActivation = {
      autoUpdate = false;
      upgrade = false;
      cleanup = "uninstall";
    };
  };
}
