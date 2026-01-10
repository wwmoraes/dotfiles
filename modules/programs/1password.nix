{
  flake.modules.darwin.personal =
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

      programs.fish.shellAliases = {
        brew = "op plugin run -- brew";
        cachix = "op plugin run -- cachix";
        doctl = "op plugin run -- doctl";
        gh = "op plugin run -- gh";
        pulumi = "op plugin run -- pulumi";
      };
    };
}
