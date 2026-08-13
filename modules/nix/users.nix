{
  flake.modules.generic.default = {
    nix.settings = {
      allowed-users = [
        "root"
        "william"
        "@wheel"
      ];
      trusted-users = [
        "root"
        "william"
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
