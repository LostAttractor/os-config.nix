_: {
  imports = [
    # desktop platform modules
    ../platform/desktop/modules.nix
    # modules/basic
    ../modules/time.nix
    ../modules/i18n.nix
    ../modules/shell.nix
    ../modules/nix.nix
    ../modules/registy.nix
    ../modules/ssh.nix
    ../modules/sudo.nix
    # modules/network
    ../modules/network
    ../modules/network/firewall.nix
    ../modules/network/featrues/proxy.nix
    # modules/features
    ../modules/features/virtualisation.nix
    ../modules/features/docker.nix
    ../modules/features/filesystems.nix
    ../modules/features/fwupd.nix
    ../modules/features/pcscd.nix
    ../modules/features/appimage.nix
    ../modules/features/nix-ld.nix
    # package
    ../packages
    ../packages/gaming.nix
    # programs
    ../programs/utils.nix
  ];

  isoImage.squashfsCompression = "zstd";
}
