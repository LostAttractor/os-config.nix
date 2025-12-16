{ pkgs, ... }: {
  services.udev.extraRules = ''
    KERNEL=="hidraw*", MODE="0660", GROUP="plugdev", TAG+="uaccess", TAG+="udev-acl"
  '';

  environment.systemPackages = with pkgs; [ via ];
}