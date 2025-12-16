{
  pkgs,
  inputs,
  config,
  ...
}: {
  # import the flake's module for your system
  imports = [ inputs.spicetify-nix.homeManagerModules.default ];

  # configure spicetify :)
  programs.spicetify = 
  let
    spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
  in {
    enabledExtensions = with spicePkgs.extensions; [
      adblock
      hidePodcasts
      shuffle # shuffle+ (special characters are sanitized out of extension names)
    ];

    theme = spicePkgs.themes.sleek;
    colorScheme = "Cherry";
  };

  home.packages = [
    (config.programs.spicetify.spicedSpotify.overrideAttrs (oldAttrs: {
      postInstall =
        oldAttrs.postInstall or ""
        + ''
          wrapProgram $out/bin/${oldAttrs.meta.mainProgram} \
            --add-flags "--enable-wayland-ime"
        '';
    }))
  ] ++ config.programs.spicetify.theme.extraPkgs;
}
