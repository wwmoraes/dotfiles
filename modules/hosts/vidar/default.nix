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
}
