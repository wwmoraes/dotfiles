{
  lib,
  ...
}:
let
  # based on https://github.com/NixOS/nixpkgs/blob/nixos-26.05/nixos/modules/config/nix-remote-build.nix#L31-L67
  buildMachinesForNixVersion =
    nixPackage: machines:
    let
      inherit (lib)
        concatMapStrings
        concatStringsSep
        optionalString
        optional
        ;
      isNixAtLeast = lib.versionAtLeast (lib.getVersion nixPackage);
    in
    concatMapStrings (
      machine:
      (concatStringsSep " " (
        [
          "${optionalString (machine.protocol != null) "${machine.protocol}://"}${
            optionalString (machine.sshUser != null) "${machine.sshUser}@"
          }${machine.hostName}"
          (
            if machine.system != null then
              machine.system
            else if machine.systems != [ ] then
              concatStringsSep "," machine.systems
            else
              "-"
          )
          (if machine.sshKey != null then machine.sshKey else "-")
          (toString machine.maxJobs)
          (toString machine.speedFactor)
          (
            let
              res = machine.supportedFeatures ++ machine.mandatoryFeatures;
            in
            if (res == [ ]) then "-" else (concatStringsSep "," res)
          )
          (
            let
              res = machine.mandatoryFeatures;
            in
            if (res == [ ]) then "-" else (concatStringsSep "," machine.mandatoryFeatures)
          )
        ]
        ++ optional (isNixAtLeast "2.4pre") (
          if machine.publicHostKey != null then machine.publicHostKey else "-"
        )
      ))
      + "; "
    ) machines;
in
{
  flake-file.nixConfig = {
    builders = "ssh-ng://root@vidar aarch64-linux - - - big-parallel,kvm; ssh-ng://root@nas x86_64-linux - - - big-parallel,kvm";
    builders-use-substitutes = true;
  };

  flake.modules.generic.default =
    {
      config,
      ...
    }:
    {
      environment.etc."nix/machines".enable = lib.mkForce false;

      nix = {
        distributedBuilds = true;
        settings = {
          # needed due to distributedBuilds issues
          # see https://github.com/NixOS/nix/issues/5288
          builders = lib.mkForce (buildMachinesForNixVersion config.nix.package config.nix.buildMachines);
          builders-use-substitutes = true;
        };
      };
    };

  flake.modules.darwin.personal = {
    # nix.linux-builder.enable = true;
    # nix.linux-builder.systems = lib.intersectLists lib.platforms.linux (
    #   lib.platforms.aarch64 ++ lib.platforms.x86_64
    # );

    nix.buildMachines = [
      {
        hostName = "vidar";
        maxJobs = 4;
        protocol = "ssh-ng";
        sshUser = "root";
        supportedFeatures = [
          "benchmark"
          "big-parallel"
          "kvm"
          "nixos-test"
        ];
        system = "aarch64-linux";
      }
      {
        hostName = "nas";
        maxJobs = 4;
        protocol = "ssh-ng";
        sshUser = "root";
        supportedFeatures = [
          "benchmark"
          "big-parallel"
          "kvm"
          "nixos-test"
        ];
        system = "x86_64-linux";
      }
    ];
  };
}
