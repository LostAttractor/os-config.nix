{
  stdenv,
  lib,
  fetchFromGitHub,
  kernel,
  kernelModuleMakeFlags,
  ...
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "r8127";
  version = "11.016.00";

  src = fetchFromGitHub {
    owner = "lostattractor";
    repo = "rtl8127";
    rev = "14b0c609c95ac13e0f26f69dea0ca82883e84065";
    hash = "sha256-PEr+h12n4C3DBlDXvKsiOmTPTzFu+Mpj/pMWI4HbOT8=";
  };

  patches = [ ./r8127.patch ];

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  preBuild = ''
    substituteInPlace Makefile --replace-fail "BASEDIR :=" "BASEDIR ?="
    substituteInPlace Makefile --replace-fail "modules_install" "INSTALL_MOD_PATH=$out modules_install"
  '';

  makeFlags = kernelModuleMakeFlags ++ [
    "BASEDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}"
  ];

  buildFlags = [ "modules" ];

  installPhase = ''
    mkdir -p $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/net/ethernet/realtek
    cp r8127.ko $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/net/ethernet/realtek/
  '';

  meta = {
    homepage = "https://github.com/openwrt/rtl8127/";
    description = "Realtek r8127 10G Ethernet driver";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.peelz ];
  };
})