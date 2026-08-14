{ lib, ... }: {
  flake.modules.homeManager.default = { config, pkgs, ... }: {
    programs.helix.extraPackages = lib.optionals config.programs.jq.enable [
      pkgs.jq-lsp
    ];
  };
}
