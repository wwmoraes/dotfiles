{
  config,
  ...
}:
{
  programs.docker = {
    desktopSettings = {
      FilesharingDirectories = [
        "${config.home.homeDirectory}/dev"
        "/tmp"
      ];
    };
  };
}
