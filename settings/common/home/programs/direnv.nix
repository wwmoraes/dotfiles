{
  config,
  lib,
  ...
}:
{
  programs.fish.interactiveShellInit = lib.mkIf config.programs.direnv.enable (
    lib.mkMerge [
      (lib.mkBefore ''
        # force a clean environment on load
        eval (pushd /; ${lib.getExe config.programs.direnv.package} export fish; popd)
      '')
    ]
  );

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    silent = true;
  };
}
