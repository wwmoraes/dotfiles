{
  config,
  ...
}:
{
  home.sessionVariables = {
    PROJECTS_DIR = "${config.home.homeDirectory}/dev";
  };
}
