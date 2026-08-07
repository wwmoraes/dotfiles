{
  flake-file.nixConfig = {
    extra-experimental-features = [
      "pipe-operators"
    ];
  };

  flake.modules.generic.default = {
    nix.settings = {
      extra-experimental-features = [
        "flakes"
        "nix-command"
        "pipe-operators"
      ];
    };
  };
}
