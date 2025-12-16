{
  inputs,
  pkgs,
  ...
}:
{
  programs.steam = {
    enable = true;
    package = pkgs.steam.override {
      extraEnv = {
        MANGOHUD = true;
        OBS_VKCAPTURE = true;
        PROTON_ENABLE_WAYLAND = true;
        PROTON_USE_NTSYNC = true;
        PROTON_FSR4_UPGRADE = true;
        # PROTON_ENABLE_HDR = true;
        # PROTON_USE_WOW64 = true;
      };
    };
    gamescopeSession.enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    extraCompatPackages = with pkgs; [ proton-ge-bin ] ;
    platformOptimizations.enable = true;
  };

  programs.gamescope.enable = true;
  programs.gamescope.capSysNice = true;

  programs.gamemode = {
    enable = true;
    enableRenice = true;
    settings.general.softrealtime = "auto";
  };

  boot.kernelModules = [ "ntsync" ];

  nix.settings = inputs.aagl.nixConfig; # Set up Cachix
  programs.anime-game-launcher.enable = true; # Adds launcher and /etc/hosts rules
  programs.honkers-railway-launcher.enable = true;
  programs.honkers-launcher.enable = true;
  programs.wavey-launcher.enable = true;
  programs.sleepy-launcher.enable = true;
}
