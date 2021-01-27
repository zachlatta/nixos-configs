{ pkgs, config, ... }:
{
  programs.vim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      vim-fugitive # git support
      ctrlp-vim # search files easily
      vim-better-whitespace # highlight all whitespace

      vim-nix
    ];
    settings = {
      expandtab = true;
      shiftwidth = 2;
      number = true;
    };
  };
}
