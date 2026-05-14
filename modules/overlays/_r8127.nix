{
  fetchFromGitHub,
  lib,
  stdenv,
  # compatibility with nixpkgs
  linuxPackages,
  kernel ? linuxPackages.kernel,
  kernelModuleMakeFlags ? linuxPackages.kernel.modules.commonMakeFlags,
  ...
}:
stdenv.mkDerivation rec {
  pname = "r8127";
  version = "11.015.00";

  src = fetchFromGitHub {
    owner = "openwrt";
    repo = "rtl8127";
    rev = "refs/tags/${version}";
    hash = "sha256-U0i/IxB7EiiHGulwI4TdYeaOpHq8v4JBSTVZ0qMbcx0=";
  };

  hardeningDisable = [
    "pic"
  ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  prePatch = ''
    substituteInPlace Makefile \
      --replace-fail /lib/modules/ "${kernel.dev}/lib/modules/" \
      --replace-fail '$(shell uname -r)' "${kernel.modDirVersion}" \
      ;
  '';

  makeFlags = kernelModuleMakeFlags;

  enableParallelBuilding = true;

  buildFlags = [ "modules" ];

  installPhase = ''
    mkdir -p $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/net/ethernet/realtek
    cp r8127.ko $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/net/ethernet/realtek/
  '';

  meta = {
    description = "Realtek 8127 Linux driver";
    homepage = "https://github.com/openwrt/rtl8127";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.wwmoraes ];
    platforms = lib.platforms.linux;
  };
}
