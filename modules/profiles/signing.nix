{
  flake.modules.homeManager.profile'signing = {
    programs = {
      # keep-sorted start
      gpg.enable = true;
      # keep-sorted end
    };

    services = {
      # keep-sorted start
      gpg-agent.enable = true;
      # keep-sorted end
    };
  };
}
