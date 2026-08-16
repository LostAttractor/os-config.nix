_:
{
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.iotop.enable = true;
  programs.iftop.enable = true;
  programs.bandwhich.enable = true;
  programs.mtr.enable = true;
  programs.nexttrace.enable = true;
  programs.trippy.enable = true;
  programs.wireshark.enable = true;
  programs.wireshark.usbmon.enable = true;

  # System tracing and probing tool
  programs.systemtap.enable = true;
}