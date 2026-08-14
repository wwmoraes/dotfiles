{
  flake.modules.generic.root = { config, ... }: {
    home-manager.users.root = {
      home.username = config.users.users.root.name;
    };
  };

  flake.modules.darwin.root = {
    users.users.root.home = "/var/root";
  };

  flake.modules.nixos.root = {
    users.users.root.home = "/root";
  };
}
