{
  flake.modules.homeManager.default = {
    programs.delta = {
      enableGitIntegration = true;
      options = {
        dark = true;
        light = false;
        line-numbers = true;
        navigate = true;
        syntax-theme = "base16-stylix";
        tabs = 2;
      };
    };
  };
}
