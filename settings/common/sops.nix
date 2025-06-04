{
  config,
  ...
}:
{
  # TODO https://github.com/Mic92/sops-nix?tab=readme-ov-file#qubes-split-gpg-support
  sops = {
    age = {
      sshKeyPaths = [ ];
      generateKey = false;
    };
    defaultSopsFile = ../../secrets.yaml;
    gnupg = {
      sshKeyPaths = [ ];
      home = config.home-manager.users.william.programs.gpg.homedir;
    };
  };
}
