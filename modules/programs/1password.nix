{
  lib,
  ...
}:
{
  nixpkgs.config.allowUnfreePackages = [
    "1password"
    "1password-cli"
  ];

  flake.modules.generic.default =
    {
      config,
      ...
    }:
    let
      shellAliases = lib.genAttrs [
        "brew"
        "cachix"
        "gh"
      ] (name: "op plugin run -- " + name);
    in
    {
      environment.shellAliases = shellAliases;

      home-manager.sharedModules = lib.optional config.programs._1password.enable {
        home.shellAliases = shellAliases;
      };
    };

  flake.modules.darwin.default =
    {
      config,
      ...
    }:
    {
      config = lib.mkIf config.programs._1password-gui.enable {
        homebrew.masApps = {
          "1Password for Safari" = 1569813296;
        };

        home-manager.sharedModules = [
          {
            targets.darwin.defaults = {
              "com.apple.Safari" = {
                AutoFillFromiCloudKeychain = false;
                AutoFillPasswords = true;
              };
              "com.1password.1password.autofill-extension" = {
                didEnableInSystemSettings = true;
              };
            };
          }
        ];
      };
    };
}
