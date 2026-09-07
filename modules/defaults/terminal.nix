{
  lib,
  ...
}:
{
  flake.modules.darwin.default = { pkgs, ... }: {
    system.defaults = {
      CustomUserPreferences = {
        "com.apple.Terminal" = {
          SecureKeyboardEntry = true;
          Shell = lib.getExe pkgs.fish;
          ShowLineMarks = 0;
          StringEncodings = [ "4" ];
        };
      };
    };
  };
}
