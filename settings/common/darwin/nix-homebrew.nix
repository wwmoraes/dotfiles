{
  config,
  ...
}:
{
  nix-homebrew = {
    autoMigrate = true;
    enable = true;
    enableFishIntegration = false;
    enableRosetta = false;
    group = "staff";
    # mutableTaps = false;
    # taps = {
    #   "homebrew/homebrew-core" = homebrew-core;
    #   "homebrew/homebrew-cask" = homebrew-cask;
    # };
    user = config.system.primaryUser;
  };

  ## TODO fix upstream https://github.com/zhaofengli/nix-homebrew/blob/5108f0846cde2080aaeb1c7b08e3bd7d27f33b57/modules/default.nix#L503-L505
  programs.fish.interactiveShellInit = ''
    brew shellenv fish 2>/dev/null | source || true
  '';
}
