{ pkgs
, lib
, kernel
, name
, path
, patches
}:

pkgs.stdenv.mkDerivation {
  pname = "${name}-kernel-module-patched";
  inherit (kernel) src version postPatch nativeBuildInputs;
  inherit patches;

  kernel_dev = kernel.dev;
  kernelVersion = kernel.modDirVersion;

  modulePath = path;

  buildPhase = ''
    BUILT_KERNEL=$kernel_dev/lib/modules/$kernelVersion/build

    cp $BUILT_KERNEL/Module.symvers .
    cp $BUILT_KERNEL/.config        .
    cp $kernel_dev/vmlinux          .

    make "-j$NIX_BUILD_CORES" modules_prepare
    make "-j$NIX_BUILD_CORES" M=$modulePath modules
  '';

  installPhase = ''
    make \
      INSTALL_MOD_PATH="$out" \
      XZ="xz -T$NIX_BUILD_CORES" \
      M="$modulePath" \
      modules_install
  '';

  meta = {
    description = "${name} kernel module";
    license = lib.licenses.gpl2Only;
  };
}