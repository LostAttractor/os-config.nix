_: {
  # rtkit is optional but recommended
  security.rtkit.enable = true;
  # PulseAudio
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.support32Bit = true;
  services.pipewire.audio.enable = false;
  services.pipewire.pulse.enable = false;
}
