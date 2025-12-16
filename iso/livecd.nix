_: {
  imports = [
    # desktop platform modules
    ../platform/desktop/modules.nix
    # modules/basic
    ../modules/time.nix
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
    ../modules/features/apparmor.nix
    ../modules/features/virtualisation.nix
    ../modules/features/docker.nix
    ../modules/features/appimage.nix
    ../modules/features/nix-ld.nix
    # package
    ../packages
    ../packages/gaming.nix
  ];

  nixpkgs.overlays = [
    (final: prev: {
      mutter = prev.mutter.overrideAttrs (oldAttrs: {
        patches = oldAttrs.patches or [ ] ++ [
          ../wayland-text-input-v1-Implement-basic-text-input-v1-.patch
        ];
      });
    })
  ];

  isoImage.squashfsCompression = "zstd";
}
