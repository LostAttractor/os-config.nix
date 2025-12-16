{ pkgs, ... }:
{
  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      obs-pipewire-audio-capture
      distroav
      obs-text-pthread
      obs-vkcapture
      waveform
      input-overlay
      # Plugins that no longer in use
      # obs-multi-rtmp
    ];
  };

  home.packages = with pkgs; [
    ndi-6
  ];
}
