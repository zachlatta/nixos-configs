{ pkgs, config, ... }:
{
  programs.vim = {
    enable = true;

    plugins = with pkgs.vimPlugins; [
      base16-vim # theme

      vim-fugitive # git support
      ctrlp-vim # search files easily
      vim-better-whitespace # highlight all whitespace
      nerdtree # gimme those files
      vim-which-key # spacemacs-like leader key menu

      vim-nix
      vim-javascript
      typescript-vim
      vim-jsx-pretty
      vim-jsx-typescript
      vim-graphql
    ];

    settings = {
      expandtab = true;
      shiftwidth = 2;
      number = true;
    };

    extraConfig = ''
      " theme config
      let base16colorspace=256
      colorscheme base16-tomorrow-night

      " only visually wrap lines on whitespace (https://stackoverflow.com/a/19624717)
      set nolist wrap linebreak breakat&vim

      " CtrlP - no caching
      let g:ctrl_use_caching = 0

      " CtrlP - Ignore files in .gitignore
      let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']

      " set leader key to SPC
      nnoremap <SPACE> <Nop> " remove any current binding
      let mapleader=" "

      " vim-which-key - Trigger when pressing SPC
      nnoremap <silent> <leader> :WhichKey '<Space>'<CR>
      " vim-which-key - Popup after 400ms of no keypress
      set timeoutlen=400

      " leader key keybindings
      nnoremap <leader>f :NERDTreeFocus<CR>
      nnoremap <leader>gg :Git<CR>
      nnoremap <leader>gp :Gpush<CR>
      nnoremap <leader>gf :Gpull<CR>
      nnoremap <leader>p :CtrlP<CR>
    '';
  };
}
