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
  flake.modules.generic.personal =
    {
      ...
    }:
    {
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

  flake.modules.homeManager.default =
    {
      lib,
      ...
    }:
    {
      programs.ssh = {
        enable = true;
        enableDefaultConfig = false;
        settings = {
          all = {
            header = "Host *";
            AddKeysToAgent = "no";
            Compression = true;
            ControlMaster = "auto";
            ControlPath = "~/.ssh/%r@%h:%p.sock";
            ControlPersist = "10m";
            ForwardAgent = false;
            HashKnownHosts = false;
            ServerAliveCountMax = 10;
            ServerAliveInterval = 60;
            UserKnownHostsFile = "~/.ssh/known_hosts";
          };
          git = lib.hm.dag.entryAfter [ "all" ] {
            header = "Host github.com bitbucket.org";
            User = "git";
          };
        };
      };
    };

  flake.modules.homeManager.personal =
    {
      ...
    }:
    {
      programs.ssh = {
        extraOptionOverrides = {
          AddressFamily = "inet"; # enable IPv6
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
      };
    };
}
