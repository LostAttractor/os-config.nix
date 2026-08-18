{ lib, ... }:
{
  networking.hostName = "CALaptopR9000P"; # Define hostname.

  # Do less swapping instead of droping page cache (default=60)
  boot.kernel.sysctl."vm.swappiness" = lib.mkForce 30;

  imports = [
    ../../general/zfs
    ../../general/zfs/docker.nix
    ../../general/peripherals
    ./disk-config.nix
    ./zfs.nix
    ../../general/linux/tpm2.nix
    ../../general/linux/zswap.nix
    # Persistent
    ./persistent.nix
  ];
}
