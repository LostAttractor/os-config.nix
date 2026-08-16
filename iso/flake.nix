{
  description = "ChaosAttractor's NixOS LiveCD Flake";

  inputs = {
    # Nix Packages
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable-small";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";
    # User Packages
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    # NUR Packages
    nur.url = "github:nix-community/NUR";
    nur.inputs.nixpkgs.follows = "nixpkgs";
    # Apple Silicon Support
    apple-silicon-support.url = "github:tpwrules/nixos-apple-silicon";
    apple-silicon-support.inputs.nixpkgs.follows = "nixpkgs";
    # AAGL
    aagl.url = "github:ezKEa/aagl-gtk-on-nix";
    aagl.inputs.nixpkgs.follows = "nixpkgs";
    # Spicetify
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    spicetify-nix.inputs.nixpkgs.follows = "nixpkgs";
    # xivlauncher-rb
    nixos-xivlauncher-rb.url = "github:drakon64/nixos-xivlauncher-rb";
    nixos-xivlauncher-rb.inputs.nixpkgs.follows = "nixpkgs";
    # vscode-extensions
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    nix-vscode-extensions.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    { nixpkgs, ... }@inputs:
    rec {
      nixosConfigurations = {
        gnome = nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs system;
            user = "nixos";
          };
          modules = with inputs; [
            "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-graphical-gnome.nix"
            ./livecd.nix
            ../nixpkgs.nix
            ../platform/desktop/gnome/modules.nix
            ../home-manager.nix
            home-manager.nixosModules.home-manager
            aagl.nixosModules.default
            { nixpkgs.config.allowUnfree = true; }
          ];
        };
        plasma6 = nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs system;
            user = "nixos";
          };
          modules = with inputs; [
            "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-graphical-plasma6.nix"
            ./livecd.nix
            ../home-manager.nix
            home-manager.nixosModules.home-manager
            aagl.nixosModules.default
            { nixpkgs.config.allowUnfree = true; }
          ];
        };
      };
      hydraJobs.iso = nixpkgs.lib.mapAttrs' (
        name: config: nixpkgs.lib.nameValuePair name config.config.system.build.isoImage
      ) nixosConfigurations;
    };
}
