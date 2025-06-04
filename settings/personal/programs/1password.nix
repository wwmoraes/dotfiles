{
  pkgs,
  ...
}:
{
  homebrew.casks = [
    (pkgs.lib.local.globalCask "1password")
    "1password-cli"
  ];

  homebrew.masApps = {
    "1Password for Safari" = 1569813296;
  };
}
