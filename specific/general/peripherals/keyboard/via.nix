{ pkgs, ... }: {
  services.udev.packages = [ (pkgs.writeTextFile {
    name = "hidraw-udev-rules";
    destination = "/lib/udev/rules.d/60-hidraw.rules";
    text = ''
      # ACTION!="remove", SUBSYSTEM=="hidraw", TAG+="uaccess"
      ACTION!="remove", SUBSYSTEM=="hidraw", GROUP="input", MODE="0660"
    '';
  }) ];

  environment.systemPackages = with pkgs; [ via ];
}