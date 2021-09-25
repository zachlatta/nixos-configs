{ pkgs, ... }:
{
  programs.bash = {
    enable = true;

    enableVteIntegration = true;

    sessionVariables = {
      EDITOR = "vim";
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
