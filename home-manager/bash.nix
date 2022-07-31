{ pkgs, ... }: {
  programs.bash = {
    enable = true;

    enableVteIntegration = true;

    sessionVariables = {
      EDITOR = "vim";
      PATH = "$PATH:$HOME/.cargo/bin";
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
