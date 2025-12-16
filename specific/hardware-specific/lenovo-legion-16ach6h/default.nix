{ config, pkgs, ... }:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../general/amd/virtualisation.nix
    ../../general/nvidia
  ];

  boot.extraModulePackages = [ config.boot.kernelPackages.lenovo-legion-module ];

  environment.systemPackages = with pkgs; [ lenovo-legion ];

  # Reserve one core to prevent the system from freezing
  nix.settings.cores = 15;

  # https://nixos.org/manual/nixos/unstable/index.html#sec-gpu-accel-vulkan
  # environment.variables.DXVK_FILTER_DEVICE_NAME = "NVIDIA GeForce RTX 3070 Laptop GPU";
}
