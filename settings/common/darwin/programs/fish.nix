{
  pkgs,
  ...
}:
{
  programs.fish = {
    babelfishPackage = pkgs.babelfish;
    enable = true;
    useBabelfish = true;
    vendor = {
      completions.enable = true;
      config.enable = true;
      functions.enable = true;
    };
  };
}
