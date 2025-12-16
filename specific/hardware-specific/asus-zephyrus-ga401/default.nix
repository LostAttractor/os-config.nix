{ user, ... }:
{
  imports = [
    ../../general/amd/virtualisation.nix
    ../../general/nvidia
    # ./modules/features/libfprint-goodix-521d
  ];

  # Torchpad is so slow
  home-manager.users.${user}.dconf.settings = {
    "org/gnome/desktop/peripherals/touchpad" = {
      speed = 0.2;
    };
  };

  # Reserve one core to prevent the system from freezing
  nix.settings.cores = 15;

  # https://nixos.org/manual/nixos/unstable/index.html#sec-gpu-accel-vulkan
  environment.variables.DXVK_FILTER_DEVICE_NAME = "NVIDIA GeForce RTX 3060 Laptop GPU";
}
