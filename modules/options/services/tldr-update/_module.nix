{
  config,
  lib,
  pkgs,
  ...
}:
let
  # converts systemd.time definitions to launchd intervals.
  # See:
  # - https://www.man7.org/linux/man-pages/man7/systemd.time.7.html
  # - https://www.launchd.info/#/key-StartInterval
  # - https://www.launchd.info/#/key-StartCalendarInterval
  # - https://developer.apple.com/library/archive/documentation/MacOSX/Conceptual/BPSystemStartup/Chapters/ScheduledJobs.html#//apple_ref/doc/uid/10000172i-CH1-SW1
  # - https://developer.apple.com/library/archive/documentation/MacOSX/Conceptual/BPSystemStartup/Chapters/CreatingLaunchdJobs.html#//apple_ref/doc/uid/10000172i-SW7-SW7
  #
  timeToInterval = {
    minutely = { };
    hourly = {
      Minute = 0;
    };
    daily = {
      Hour = 0;
      Minute = 0;
    };
    monthly = {
      Day = 1;
      Hour = 0;
      Minute = 0;
    };
    weekly = {
      Weekday = 1;
      Hour = 0;
      Minute = 0;
    };
    yearly = {
      Month = 1;
      Day = 1;
      Hour = 0;
      Minute = 0;
    };
    quarterly = [
      {
        Month = 1;
        Day = 1;
        Hour = 0;
        Minute = 0;
      }
      {
        Month = 4;
        Day = 1;
        Hour = 0;
        Minute = 0;
      }
      {
        Month = 7;
        Day = 1;
        Hour = 0;
        Minute = 0;
      }
      {
        Month = 10;
        Day = 1;
        Hour = 0;
        Minute = 0;
      }
    ];
    semiannually = [
      {
        Month = 1;
        Day = 1;
        Hour = 0;
        Minute = 0;
      }
      {
        Month = 7;
        Day = 1;
        Hour = 0;
        Minute = 0;
      }
    ];
    __functor =
      self: value:
      if builtins.hasAttr value self then
        builtins.getAttr value self
      else
        builtins.warn "unsupported time definition: ${value}" value;
  };
  isValidInterval = value: !(value.StartInterval == null && value.StartCalendarInterval == null);
  systemdTime2launchdInterval =
    time:
    let
      interval = timeToInterval time;
      launchdInterval = {
        StartInterval = if builtins.isInt interval then interval else null;
        StartCalendarInterval =
          if builtins.isAttrs interval || builtins.isList interval then interval else null;
      };
    in
    if isValidInterval launchdInterval then
      launchdInterval
    else
      builtins.warn "unsupported time definition: ${time}" launchdInterval;
  cfg = config.services.tldr-update;
in
{
  meta.maintainers = [ lib.maintainers.wwmoraes ];

  options.services.tldr-update = {
    enable = lib.mkEnableOption ''
      Automatic updates for the tldr CLI
    '';

    package = lib.mkPackageOption pkgs "tldr" { example = "tlrc"; };

    period = lib.mkOption {
      type = lib.types.str;
      default = "weekly";
      description = ''
        Systemd timer period to create for scheduled {command}`tldr --update`.

        The format is described in {manpage}`systemd.time(7)`.
      '';
      apply = systemdTime2launchdInterval;
    };
  };

  config = lib.mkIf cfg.enable {
    launchd.agents.tldr-update = {
      enable = true;
      config = cfg.period // rec {
        Label = "org.nix-community.home.tldr-update";
        ProcessType = "Background";
        ProgramArguments = [
          "${lib.getExe cfg.package}"
          "--update"
        ];
        RunAtLoad = false;
        StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/${Label}.err.log";
        StandardOutPath = "${config.home.homeDirectory}/Library/Logs/${Label}.out.log";
      };
    };
  };
}
