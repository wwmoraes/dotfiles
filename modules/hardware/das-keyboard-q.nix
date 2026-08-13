{
  flake.modules.darwin.personal = {
    homebrew.casks = [
      "das-keyboard-q"
    ];

    system.defaults.timemachine.perUser.home.SkipPaths = [
      ".quio"
    ];
  };
}
