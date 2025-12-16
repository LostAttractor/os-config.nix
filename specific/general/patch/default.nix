{
  pkgs,
  config,
  lib,
  ...
}:

let
  cfg = config.boot.kernelModulesPatch;
in
{
  options.boot.kernelModulesPatch = with lib; mkOption {
    type = types.attrsOf (types.submodule {
      options = {
        path = mkOption {
          type = types.str;
          description = "Path of the kernel module.";
          example = "drivers/gpu/drm/amd/amdgpu";
        };
        patches = mkOption {
          type = types.listOf types.path;
          description = ''
            Patches to apply to the kernel for the kernel module build.

            This is intended for applying small patches to specfic kernel module's internals
            without needing to rebuild the entire kernel.

            The patches are applied to the entire kernel tree but only the
            specific module will actually be built and used. You should therefore
            not touch anything outside of the path you specificed using the
            patches as those modifications will not be present in the actual
            kernel you will be running which might cause undefined and likely
            erroneous behaviour.
            Use {option}`boot.kernelPatches` instead for such cases.

            A reboot is required for the patched module to be loaded.
          '';
          example = lib.literalExpression ''
            [
              (pkgs.fetchpatch2 {
                url = "https://github.com/Frogging-Family/community-patches/raw/a6a468420c0df18d51342ac6864ecd3f99f7011e/linux61-tkg/cap_sys_nice_begone.mypatch";
                hash = "sha256-1wUIeBrUfmRSADH963Ax/kXgm9x7ea6K6hQ+bStniIY";
              })
            ]
          '';
        };
      };
    });
    description = "Apply patch to kernel modules.";
  };

  config = {
    assertions = [
      {
        assertion = with lib; all (patch: patch.path != "" && patch.patches != []) (attrValues cfg);
        message = ''
          Each entry in boot.kernelModulesPatch must specify both "path" and "patches" attributes.
        '';
      }
    ];
    boot.extraModulePackages = lib.mapAttrsToList (name: value: (
      pkgs.callPackage ./kernel-module.nix {
        inherit (config.boot.kernelPackages) kernel;
        inherit (value) path patches;
        inherit name;
      }
    )) cfg;
  };
}