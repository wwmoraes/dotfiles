{
  flake.modules.generic.personal =
    {
      config,
      ...
    }:
    let
      inherit (config.networking) domain;
    in
    {
      networking.domain = "home.arpa";

      home-manager.sharedModules = [
        (
          {
            config,
            lib,
            ...
          }:
          {
            programs.ssh = {
              extraOptionOverrides.CanonicalDomains = domain;
              settings = {
                ${domain} = lib.hm.dag.entryAfter [ "all" ] {
                  header = "Host *.${domain}";
                  HostKeyAlgorithms = "+ssh-rsa";
                  PubkeyAcceptedKeyTypes = "+ssh-rsa";
                  RemoteForward = [
                    {
                      bind.address = "/run/user/0/gnupg/S.gpg-agent";
                      host.address = "${config.programs.gpg.homedir}/S.gpg-agent.extra";
                    }
                    {
                      bind.address = "/root/.gnupg/S.gpg-agent";
                      host.address = "${config.programs.gpg.homedir}/S.gpg-agent.extra";
                    }
                    {
                      bind.address = "/run/user/%i/gnupg/S.gpg-agent";
                      host.address = "${config.programs.gpg.homedir}/S.gpg-agent.extra";
                    }
                    {
                      # BUG home-manager path detection
                      # see https://github.com/nix-community/home-manager/blob/release-25.11/modules/programs/ssh.nix#L19
                      # TL;DR it does a naive check if the address starts with a
                      # slash; if not it wraps it as an IP(v6?) address
                      # bind.address = "\${GNUPGHOME}/S.gpg-agent";
                      # bind.address = "%d/.gnupg/S.gpg-agent";
                      # becomes, respectively:
                      #   [${GNUPGHOME}/S.gpg-agent]: /Users/william/.gnupg/S.gpg-agent.extra
                      #   [%d/.gnupg/S.gpg-agent]: /Users/william/.gnupg/S.gpg-agent.extra
                      # the fix should be either:
                      #   * flip the check to "isIP": detect IPv4/IPv6/DNS names
                      #   * make "isPath" less naive: deep path detection by
                      #     looking at the whole value to find any /, % or $
                      bind.address = "/home/%r/.gnupg/S.gpg-agent";
                      host.address = "${config.programs.gpg.homedir}/S.gpg-agent.extra";
                    }
                  ];
                };
                ap = lib.hm.dag.entryAfter [ domain ] {
                  header = "Host ap ap.${domain}";
                  User = "root";
                };
                gateway = lib.hm.dag.entryAfter [ domain ] {
                  header = "Host gateway gateway.${domain}";
                  User = lib.mkDefault config.home.username;
                };
                router = lib.hm.dag.entryAfter [ domain ] {
                  header = "Host router router.${domain}";
                  User = "root";
                };
              };
            };
          }
        )
      ];
    };
}
