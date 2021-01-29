{ pkgs, ... }:
{
  programs.fish = {
    enable = true;

    plugins = [
      {
        name = "base16-fish";
        src = pkgs.fetchFromGitHub {
          owner = "tomyun";
          repo = "base16-fish";
          rev = "675d53a0dd1aed0fc5927f26a900f5347d446459";
          sha256 = "0lp1s9hg682jwzqn1lgj5mrq5alqn9sqw75gjphmiwmciv147kii";
        };
      }
    ];

    interactiveShellInit = ''
      # initialize theme
      base16-tomorrow-night
    '';
  };
}
