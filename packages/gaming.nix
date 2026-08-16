{ pkgs, ... }:
{
  imports = [ 
    ./hoyo-games.nix
  ];

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
}
