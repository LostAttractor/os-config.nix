{ inputs, ... }:
{
  imports = [
    ./modules/features/binfmt.nix
    ../../../packages/gaming.nix
    inputs.impermanence.nixosModules.impermanence
    inputs.lanzaboote.nixosModules.lanzaboote
    inputs.aagl.nixosModules.default
  ];
}
