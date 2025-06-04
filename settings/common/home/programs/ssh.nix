{
  config,
  ...
}:
{
  programs.ssh = {
    enable = true;

    addKeysToAgent = "no";
    compression = true;
    controlMaster = "auto";
    controlPath = "~/.ssh/master-%r@%h:%p";
    controlPersist = "10m";
    serverAliveCountMax = 10;
    serverAliveInterval = 60;

    extraOptionOverrides = {
      AddressFamily = "inet";
      HostKeyAlgorithms = "+ssh-rsa";
      IdentityAgent = "${config.programs.gpg.homedir}/S.gpg-agent.ssh";
      IgnoreUnknown = "UseKeychain,AddKeysToAgent";
      PreferredAuthentications = "publickey";
      Protocol = "2";
      PubkeyAcceptedKeyTypes = "+ssh-rsa";
      TCPKeepAlive = "yes";
      UseKeychain = "no";
    };

    matchBlocks = {
      "github.com bitbucket.org" = {
        user = "git";
      };
    };
  };
}
