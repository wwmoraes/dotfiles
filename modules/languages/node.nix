{
  flake.modules.darwin.default = {
    system.defaults.timemachine.perUser.home.SkipPaths = [
      ".npm"
    ];
  };
}
