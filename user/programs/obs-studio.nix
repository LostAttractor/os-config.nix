{ pkgs, inputs, ... }:
{
  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      obs-pipewire-audio-capture
      distroav
      obs-text-pthread
      obs-vkcapture
      waveform
      obs-move-transition
      advanced-scene-switcher
      input-overlay
    ] ++ (with (import inputs.nixpkgs-stable {
      inherit (pkgs.stdenv.hostPlatform) system;
      config = pkgs.config;
    }).obs-studio-plugins; [
      obs-backgroundremoval
    ]);
  };

  home.packages = with pkgs; [
    ndi-6
  ];
}
