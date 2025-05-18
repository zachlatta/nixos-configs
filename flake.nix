{
  description = "Zach Latta • NixOS configs (flake-style)";

  inputs = {
    nixpkgs.url          = "github:NixOS/nixpkgs/nixos-24.05";
    home-manager.url     = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    flake-utils.url      = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, home-manager, flake-utils, ... }:
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
        specialArgs = { inherit self; };
      };
    };
} 