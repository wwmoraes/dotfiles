{
  flake.modules.darwin.personal = {
    networking.applicationFirewall = {
      enable = true;

      allowSigned = true;
      allowSignedApp = true;
      enableStealthMode = true;
    };
  };
}
