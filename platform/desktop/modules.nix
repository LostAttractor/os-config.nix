_: {
  imports = [
    # platform/modules/basic
    ../modules/fonts.nix
    # platform/modules/hardware
    ../modules/hardware/bluetooth.nix
    ../modules/hardware/gamepad.nix
    ../modules/hardware/imobiledevice.nix
    # platform/modules/features
    ../modules/features/audio/pipewire.nix
    ../modules/features/ime/ibus.nix
    ../modules/features/avahi.nix
    ../modules/features/printing.nix
    ../modules/features/flatpak.nix
  ];
}
