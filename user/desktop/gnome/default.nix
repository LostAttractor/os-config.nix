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
      bottom-dash-panel
      caffeine
      astra-monitor
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
      # hanabi
      burn-my-windows
    ]);

  imports = [
    ./dconf/gnome.nix
    ./dconf/fonts.nix
  ];
}
