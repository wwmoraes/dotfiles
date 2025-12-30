{
  programs.helix = {
    ignores = [
      "!.env*"
      "!*.env"
    ];

    languageSettings.env = {
      file-types = [
        { glob = ".*.env"; }
        { glob = ".env"; }
      ];
    };
  };
}
