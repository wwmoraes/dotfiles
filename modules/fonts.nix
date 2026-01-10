{
  flake.modules.generic.default =
    {
      pkgs,
      ...
    }:
    {
      fonts.packages = [
        pkgs.comfortaa
        pkgs.fira-code
        pkgs.fira-code-symbols
        pkgs.montserrat
        pkgs.nerd-fonts.fira-code
        pkgs.powerline-fonts
        pkgs.powerline-symbols
        pkgs.source-code-pro
      ];
    };

  flake.modules.darwin.default = {
    system.activationScripts.postActivation.text = ''
      printf >&2 "refreshing font database...\n"
      atsutil databases -removeUser 2> /dev/null
      sudo atsutil databases -remove 2> /dev/null

      printf >&2 "reloading font daemon...\n"
      killall fontd 2> /dev/null || true
    '';
  };

  flake.modules.nixos.default =
    {
      lib,
      pkgs,
      ...
    }:
    {
      environment.systemPackages = [
        pkgs.fontconfig
      ];

      system.activationScripts.fontCache = {
        deps = [
          "groups"
          "specialfs"
          "users"
        ];
        text = ''
          printf >&2 "Updating font cache...\n"
          ${lib.getExe' pkgs.fontconfig "fc-cache"} -f || true
        '';
      };
    };
}
