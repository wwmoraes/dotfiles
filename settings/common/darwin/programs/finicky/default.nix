{
  home-manager.sharedModules = [
    {
      home.file.".finicky.js" = {
        source = ./finicky.js;
      };
    }
  ];

  homebrew.casks = [
    "finicky"
  ];
}
