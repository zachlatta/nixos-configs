{ pkgs, config, ... }:

let
  plugins = pkgs.vimPlugins // pkgs.callPackage ./vim/custom-plugins.nix { };

  dhall = pkgs.dhall;
  nixfmt = pkgs.nixfmt;
in {
  programs.vim = {
    enable = true;

    plugins = with plugins; [
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
      dhall-vim

      vim-esearch
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

      " automatically read files when they've been updated elsewhere
      set autoread

      " leader key keybindings
      nnoremap <leader>f :NERDTreeFocus<CR>
      nnoremap <leader>gg :Git<CR>
      nnoremap <leader>gp :Git push<CR>
      nnoremap <leader>gf :Git pull<CR>
      nnoremap <leader>p :CtrlP<CR>

      " run dhall format automatically on save
      autocmd bufwritepost *.dhall silent !${dhall}/bin/dhall format % 2> /dev/null

      " run nixfmt on save
      autocmd bufwritepost *nix silent !${nixfmt}/bin/nixfmt --width=80 %
    '';
  };
}
