{
  # TODO use gprof2dot locally to avoid qtbase/dbus/dozens of other dependencies
  flake.modules.darwin.development'personal'disabled = {
    homebrew.brews = [
      "qcachegrind"
    ];
  };
}
