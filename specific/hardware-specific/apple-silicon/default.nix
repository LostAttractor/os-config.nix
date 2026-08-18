{ lib, ... }:
{
  hardware.asahi.enable = true;
  hardware.asahi.extractPeripheralFirmware = false;

  boot.loader.timeout = lib.mkForce 5;

  boot.loader.efi.canTouchEfiVariables = lib.mkForce false;
}
