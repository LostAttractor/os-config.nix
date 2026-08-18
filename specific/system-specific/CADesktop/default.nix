{ pkgs, lib, ... }:
{
  networking.hostName = "CADesktop"; # Define hostname.

  boot.kernel.sysctl = {
    "vm.dirty_background_bytes" = 512 * 1024 * 1024; # 512MB
  };

  boot.kernelParams = [ "zfs.zfs_arc_max=${toString (8 * 1024 * 1024 * 1024)}" ];

  # Enable the GNOME RDP components
  services.gnome.gnome-remote-desktop.enable = true;

  # Ensure the service starts automatically at boot so the settings panel appears
  systemd.services.gnome-remote-desktop = {
    wantedBy = [ "graphical.target" ];
  };

  services.sunshine = {
    enable = true;
    capSysAdmin = true;
  };

  systemd.user.services.sunshine = {
    environment.AMD_DEBUG = "lowlatencyenc";
    # unitConfig.ConditionUser = "!@system";
    unitConfig.ConditionGroup = "users";
  };

  # environment.variables.MUTTER_DEBUG = "render,kms";
  # environment.variables.MUTTER_DEBUG_KMS_THREAD_TYPE = "user";

  fileSystems."/mnt/Games" = {
    device = "nas.home.lostattractor.net:/Games";
    fsType = "nfs";
    options = [
      "nconnect=4"
      "timeo=600"
      "retrans=2"
      "x-systemd.automount"
    ];
  };

  # hardware.display = {
  #   edid.packages = [
  #     (pkgs.runCommand "edid-custom" {} ''
  #       mkdir -p "$out/lib/firmware/edid"
  #       base64 -d > "$out/lib/firmware/edid/lg.bin" <<'EOF'
  #       AP///////wAebU1cGa8DAAMiAQS1PCJ4nYy1r09DqyYOUFQhCADRwGFAAQEBAQEBAQEBAQEBCewAoKCgZ1AwIDoAWFQhAAAaAAAA/Qw8pQMDRgEKICAgICAgAAAA/ABMRyBVTFRSQUdFQVIKAAAA/wA0MDNOVFdHNzM0MzMKAgUCAzFxIwkGB+IAaoMBAADjBcAA5gYFAVNTLkgQBAMBHxM/QG0aAAACBTylAARTLlMuVl4AoKCgKVAwIDUAWFQhAAAaWqAAoKCgRlAwIDoAWFQhAAAAb8IAoKCgVVAwIDoAWFQhAAAaAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA9XASeQMAAwAUPREBhP8JnwAvgB8AnwV2AAIABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAPOQ
  #       EOF
  #     '')
  #   ];
  #   outputs."DP-4" = {
  #     mode = "e";
  #     edid = "lg.bin";
  #   };
  # };

  boot.kernelModulesPatch.ast = {
    path = "drivers/gpu/drm/ast";
    patches = [ ./ast.patch ];
  };

  imports = [
    ../../general/zfs
    ../../general/zfs/docker.nix
    ../../general/peripherals
    ../../general/amdgpu/cap_sys_nice_begone.nix
    ./disk-config.nix
    ./zfs.nix
    ../../general/linux/tpm2.nix
    ../../general/linux/zswap.nix
    # Persistent
    ./persistent.nix
  ];
}
