{ pkgs, ... }: {
  services.xserver.enable = true;
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Disable gcr-ssh-agent
  services.gnome.gcr-ssh-agent.enable = false;

  environment.systemPackages = with pkgs; [
    file-roller
  ];

  imports = [ ./modules.nix ];
}
