{ pkgs, ... }:
{
  home.packages =
    (with pkgs; [
      gnome-tweaks
      dconf-editor
      gnome-sound-recorder
      gnome-power-manager
    ])
    ++ (with pkgs.gnomeExtensions; [
      appindicator
      gsconnect
      blur-my-shell
      dock-from-dash
      dash-to-dock
      caffeine
      pano
      astra-monitor
      wiggle
      # kimpanel
      ibus-tweaker
      open-desktop-file-location
      compiz-alike-magic-lamp-effect
      fuzzy-app-search
      app-menu-is-back
      tailscale-status
      bluetooth-battery-meter
      hanabi
      # Extensions that no longer in use
      # openweather
      # tiling-assistant
      # burn-my-windows
      # miniview
    ]);

  imports = [
    ./dconf/gnome.nix
    ./dconf/fonts.nix
  ];
}
