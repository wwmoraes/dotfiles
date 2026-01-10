{
  flake.modules.homeManager.shell = {
    programs.bat = {
      enable = true;
      config = {
        tabs = "2";
      };
    };
  };
}
