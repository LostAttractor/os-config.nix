_: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../general/amd/virtualisation.nix
    ../../general/amdgpu/rocm.nix
  ];

  services.lact.enable = true;
}