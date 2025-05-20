{
  description = "Zach Latta • NixOS configs (flake-style)";

  inputs = {
    nixpkgs.url          = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url      = "github:numtide/flake-utils";
    
    # Hyprland and related tools
    hyprland = {
      url = "github:hyprwm/Hyprland";
      # inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    hyprpaper = {
      url = "github:hyprwm/hyprpaper";
      # inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprlock = {
      url = "github:hyprwm/hyprlock";
      # inputs.nixpkgs.follows = "nixpkgs";
    };
    hypridle = {
      url = "github:hyprwm/hypridle";
      # inputs.nixpkgs.follows = "nixpkgs";
    };
    # For home-manager integration
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs"; # Ensure it uses the same nixpkgs
    };
  };

  outputs = { self, nixpkgs, flake-utils, home-manager, ... }@inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
      in {
        # Expose your custom packages for ad-hoc `nix run .#logbook` etc.
        packages = rec {
          logbook = pkgs.callPackage ./pkgs/custom/logbook { };
          typora  = pkgs.callPackage ./pkgs/typora     { };
          lg-client = pkgs.callPackage ./pkgs/looking-glass-client-git { };
          bibata-hyprcursor = pkgs.callPackage ./pkgs/bibata-hyprcursor {
            # variant = "modern";
            # colorName = "classic";
          };
          default = logbook;     # `nix run` picks this one
        };
      })
    // {
      # ---- NixOS -----------------------------------------------------------
      nixosConfigurations.mew = nixpkgs.lib.nixosSystem {
        system  = "x86_64-linux";
        modules = [
          ./mew/configuration.nix          # the host config you already have
          home-manager.nixosModules.home-manager # Add home-manager module
        ];
        # Pass flake inputs to your modules
        specialArgs = { inherit inputs; }; # Pass all inputs
      };
    };
} 