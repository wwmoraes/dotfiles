{
  lib,
  ...
}:
{
  programs.gh = {
    extensions = [
      # pkgs.gh-copilot ## thank you CISO for blocking it...
    ];
    settings = {
      ## thank you CISO...
      git_protocol = lib.mkForce "https";
    };
  };
}
