{ pkgs, inputs, ... }:
let
  profile = "default";
in
{
  home.file.".mozilla/firefox/${profile}/chrome/firefox-gnome-theme".source =
    inputs.firefox-gnome-theme;

  programs.firefox = {
    enable = true;
    package = (import inputs.nixpkgs-stable {
      # https://discourse.nixos.org/t/how-do-i-configure-multiple-nixpkgss-in-flakes/59581/2
      inherit (pkgs.stdenv.hostPlatform) system;
      config = pkgs.config;
    }).firefox-bin;
    profiles.${profile} = {
      extraConfig = ''
        ${builtins.readFile "${inputs.firefox-gnome-theme}/configuration/user.js"}
      '';

      userChrome = ''
        @import "firefox-gnome-theme/userChrome.css";

        #TabsToolbar {
          display: none;
        }

        #sidebar-header {
          display: none;
        }
      '';

      userContent = ''
        @import "firefox-gnome-theme/userContent.css;
      '';
    };
  };
}
