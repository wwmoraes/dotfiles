{
  flake.modules.darwin.personal = {
    /*
      TODO extra settings to turn into declarative options
      ## Remove the sleep image file to save disk space
      # test -f /private/var/vm/sleepimage && sudo rm /private/var/vm/sleepimage

      ## Create a zero-byte file instead…
      # sudo touch /private/var/vm/sleepimage

      ## …and make sure it can't be rewritten
      # sudo chflags uchg /private/var/vm/sleepimage
    */
    system.defaults.CustomUserPreferences = {
      "com.apple.PowerChime" = {
        ChimeOnAllHardware = false;
      };
    };

    power = {
      restartAfterFreeze = true;
      # restartAfterPowerFailure = true;
      sleep = {
        allowSleepByPowerButton = false;
        computer = "never";
        display = 2;
        harddisk = 10;
      };
    };

    system.pmset = {
      all = {
        autorestart = 1;
        hibernatemode = 0;
        highstandbythreshold = 50;
        lidwake = 1;
        standbydelay = 86400;
        standbydelayhigh = 3600;
        standbydelaylow = 900;
      };
      battery = {
        displaysleep = 2;
        sleep = 5;
      };
      charger = {
        displaysleep = 30;
        sleep = 60;
      };
    };
  };
}
