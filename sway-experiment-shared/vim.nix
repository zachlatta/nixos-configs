{ pkgs, config, ... }:
{
  programs.vim = {
    enable = true;

    plugins = with pkgs.vimPlugins; [
      vim-fugitive # git support
      ctrlp-vim # search files easily
      vim-better-whitespace # highlight all whitespace

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
      # CtrlP - Ignore files in .gitignore
      let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']
    '';
  };
}
