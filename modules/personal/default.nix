{
  flake.modules.generic.home = {
    time.timeZone = "Europe/Amsterdam";
  };

  flake.modules.darwin.personal = {
    system.primaryUser = "william";
  };
}
