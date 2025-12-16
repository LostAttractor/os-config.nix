_:
{
  fileSystems."/" = {
    device = "tmpfs";
    fsType = "tmpfs";
    options = [ "mode=755" ];
  };

  fileSystems."/persistent".neededForBoot = true;

  disko.devices = {
    disk.main = {
      type = "disk";
      device = "/dev/nvme0n1";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            size = "512M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "umask=0077" ];
            };
          };
          zfs = {
            end = "-32G";
            content = {
              type = "zfs";
              pool = "zroot";
            };
          };
          encryptedSwap = {
            size = "100%";
            content = {
              type = "swap";
              randomEncryption = true;
              discardPolicy = "both";
            };
          };
        };
      };
    };
    zpool = {
      zroot = {
        type = "zpool";
        rootFsOptions = {
          mountpoint = "none";
          compression = "zstd";
          acltype = "posixacl";
          xattr = "sa";
        };
        options.ashift = "12";
        datasets = {
          "persistent" = {
            type = "zfs_fs";
            options.mountpoint = "/persistent";
            mountpoint = "/persistent";
          };
          "root" = {
            type = "zfs_fs";
            options.mountpoint = "/root";
            mountpoint = "/root";
          };
          "home/lostattractor" = {
            type = "zfs_fs";
            options = {
              encryption = "aes-256-gcm";
              keyformat = "passphrase";
              #keylocation = "file:///tmp/secret.key";
              keylocation = "prompt";
              mountpoint = "/home/lostattractor";
              # canmount = "noauto";  # zfs_pam want this be "on"
              "com.sun:auto-snapshot" = "true";
            };
            # mountpoint = "/home/lostattractor";
          };
          "nix" = {
            type = "zfs_fs";
            options = {
              dedup = "on";
              atime = "off";
              mountpoint = "/nix";
            };
            mountpoint = "/nix";
          };
        };
      };
    };
  };
}
