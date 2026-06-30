{
  inputs,
  lib,
  ...
}:
{
  flake.nixosModules.lenovo-ideapad-310 =
    {
      ...
    }:
    {
      imports = [
        inputs.nixos-hardware.nixosModules.common-cpu-intel
      ];

      boot.extraModprobeConfig = ''
        # Intel HD Graphics 520 options
        #
        # see https://gist.github.com/Brainiarc7/aa43570f512906e882ad6cdd835efe57
        # see https://wiki.archlinux.org/title/Intel_graphics

        # enables GuC submission and HuC load
        # GuC (Graphics micro (μ) Controller) submission: uses GuC for scheduling, context submission, and power management
        # HuC (HEVC/H.265 micro (µ) Controller) load: offloads some media decoding functionality from the CPU
        options i915 enable_guc=3

        # enable frame buffer compression power savings
        options i915 enable_fbc=1

        # enables Panel Self Refresh-Selectively Updated (PSR2) to decrease GPU power consumption
        options i915 enable_psr=2

        # enables power-saving display C-states (up to DC6 with DC3C0)
        options i915 enable_dc=4
      '';

      hardware = {
        # done by the nixos-generate-config @ hardware-configuration.nix already
        # cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
        enableRedistributableFirmware = lib.mkDefault true;
        i2c.enable = lib.mkDefault true; # Touchpad
        # VP9 decoding not supported when using intel-media-driver
        # https://github.com/intel/media-driver/issues/1024
        # NixOS Wiki recommends using the legacy intel-vaapi-driver with the hybrid codec over that one for Skylake.
        # https://wiki.nixos.org/wiki/Accelerated_Video_Playback
        intelgpu = {
          computeRuntime = "legacy";
          vaapiDriver = "intel-vaapi-driver";
          enableHybridCodec = true;
        };
      };

      services = {
        hdapsd.enable = lib.mkDefault true; # Hard disk protection if the laptop falls
        thermald.enable = lib.mkDefault true; # it's an Intel CPU after all ¯\_(ツ)_/¯
      };

      # systemd.sleep.settings.Sleep.HibernateMode = "shutdown";
    };
}
