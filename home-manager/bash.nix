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

    enableBashIntegration = true;
    enableFishIntegration = false;
    enableZshIntegration = false;

    nix-direnv.enable = true;
  };
}
