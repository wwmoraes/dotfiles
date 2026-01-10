{
  flake.modules.homeManager.default = {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;

      extraOptionOverrides = {
        AddressFamily = "inet";
        HostKeyAlgorithms = "+ssh-rsa";
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
  };

  flake.modules.homeManager.personal =
    {
      config,
      ...
    }:
    {
      programs.ssh = {
        extraOptionOverrides = {
          CanonicalDomains = "home.arpa";
          CanonicalizeHostname = "yes";
          CanonicalizeMaxDots = "0";
        };

        matchBlocks = {
          ## https://blog.stribik.technology/2015/01/04/secure-secure-shell.html
          "*.home.arpa" = {
            extraOptions = {
              ## ssh -Q cipher
              Ciphers = builtins.concatStringsSep "," [
                "chacha20-poly1305@openssh.com"
                "aes256-gcm@openssh.com"
                "aes128-gcm@openssh.com"
                "aes256-ctr"
                "aes192-ctr"
                "aes128-ctr"
              ];
              ## ssh -Q kex
              KexAlgorithms = builtins.concatStringsSep "," [
                "curve25519-sha256@libssh.org"
                "diffie-hellman-group-exchange-sha256"
              ];
              ## ssh -Q mac
              MACs = builtins.concatStringsSep "," [
                "hmac-sha2-512-etm@openssh.com"
                "hmac-sha2-256-etm@openssh.com"
                "umac-128-etm@openssh.com"
                "hmac-sha2-512"
                "hmac-sha2-256"
                "umac-128@openssh.com"
              ];
              ## ssh -Q key
              HostKeyAlgorithms = builtins.concatStringsSep "," [
                "ssh-ed25519-cert-v01@openssh.com"
                "ssh-rsa-cert-v01@openssh.com"
                "ssh-ed25519"
                "ssh-rsa"
              ];
              PubkeyAcceptedKeyTypes = builtins.concatStringsSep "," [
                "ssh-ed25519-cert-v01@openssh.com"
                "ssh-rsa-cert-v01@openssh.com"
                "ssh-ed25519"
                "ssh-rsa"
              ];
            };
            sendEnv = [
              "ZELLIJ"
            ];
          };
          "ap ap.home.arpa" = {
            user = "root";
          };
          "router router.home.arpa" = {
            user = "root";
          };
          "vidar vidar.home.arpa" = {
            remoteForwards = [
              {
                bind.address = "/run/user/1001/gnupg/S.gpg-agent";
                host.address = "${config.programs.gpg.homedir}/S.gpg-agent.extra";
              }
              {
                # bind.address = "/root/.gnupg/S.gpg-agent";
                bind.address = "/run/user/0/gnupg/S.gpg-agent";
                host.address = "${config.programs.gpg.homedir}/S.gpg-agent.extra";
              }
            ];
          };
        };
      };
    };

  flake.modules.homeManager.william'work = {
    programs.ssh = {
      matchBlocks = {
        "cocodev cocodev.pcs.nl.eu.abnamro.com" = {
          hostname = "cocodev.pcs.nl.eu.abnamro.com";
          user = "c82334";
        };
      };
    };
  };
}
