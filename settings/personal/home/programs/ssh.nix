{
  programs.ssh = {
    matchBlocks = {
      ## https://blog.stribik.technology/2015/01/04/secure-secure-shell.html
      "*.home.arpa" = {
        extraOptions = {
          CanonicalizeHostname = "yes";
          CanonicalDomains = "home.arpa";
          CanonicalizeMaxDots = "0";
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
      };

      "router router.home.arpa" = {
        user = "root";
      };
    };
  };
}
