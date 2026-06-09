{
  configurations.nixos.vidar = {
    contexts = [
      # keep-sorted start
      "personal"
      # keep-sorted end
    ];

    profiles = [
      # keep-sorted start
      "default"
      "gpg"
      "shell"
      # keep-sorted end
    ];

    users = {
      root = [ ];
      william = [ ];
    };

    systemModules = [
      # inputs.nixos-hardware.nixosModules.raspberry-pi-3
    ];

    module = ./_configuration.nix;
  };

  flake.modules.homeManager.personal =
    {
      config,
      ...
    }:
    {
      programs.ssh.matchBlocks."vidar vidar.home.arpa" = {
        extraOptions = {
          HostKeyAlgorithms = "+ssh-rsa";
          PubkeyAcceptedKeyTypes = "+ssh-rsa";
        };
        remoteForwards = [
          {
            bind.address = "/run/user/0/gnupg/S.gpg-agent";
            host.address = "${config.programs.gpg.homedir}/S.gpg-agent.extra";
          }
          {
            bind.address = "/run/user/1001/gnupg/S.gpg-agent";
            host.address = "${config.programs.gpg.homedir}/S.gpg-agent.extra";
          }
          {
            bind.address = "/home/william/.gnupg/S.gpg-agent";
            host.address = "${config.programs.gpg.homedir}/S.gpg-agent.extra";
          }
          {
            bind.address = "/root/.gnupg/S.gpg-agent";
            host.address = "${config.programs.gpg.homedir}/S.gpg-agent.extra";
          }
        ];
      };
    };
}
