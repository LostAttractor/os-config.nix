{ osConfig, ... }:
{
  programs.gpg.enable = true;

  # https://wiki.archlinux.org/title/GnuPG
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    pinentry.package = osConfig.programs.gnupg.agent.pinentryPackage;
  };
}
