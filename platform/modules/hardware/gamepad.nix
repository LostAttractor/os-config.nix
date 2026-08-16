{ pkgs, config, ... }:
let
  xpadneo-udev-rules = pkgs.stdenvNoCC.mkDerivation {
    name = "xpadneo-udev-rules";
    version = config.boot.kernelPackages.xpadneo.version;
    src = config.boot.kernelPackages.xpadneo.src;
    dontBuild = true;
    installPhase = ''
      runHook preInstall
      install -d $out/lib/udev/rules.d
      install -D hid-xpadneo/etc-udev-rules.d/*.rules $out/lib/udev/rules.d
      runHook postInstall
    '';
  };
in 
{
  hardware = {
    xone.enable = true;
    xpadneo.enable = true;
  };

  services.udev.packages = [ xpadneo-udev-rules ];
}
