{
  config,
  lib,
  ...
}:
{
  programs.fish.interactiveShellInit = lib.mkIf config.programs.direnv.enable ''
    ## reload direnv now, otherwise it only triggers on dir change
    ${lib.getExe config.programs.direnv.package} reload 2> /dev/null; or true
  '';

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    silent = true;
  };
}
