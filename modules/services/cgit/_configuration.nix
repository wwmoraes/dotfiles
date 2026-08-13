{
  config,
  ...
}:
{
  services.cgit."git.${config.networking.domain}" = {
    enable = true;
    group = "git";
    user = "git";
    scanPath = "/srv/git";
  };

  system.stateVersion = "25.05";
}
