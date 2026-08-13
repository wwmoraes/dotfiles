{
  flake.modules.generic.personal = {
    time.timeZone = "Europe/Amsterdam";
  };

  flake.modules.darwin.personal = {
    system.primaryUser = "william";
  };
}
