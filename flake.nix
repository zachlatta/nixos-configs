{
  description = "Zach Latta • NixOS configs (flake-style)";

  inputs = {
    nixpkgs.url          = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url      = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, home-manager, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in {
        # Expose your custom packages for ad-hoc `nix run .#logbook` etc.
        packages = rec {
          logbook = pkgs.callPackage ./pkgs/custom/logbook { };
          typora  = pkgs.callPackage ./pkgs/typora     { };
          lg-client = pkgs.callPackage ./pkgs/looking-glass-client-git { };
          default = logbook;     # `nix run` picks this one
        };
      })
    // {
      # ---- NixOS -----------------------------------------------------------
      nixosConfigurations.mew = nixpkgs.lib.nixosSystem {
        system  = "x86_64-linux";
        modules = [
          ./mew/configuration.nix          # the host config you already have
          home-manager.nixosModules.home-manager
        ];
        # Pass flake inputs to your modules (optional but handy)
        specialArgs = { inherit (self) inputs; };
      };
    };
} 