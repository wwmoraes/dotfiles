{
  services.cgit."git.home.arpa" = {
    enable = true;
    group = "git";
    user = "git";
    scanPath = "/srv/git";
  };

  system.stateVersion = "25.05";
}
