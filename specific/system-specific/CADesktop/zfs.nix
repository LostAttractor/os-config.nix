_: {
  security.pam.zfs = {
    enable = true;
    homes = "zroot/home";
  };

  boot.zfs = {
    forceImportRoot = false;
    requestEncryptionCredentials = false;
  };

  networking.hostId = "820df795";
}
