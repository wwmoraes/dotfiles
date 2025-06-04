{
  lib,
  config,
  pkgs,
  ...
}:
{
  programs.helix.extraPackages = lib.optionals config.programs.jq.enable [
    pkgs.jq-lsp
  ];

  programs.jq = {
    enable = true;
  };
}
