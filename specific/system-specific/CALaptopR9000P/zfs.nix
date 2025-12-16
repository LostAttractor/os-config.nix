_: {
  security.pam.zfs = {
    enable = true;
    homes = "zroot/home";
  };

  boot.zfs.requestEncryptionCredentials = false;

  networking.hostId = "007f0200";
}