{
  lib,
  pkgs,
  ...
}:
{
  security.pam.services.sudo_local = {
    enable = true;
    reattach = true;
    touchIdAuth = true;
    # watchIdAuth = true;
    text = lib.mkMerge [
      (lib.mkAfter ''auth       sufficient     ${pkgs.pam_u2f}/lib/security/pam_u2f.so authfile=/etc/u2f_mappings cue'')
    ];
  };
}
