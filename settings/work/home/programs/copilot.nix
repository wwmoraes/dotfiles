{
  lib,
  pkgs,
  ...
}:
{
  home.packages = [
    pkgs.gh-copilot
  ];

  programs.helix = {
    extraPackages = [
      pkgs.copilot-language-server
    ];

    languages.language-server = {
      copilot = {
        command = "copilot-language-server";
      };
    };

    languageSettings = {
      go = {
        language-servers = lib.mkAfter [
          "copilot"
        ];
      };
    };
  };
}
