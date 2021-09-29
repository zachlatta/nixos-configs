{ config, pkgs, ... }:

{
  imports = [ <home-manager/nix-darwin> ];

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = [ ];

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  environment.darwinConfig =
    "/Users/zrl/dev/nixos-configs/abra/darwin-configuration.nix";

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # Create /etc/bashrc that loads the nix-darwin environment.
  programs.zsh.enable = true; # default shell on catalina
  # programs.fish.enable = true;

  users.users.zrl = {
    name = "zrl";
    home = "/Users/zrl";
  };

  home-manager.users.zrl = { pkgs, ... }: {
    imports = [ ../home-manager/darwin.nix ];
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
