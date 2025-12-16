_:
{
  # https://github.com/NixOS/nixpkgs/issues/217119
  boot.kernelModulesPatch.amdgpu = {
    path = "drivers/gpu/drm/amd/amdgpu";
    patches = [ ./cap_sys_nice_begone.patch ];
  };
}