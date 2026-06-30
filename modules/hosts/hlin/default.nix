{
  self,
  ...
}:
{
  configurations.nixos.hlin = {
    contexts = [
      # keep-sorted start
      "personal"
      # keep-sorted end
    ];

    profiles = [
      # keep-sorted start
      "default"
      # "secure-boot"
      # "gpg"
      # "hardening"
      # "media-server"
      # "nas"
      "shell"
      # "scm"
      # "nas-client"
      # keep-sorted end
    ];

    users = {
      root = [ ];
      william = [ ];
    };

    systemModules = [
      # keep-sorted start
      self.nixosModules.lenovo-ideapad-310
      # keep-sorted end
    ];

    module = ./_configuration.nix;
  };
}
