{
  config,
  ...
}:
{
  sops = {
    gnupg = {
      home = config.home-manager.users.${config.system.primaryUser}.programs.gpg.homedir;
    };
  };
}
