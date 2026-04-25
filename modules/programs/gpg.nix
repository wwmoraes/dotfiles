{
  flake.modules.homeManager.gpg =
    {
      config,
      # lib,
      ...
    }:
    {
      # home.activation.gpgCardSwitch = lib.hm.dag.entryAfter [ "importGpgKeys" "createGpgHomedir" ] (
      #   let
      #     gpgBin = lib.getExe config.programs.gpg.package;
      #     gpgconfBin = lib.getExe' config.programs.gpg.package "gpgconf";
      #   in
      #   ''
      #     export GNUPGHOME=${lib.escapeShellArg config.programs.gpg.homedir}

      #     for fingerprint in $(${gpgBin} --options /dev/null --card-status 2> /dev/null | grep -B1 "card-no:" | grep "ssb>" | cut -d"/" -f2 | cut -d" " -f1); do
      #       KEYGRIP=$(${gpgBin} --list-keys --with-keygrip --with-colons $fingerprint! | grep -A1 $fingerprint | grep '^grp:' | cut -d: -f10)
      #       run rm "$GNUPGHOME/private-keys-v1.d/$KEYGRIP.key" 2>/dev/null || true
      #     done

      #     run ${gpgconfBin} --kill gpg-agent || true
      #     run ${gpgBin} --card-status > /dev/null || true
      #   ''
      # );

      home.file."${config.programs.gpg.homedir}/dirmngr.conf".text = ''
        ## server that --recv-keys, --send-keys, and --search-keys will use
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
        ## unfortunately mailvelope key server supports only up to 20 subkeys :(
        # keyserver hkps://keys.mailvelope.com

        ## Keyserver proxy
        # keyserver-options http-proxy=http://127.0.0.1:8118
        # keyserver-options http-proxy=socks5-hostname://127.0.0.1:9050

        # debug-level guru
        # debug-all
        # log-file ${config.home.homeDirectory}/.cache/gpg/dirmngr.log
      '';

      programs = {
        gpg = {
          scdaemonSettings = {
            # avoids a problem where GnuPG repeatedly prompts to insert an already-inserted YubiKey
            disable-ccid = true;
          };
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
            cert-digest-algo = "SHA512"; # message digest algorithm used when signing a key
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
            keyid-format = "long";
            keyserver-options = [
              "honor-keyserver-url" # use a key's preferred keyserver URL, if present, on refresh
              "include-revoked"
            ];
            list-options = "show-uid-validity"; # display the calculated validity of user IDs during key listings
            no-comments = true; # disable comment string in clear text signatures and ASCII armored messages
            no-emit-version = true; # disable inclusion of the version string in ASCII armored output
            no-greeting = true; # disable copyright notice
            no-symkey-cache = true; # Disable caching of passphrase for symmetrical ops
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
            require-cross-certification = true; # verify subkeys are present and valid
            require-secmem = true; # Enforce memory locking to avoid accidentally swapping GPG memory to disk
            s2k-cipher-algo = "AES256"; # AES256 as cipher for symmetric ops
            s2k-digest-algo = "SHA512"; # SHA512 as digest for symmetric ops
            throw-keyids = true; # Disable recipient key ID in messages (WARNING: breaks Mailvelope)
            use-agent = true; # try to use the GnuPG-Agent before asking for a passphrase
            verify-options = "show-uid-validity"; # display the calculated validity of user IDs during key listings
            with-fingerprint = true;
            with-key-origin = true;
            with-keygrip = true;
            with-subkey-fingerprint = true;
            with-wkd-hash = true; # list keys with their WKD user ID hashes
          };
        };
        ssh = {
          extraOptionOverrides = {
            IdentityAgent = "${config.programs.gpg.homedir}/S.gpg-agent.ssh";
          };
        };
      };

      services.gpg-agent = {
        enable = true;
        defaultCacheTtl = 300;
        defaultCacheTtlSsh = 300;
        enableScDaemon = true;
        enableSshSupport = true;
        maxCacheTtl = 3600;
        maxCacheTtlSsh = 3600;
        # noAllowExternalCache = true;
        extraConfig = ''
          pinentry-timeout 30
        '';
      };
    };

  # TODO refactor implication order to HM -> OS (allows activating per-user)
  flake.modules.darwin.gpg = {
    home-manager.sharedModules = [
      (
        {
          config,
          lib,
          pkgs,
          ...
        }:
        {
          launchd.agents = {
            gpg-agent = {
              enable = true;
              config = {
                ProgramArguments = lib.mkForce (
                  [
                    # "/bin/sh"
                    # "-c"
                    # "${gpgconf} --kill gpg-agent; exec ${gpg-agent} --daemon" # upstream --supervised not supported in Darwin
                    # gpg-agent
                    # "--daemon" # upstream --supervised not supported in Darwin
                    (lib.getExe' config.programs.gpg.package "gpg-connect-agent")
                  ]
                  ++ lib.optional config.services.gpg-agent.verbose "--verbose"
                  ++ [
                    "/bye"
                  ]
                );
                # configure as a one-off launch instead of daemon; mostly useful so the
                # retards from CISO @ work won't complain about an "unknown daemon" 🙄
                # KeepAlive = lib.mkForce false;
                KeepAlive = lib.mkForce {
                  SuccessfulExit = false;
                  Crashed = true;
                };
                Sockets = {
                  Agent = {
                    SockPassive = false;
                    SockPathName = lib.mkForce "${config.programs.gpg.homedir}/S.gpg-agent";
                  };
                  Extra = {
                    SockPassive = false;
                    SockPathName = lib.mkForce "${config.programs.gpg.homedir}/S.gpg-agent.extra";
                  };
                  Ssh = {
                    SockPassive = false;
                    SockPathName = lib.mkForce "${config.programs.gpg.homedir}/S.gpg-agent.ssh";
                  };
                };
                StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/${config.launchd.agents.gpg-agent.config.Label}.err.log";
                StandardOutPath = "${config.home.homeDirectory}/Library/Logs/${config.launchd.agents.gpg-agent.config.Label}.out.log";
              };
            };
            gpg-card-switch = {
              enable = false;
              config = {
                Label = "dev.artero.gpg-card-switch";
                LaunchEvents = {
                  "com.apple.iokit.matching" = {
                    "com.apple.device-attach" = {
                      IOMatchStream = true;
                      IOMatchLaunchStream = true;
                      IOProviderClass = "IOUSBDevice";
                      ## echo "ibase=16; 1050" | bc
                      # idProduct = 1031; # 0x407
                      idProduct = "*"; # 0x407
                      idVendor = 4176; # 0x1050
                    };
                  };
                };
                ProgramArguments = [
                  ## TODO https://github.com/snosrap/xpc_set_event_stream_handler
                  # "/usr/local/bin/xpc_set_event_stream_handler"
                  "${lib.getExe pkgs.gnupg}"
                  "--card-status"
                ];
              };
            };
          };

          services.gpg-agent.pinentry = {
            package = pkgs.pinentry_mac;
            program = "pinentry-mac";
          };
        }
      )
    ];
  };

  flake.modules.nixos.gpg =
    {
      config,
      lib,
      ...
    }:
    let
      gpgconf = lib.getExe' config.programs.gnupg.package "gpgconf";
    in
    {
      environment.shellInit = ''
        ${gpgconf} --kill gpg-agent || true
        ${gpgconf} --create-socketdir 2>&1 >/dev/null || true
      '';
    };
}
