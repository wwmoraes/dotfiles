{
  config,
  lib,
  pkgs,
  ...
}:
{
  home.file = {
    "${config.programs.gpg.homedir}/dirmngr.conf" = {
      enable = true;
      text = ''
        allow-version-check

        keyserver hkps://keys.openpgp.org
        keyserver hkp://zkaan2xfbuxia2wpf7ofnkbz6r5zdbbvxbunvp5g2iebopbfc4iqmbad.onion
        keyserver hkps://keyserver.pgp.com
        keyserver hkps://keyserver.ubuntu.com
        keyserver hkps://pgp-servers.net
        keyserver hkps://pgp.circl.lu
        keyserver hkps://pgp.id
        keyserver hkps://pgp.mit.edu
        keyserver hkps://pgp.surf.nl
        keyserver hkps://pgpkeys.eu
      '';
    };
  };

  home.sessionVariables.SSH_AUTH_SOCK = "${config.programs.gpg.homedir}/S.gpg-agent.ssh";

  programs.gpg = {
    enable = true;

    scdaemonSettings = {
      ## avoids a problem where GnuPG repeatedly prompts to insert an already-inserted YubiKey
      disable-ccid = true;
    };

    ## TODO get key ID from a variable
    settings = {
      armor = true;
      auto-key-locate = builtins.concatStringsSep " " [
        "clear"
        "wkd"
        "dane"
        "pka"
        "cert"
        "local"
        "nodefault"
      ];
      auto-key-retrieve = true;
      cert-digest-algo = "SHA512";
      default-new-key-algo = "ed25519/cert";
      default-preference-list = builtins.concatStringsSep " " [
        "SHA512"
        "SHA384"
        "SHA256"
        "AES256"
        "AES192"
        "AES"
        "ZLIB"
        "BZIP2"
        "ZIP"
        "Uncompressed"
      ];
      display-charset = "utf-8";
      keyid-format = "long";
      keyserver-options = builtins.concatStringsSep " " [
        "honor-keyserver-url"
        "include-revoked"
      ];
      list-options = builtins.concatStringsSep " " [
        "show-uid-validity"
        # "show-unusable-subkeys"
      ];
      no-comments = true;
      no-emit-version = true;
      no-greeting = true;
      no-symkey-cache = true;
      personal-cipher-preferences = builtins.concatStringsSep " " [
        "AES256"
        "AES192"
        "AES"
      ];
      personal-compress-preferences = builtins.concatStringsSep " " [
        "ZLIB"
        "BZIP2"
        "ZIP"
        "Uncompressed"
      ];
      personal-digest-preferences = builtins.concatStringsSep " " [
        "SHA512"
        "SHA384"
        "SHA256"
      ];
      pinentry-mode = "ask";
      require-cross-certification = true;
      require-secmem = true;
      s2k-cipher-algo = "AES256";
      s2k-digest-algo = "SHA512";
      throw-keyids = true;
      tofu-default-policy = "unknown";
      trust-model = "tofu+pgp";
      verbose = false;
      verify-options = "show-uid-validity";
      with-fingerprint = true;
      with-key-origin = true;
      with-keygrip = true;
      with-secret = false;
      with-sig-check = false;
      with-subkey-fingerprint = true;
      with-wkd-hash = true;
    };
  };

  services.gpg-agent = {
    enable = true;
    enableFishIntegration = true;

    defaultCacheTtl = 60;
    defaultCacheTtlSsh = 60;
    enableExtraSocket = lib.mkDefault true;
    enableSshSupport = lib.mkDefault true;
    grabKeyboardAndMouse = true;
    maxCacheTtl = 120;
    maxCacheTtlSsh = 120;
    noAllowExternalCache = true;

    pinentry = {
      package = lib.mkDefault pkgs.pinentry-tty;
      program = lib.mkDefault "pinentry-tty";
    };
  };
}
