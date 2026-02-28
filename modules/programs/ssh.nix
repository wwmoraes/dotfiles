let
  IgnoreUnknown = [
    "AddKeysToAgent"
    "PubkeyAcceptedAlgorithms"
    "UseKeychain"
  ];
  ## https://blog.stribik.technology/2015/01/04/secure-secure-shell.html
  ## ssh -Q cipher
  Ciphers = [
    "chacha20-poly1305@openssh.com"
    "aes256-gcm@openssh.com"
    "aes128-gcm@openssh.com"
    "aes256-ctr"
    "aes192-ctr"
    "aes128-ctr"
  ];
  ## ssh -Q kex
  KexAlgorithms = [
    "mlkem768x25519-sha256"
    "sntrup761x25519-sha512"
    "sntrup761x25519-sha512@openssh.com"
    "curve25519-sha256"
    "curve25519-sha256@libssh.org"
    "diffie-hellman-group-exchange-sha256"
  ];
  ## ssh -Q mac
  MACs = [
    "hmac-sha2-512-etm@openssh.com"
    "hmac-sha2-256-etm@openssh.com"
    "umac-128-etm@openssh.com"
  ];
  ## ssh -Q key
  HostKeyAlgorithms = [
    "ssh-ed25519"
    "ssh-ed25519-cert-v01@openssh.com"
    "ssh-rsa"
    "ssh-rsa-cert-v01@openssh.com"
  ];
  PubkeyAcceptedAlgorithms = [
    "ssh-ed25519"
    "rsa-sha2-512"
    "rsa-sha2-256"
    # "ssh-ed25519-cert-v01@openssh.com"
    # "ssh-rsa"
    # "ssh-rsa-cert-v01@openssh.com"
  ];
in
{
  flake.modules.generic.personal = {
    programs.ssh = {
      ciphers = Ciphers;
      hostKeyAlgorithms = HostKeyAlgorithms;
      kexAlgorithms = KexAlgorithms;
      macs = MACs;
      pubkeyAcceptedKeyTypes = PubkeyAcceptedAlgorithms;
      extraConfig = ''
        IgnoreUnknown ${builtins.concatStringsSep "," IgnoreUnknown}
        WarnWeakCrypto yes
      '';
    };

    services.openssh.settings = {
      inherit Ciphers KexAlgorithms;
      Macs = MACs;
    };
  };

  flake.modules.homeManager.default = {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
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
          AddressFamily = "inet"; # enable IPv6
          CanonicalDomains = "home.arpa";
          CanonicalizeHostname = "yes";
          CanonicalizeMaxDots = "0";
          Ciphers = builtins.concatStringsSep "," Ciphers;
          HostKeyAlgorithms = builtins.concatStringsSep "," HostKeyAlgorithms;
          IgnoreUnknown = builtins.concatStringsSep "," IgnoreUnknown;
          KexAlgorithms = builtins.concatStringsSep "," KexAlgorithms;
          MACs = builtins.concatStringsSep "," MACs;
          PreferredAuthentications = "publickey";
          Protocol = "2";
          PubkeyAcceptedAlgorithms = builtins.concatStringsSep "," PubkeyAcceptedAlgorithms;
          PubkeyAcceptedKeyTypes = builtins.concatStringsSep "," PubkeyAcceptedAlgorithms;
          TCPKeepAlive = "yes";
          UseKeychain = "no";
          WarnWeakCrypto = "yes";
        };

        matchBlocks = {
          "*.home.arpa" = {
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
            extraOptions = {
              HostKeyAlgorithms = "+ssh-rsa";
              PubkeyAcceptedKeyTypes = "+ssh-rsa";
            };
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
