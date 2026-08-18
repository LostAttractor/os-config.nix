{ lib, ... }:
{
  networking.hostName = "CALaptopG14"; # Define hostname.

  # Do less swapping instead of droping page cache (default=60)
  boot.kernel.sysctl."vm.swappiness" = lib.mkForce 30;

  imports = [
    ../../general/btrfs/autoscrub.nix
    ../../general/btrfs/snapper.nix
    ../../general/btrfs/docker.nix
    ../../general/ssd/trim.nix
    ../../general/peripherals
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../general/linux/tpm2.nix
    ../../general/linux/zswap.nix
    # Persistent
    ./persistent.nix
    # Featrues
    # ./modules/features/rathole.nix
  ];
}
