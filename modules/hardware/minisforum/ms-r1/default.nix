{
  self,
  ...
}:
{
  flake.nixosModules.minisforum-ms-r1 =
    {
      config,
      ...
    }:
    {
      imports = [
        self.nixosModules.mt7922
      ];

      boot = {
        extraModulePackages = with config.boot.kernelPackages; [
          r8127
        ];
        kernelParams = [
          "clk_ignore_unused" # see https://github.com/cixtech/cix-linux-main/blob/main/README.md
        ];
        # see https://github.com/cixtech/cix-linux-main/tree/main/patches-6.18
        # kernelPatches = [
        #   {
        #     name = "mailbox-add-acpi-support-to-cix-mailbox-driver";
        #     patch = ./patches/0001-mailbox-add-acpi-support-to-cix-mailbox-driver.patch;
        #   }
        #   {
        #     name = "acpi-Add-a-property-reference-count-interface";
        #     patch = ./patches/0002-acpi-Add-a-property-reference-count-interface.patch;
        #   }
        #   {
        #     name = "firmware-arm_scmi-add-acpi-support-to-SCMI";
        #     patch = ./patches/0003-firmware-arm_scmi-add-acpi-support-to-SCMI.patch;
        #   }
        #   {
        #     name = "clk-clk-scmi-register-clkdev-for-acpi";
        #     patch = ./patches/0004-clk-clk-scmi-register-clkdev-for-acpi.patch;
        #   }
        #   {
        #     name = "clk-add-cix-clk-driver";
        #     patch = ./patches/0005-clk-add-cix-clk-driver.patch;
        #   }
        #   {
        #     name = "reset-add-cix-reset-driver";
        #     patch = ./patches/0006-reset-add-cix-reset-driver.patch;
        #   }
        #   {
        #     name = "soc-add-cix-acpi-resource-lookup-driver";
        #     patch = ./patches/0007-soc-add-cix-acpi-resource-lookup-driver.patch;
        #   }
        #   {
        #     name = "pmdomain-add-acpi-support-to-cix-soc";
        #     patch = ./patches/0008-pmdomain-add-acpi-support-to-cix-soc.patch;
        #   }
        #   {
        #     name = "remoteproc-add-cix-dsp-remoteproc-driver";
        #     patch = ./patches/0009-remoteproc-add-cix-dsp-remoteproc-driver.patch;
        #   }
        #   {
        #     name = "drm-add-cix-linlon-dp-driver";
        #     patch = ./patches/0010-drm-add-cix-linlon-dp-driver.patch;
        #   }
        #   {
        #     name = "drm-panthor-add-acpi-support-for-cix-p1";
        #     patch = ./patches/0011-drm-panthor-add-acpi-support-for-cix-p1.patch;
        #   }
        #   {
        #     name = "irqchip-add-cix-sky1-pdc-driver";
        #     patch = ./patches/0012-irqchip-add-cix-sky1-pdc-driver.patch;
        #   }
        #   {
        #     name = "sound-hda-add-cix-ipbloq-hda-driver";
        #     patch = ./patches/0013-sound-hda-add-cix-ipbloq-hda-driver.patch;
        #   }
        #   {
        #     name = "kernel-dma-Export-dma_declare_coherent_memory-for-mo";
        #     patch = ./patches/0014-kernel-dma-Export-dma_declare_coherent_memory-for-mo.patch;
        #   }
        #   {
        #     name = "mfd-syscon-add-acpi-support-for-cix-soc";
        #     patch = ./patches/0015-mfd-syscon-add-acpi-support-for-cix-soc.patch;
        #   }
        #   {
        #     name = "dma-arm-dma350-add-acpi-support-for-cix-soc";
        #     patch = ./patches/0016-dma-arm-dma350-add-acpi-support-for-cix-soc.patch;
        #   }
        #   {
        #     name = "gpio-add-acpi-support-to-cadence-driver";
        #     patch = ./patches/0017-gpio-add-acpi-support-to-cadence-driver.patch;
        #   }
        #   {
        #     name = "clk-clkdev-increase-clkdev-MAX_CON_ID-from-16-to-32";
        #     patch = ./patches/0018-clk-clkdev-increase-clkdev-MAX_CON_ID-from-16-to-32.patch;
        #   }
        #   {
        #     name = "i2c-add-acpi-support-for-cadence-driver";
        #     patch = ./patches/0019-i2c-add-acpi-support-for-cadence-driver.patch;
        #   }
        #   {
        #     name = "firmware-add-cix-dsp-ipc-driver";
        #     patch = ./patches/0020-firmware-add-cix-dsp-ipc-driver.patch;
        #   }
        #   {
        #     name = "sound-soc-add-cix-sof-driver";
        #     patch = ./patches/0021-sound-soc-add-cix-sof-driver.patch;
        #   }
        #   {
        #     name = "sound-soc-add-cix-soc-support";
        #     patch = ./patches/0022-sound-soc-add-cix-soc-support.patch;
        #   }
        #   {
        #     name = "syscon-add-device_syscon_regmap_lookup_by_property";
        #     patch = ./patches/0023-syscon-add-device_syscon_regmap_lookup_by_property.patch;
        #   }
        #   {
        #     name = "phy-add-cix-phy-driver";
        #     patch = ./patches/0024-phy-add-cix-phy-driver.patch;
        #   }
        #   {
        #     name = "usb-add-usb-cdns3-driver-for-cix-soc";
        #     patch = ./patches/0025-usb-add-usb-cdns3-driver-for-cix-soc.patch;
        #   }
        #   {
        #     name = "typec-add-rts5453-driver";
        #     patch = ./patches/0026-typec-add-rts5453-driver.patch;
        #   }
        #   {
        #     name = "soc-add-cix-acpi-usb-scan-handler";
        #     patch = ./patches/0027-soc-add-cix-acpi-usb-scan-handler.patch;
        #   }
        #   {
        #     name = "pwm-add-pwm-support-for-CIX-SoC";
        #     patch = ./patches/0028-pwm-add-pwm-support-for-CIX-SoC.patch;
        #   }
        #   {
        #     name = "gpio-gpio-cadence-fix-crashing-pcie-on-cix-p1-acpi-s";
        #     patch = ./patches/2001-gpio-gpio-cadence-fix-crashing-pcie-on-cix-p1-acpi-s.patch;
        #   }
        #   {
        #     name = "drm-linlon-dp-remove-existing-drivers-that-may-own-t";
        #     patch = ./patches/2002-drm-linlon-dp-remove-existing-drivers-that-may-own-t.patch;
        #   }
        #   {
        #     name = "firmware-arm_scmi-add-backward-complibility-to-old-f";
        #     patch = ./patches/2003-firmware-arm_scmi-add-backward-complibility-to-old-f.patch;
        #   }
        #   {
        #     name = "acpi-add-backward-complibility-to-old-firmware-with-";
        #     patch = ./patches/2004-acpi-add-backward-complibility-to-old-firmware-with-.patch;
        #   }
        # ];
      };
    };
}
