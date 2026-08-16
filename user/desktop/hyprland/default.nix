{ pkgs, ... }:
{
  home.packages = with pkgs; [
    hyprpaper
    rofi
    mako
    nautilus
    networkmanagerapplet
  ];

  home.pointerCursor = {
    package = pkgs.kdePackages.breeze;
    name = "breeze_cursors";
    # x11.enable = true;
    gtk.enable = true;
  };

  imports = [
    ./config.nix
    ./waybar
  ];
}
