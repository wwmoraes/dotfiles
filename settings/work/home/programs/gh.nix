{
  lib,
  ...
}:
{
  programs.gh = {
    settings = {
      ## thank you CISO...
      git_protocol = lib.mkForce "https";
    };
  };
}
