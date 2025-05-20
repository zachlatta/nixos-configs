{
  description = "NixOS configuration for host 'mew'";

  inputs = {
    nixpkgs.url          = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url      = "github:numtide/flake-utils"; 
  };

  outputs = { self, nixpkgs, flake-utils, ... }@inputsArgs: 
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
      in {
        packages = rec {
          # Using packages from bak/lugia/pkgs directory
          logbook = pkgs.callPackage ../bak/lugia/pkgs/custom/logbook { };
          typora = pkgs.callPackage ../bak/lugia/pkgs/typora { };
          lg-client = pkgs.callPackage ../bak/lugia/pkgs/looking-glass-client-git { };
          default = logbook;
        };
      })
    // { 
      nixosConfigurations.mew = nixpkgs.lib.nixosSystem {
        system  = "x86_64-linux"; 
        modules = [
          ./configuration.nix
        ];
        # Pass all flake inputs to your NixOS modules
        specialArgs = { inputs = inputsArgs; };
      };
    };
} 