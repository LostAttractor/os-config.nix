_: {
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Disable gcr-ssh-agent
  services.gnome.gcr-ssh-agent.enable = false;

  imports = [ ./modules.nix ];
}
