{
  config,
  ...
}:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

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
      "*" = {
        addKeysToAgent = "no";
        compression = true;
        controlMaster = "auto";
        controlPath = "~/.ssh/%r@%h:%p.sock";
        controlPersist = "10m";
        forwardAgent = false;
        hashKnownHosts = false;
        serverAliveCountMax = 10;
        serverAliveInterval = 60;
        userKnownHostsFile = "~/.ssh/known_hosts";
      };
      "github.com bitbucket.org" = {
        user = "git";
      };
    };
  };
}
