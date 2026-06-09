{
  self,
  ...
}:
{
  configurations.nixos.folkvangr = {
    contexts = [
      # keep-sorted start
      "personal"
      # keep-sorted end
    ];

    profiles = [
      # keep-sorted start
      "default"
      "secure-boot"
      # "gpg"
      # "hardening"
      # "media-server"
      # "nas"
      "shell"
      # keep-sorted end
    ];

    users = {
      root = [ ];
      william = [ ];
    };

    systemModules = [
      # keep-sorted start
      self.nixosModules.minisforum-ms-r1
      # keep-sorted end
    ];

    module = ./_configuration.nix;
  };
}
