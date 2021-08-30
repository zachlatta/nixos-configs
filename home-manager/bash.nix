{ pkgs, ... }:
{
  programs.bash = {
    enable = true;

    enableVteIntegration = true;

    sessionVariables = {
      EDITOR = "vim";
    };
  };
}
