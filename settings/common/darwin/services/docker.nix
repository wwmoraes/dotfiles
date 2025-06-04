{
  services.docker = {
    enable = true;
    settings = {
      builder = {
        features = {
          buildkit = true;
        };
        gc = {
          defaultKeepStorage = "20GB";
          enabled = true;
        };
      };
      debug = false;
      experimental = false;
    };
  };
}
