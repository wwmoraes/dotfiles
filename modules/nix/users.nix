{
  flake.modules.generic.default = {
    nix.settings = {
      allowed-users = [
        "root"
        "@wheel"
      ];
      trusted-users = [
        "root"
        "@wheel"
      ];
    };
  };

  flake.modules.darwin.default = {
    nix.settings = {
      allowed-users = [
        "@admin"
      ];
      trusted-users = [
        "@admin"
      ];
    };
  };

}
