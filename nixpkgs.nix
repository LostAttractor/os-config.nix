{ inputs, ... }:
{
  nixpkgs.config.allowUnfree = true;

  nixpkgs.config.permittedInsecurePackages = [
    "electron-39.8.10"
  ];

  nixpkgs.overlays = with inputs; [
    nur.overlays.default
    nix-vscode-extensions.overlays.default

    (final: prev: {
      chromium = prev.chromium.override {
        commandLineArgs = [
          "--wayland-text-input-version=3"
          "--use-gl=angle"
          "--use-angle=vulkan"
          "--enable-features=Vulkan,VulkanFromANGLE,DefaultANGLEVulkan,AcceleratedVideoDecodeLinuxZeroCopyGL,AcceleratedVideoEncoder,VaapiIgnoreDriverChecks,UseMultiPlaneFormatForHardwareVideo"
        ];
      };
      google-chrome = prev.google-chrome.override {
        commandLineArgs = [
          "--wayland-text-input-version=3"
          "--use-gl=angle"
          "--use-angle=vulkan"
          "--enable-features=Vulkan,VulkanFromANGLE,DefaultANGLEVulkan,AcceleratedVideoDecodeLinuxZeroCopyGL,AcceleratedVideoEncoder,VaapiIgnoreDriverChecks,UseMultiPlaneFormatForHardwareVideo"
        ];
      };
      brave = prev.brave.overrideAttrs (old: {
        commandLineArgs = [
          "--wayland-text-input-version=3"
          "--use-gl=angle"
          "--use-angle=vulkan"
          "--enable-features=Vulkan,VulkanFromANGLE,DefaultANGLEVulkan,AcceleratedVideoDecodeLinuxZeroCopyGL,AcceleratedVideoEncoder,VaapiIgnoreDriverChecks,UseMultiPlaneFormatForHardwareVideo"
        ];
      });

      code-cursor = prev.code-cursor.overrideAttrs (oldAttrs: {
        postInstall =
          oldAttrs.postInstall or ""
          + ''
            wrapProgram $out/bin/${oldAttrs.meta.mainProgram} \
              --add-flags "--wayland-text-input-version=3"
          '';
      });

      signal-desktop = prev.signal-desktop.overrideAttrs (oldAttrs: {
        postInstall =
          oldAttrs.postInstall or ""
          + ''
            wrapProgram $out/bin/${oldAttrs.meta.mainProgram} \
              --add-flags "--wayland-text-input-version=3"
          '';
      });

      element-desktop = prev.element-desktop.overrideAttrs (oldAttrs: {
        postInstall =
          oldAttrs.postInstall or ""
          + ''
            wrapProgram $out/bin/${oldAttrs.meta.mainProgram} \
              --add-flags "--wayland-text-input-version=3"
          '';
      });

      discord =
        let
          binaryName = prev.discord.meta.mainProgram;
        in
        prev.discord.overrideAttrs (oldAttrs: {
          postInstall =
            oldAttrs.postInstall or ""
            + ''
              wrapProgram $out/opt/${binaryName}/${binaryName} \
                --add-flags "--wayland-text-input-version=3"
            '';
        });

      logseq = prev.logseq.overrideAttrs (oldAttrs: {
        postFixup =
          oldAttrs.postFixup or ""
          + ''
            wrapProgram $out/bin/${oldAttrs.meta.mainProgram} \
              --add-flags "--wayland-text-input-version=3"
          '';
      });

      obsidian = prev.obsidian.overrideAttrs (oldAttrs: {
        postInstall =
          oldAttrs.postInstall or ""
          + ''
            wrapProgram $out/bin/${oldAttrs.pname} \
              --add-flags "--wayland-text-input-version=3"
          '';
      });

      marktext = prev.marktext.overrideAttrs (oldAttrs: {
        postInstall =
          oldAttrs.postInstall or ""
          + ''
            wrapProgram $out/bin/${oldAttrs.meta.mainProgram} \
              --add-flags "--wayland-text-input-version=3"
          '';
      });

      kuro = prev.kuro.overrideAttrs (oldAttrs: {
        postInstall =
          oldAttrs.postInstall or ""
          + ''
            wrapProgram $out/bin/${oldAttrs.meta.mainProgram} \
              --add-flags "--wayland-text-input-version=3"
          '';
      });

      github-desktop = prev.github-desktop.overrideAttrs (oldAttrs: {
        postInstall =
          oldAttrs.postInstall or ""
          + ''
            wrapProgram $out/bin/${oldAttrs.meta.mainProgram} \
              --add-flags "--wayland-text-input-version=3"
          '';
      });

      bitwarden = prev.bitwarden.overrideAttrs (oldAttrs: {
        postInstall =
          oldAttrs.postInstall or ""
          + ''
            wrapProgram $out/bin/${oldAttrs.meta.mainProgram} \
              --add-flags "--wayland-text-input-version=3"
          '';
      });
    })
  ];
}