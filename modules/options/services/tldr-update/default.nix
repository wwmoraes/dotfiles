{
  flake.modules.darwin.default = {
    home-manager.sharedModules = [
      {
        disabledModules = [
          "services/tldr-update.nix"
        ];

        imports = [
          ./_module.nix
        ];
      }
    ];
  };
}
