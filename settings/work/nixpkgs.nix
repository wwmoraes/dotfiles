{
  lib,
  ...
}:
{
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      # keep-sorted start
      "copilot-language-server"
      "gh-copilot"
      # keep-sorted end
    ];

}
