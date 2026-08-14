{
  flake.modules.generic.william = { config, ... }: {
    home-manager.users.william = {
      home.username = config.users.users.william.name;
    };

    users.users.william.description = "William Artero";
  };

  flake.modules.darwin.william = {
    users.users.william.home = "/Users/william";
  };

  flake.modules.nixos.william = {
    users.users.william.home = "/home/william";
  };
}
