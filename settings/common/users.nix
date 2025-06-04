{
  config,
  pkgs,
  ...
}:
let
  primaryUserHome =
    if pkgs.stdenv.hostPlatform.isDarwin then
      "/Users/${config.system.primaryUser}"
    else
      "/home/${config.system.primaryUser}";
in
{
  home-manager = {
    users.${config.system.primaryUser} = {
      home.homeDirectory = primaryUserHome;
    };
  };

  users.users.${config.system.primaryUser} = {
    name = config.system.primaryUser;
    home = primaryUserHome;
  };
}
