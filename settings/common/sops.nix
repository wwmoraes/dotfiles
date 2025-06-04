{
  config,
  ...
}:
{
  sops = {
    age = {
      sshKeyPaths = [ ];
      generateKey = false;
    };
    defaultSopsFile = ../../secrets.yaml;
    gnupg = {
      home = config.home-manager.users.${config.system.primaryUser}.programs.gpg.homedir;
      sshKeyPaths = [ ];
    };
  };
}
