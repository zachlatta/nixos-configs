set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim

" Set up leader key use. Space to trigger, show commands when using.
let mapleader=" "
set showcmd

" Let the Vundle begin!
call vundle#begin()

Plugin 'gmarik/Vundle.vim'
Plugin 'altercation/vim-colors-solarized'
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'tpope/vim-fugitive'
Plugin 'ledger/vim-ledger'
Plugin 'chr4/nginx.vim'
Plugin 'tpope/vim-commentary'

"
" vimiwiki!
"
Plugin 'vimwiki/vimwiki'
let g:vimwiki_list = [
  \{
    \'path': '~/dev/brain/',
    \'index': 'Home',
    \'syntax': 'markdown',
    \'ext': '.md'
  \},
  \{
    \'path': '~/dev/hackclub/hackclub/',
    \'index': 'README',
    \'syntax': 'markdown',
    \'ext': '.md'
  \}
\]

" use leader + key for interacting with links
nmap <Leader>wf <Plug>VimwikiFollowLink
nmap <Leader>wg <Plug>VimwikiTabnewLink
nmap <Leader>we <Plug>VimwikiSplitLink
nmap <Leader>wq <Plug>VimwikiVSplitLink
nmap <Leader>wb <Plug>VimwikiGoBackLink
nmap <Leader>wn <Plug>VimwikiNextLink
nmap <Leader>wp <Plug>VimwikiPrevLink

" Go development support
Plugin 'fatih/vim-go'
let g:go_fmt_command = 'goimports' " use goimports instead of gofmt

" Ctrl+o to open NERDTree
Plugin 'scrooloose/nerdtree'
nmap <Leader>ft :NERDTreeToggle<CR>
" close vim if NERDTree is the only window left open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Ctrl+P to quickly open project files
Plugin 'ctrlpvim/ctrlp.vim'
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard'] " use .gitignore

" handle js and jsx well
Plugin 'pangloss/vim-javascript'
Plugin 'mxw/vim-jsx'

" apply jsx logic to .js files in addition to .jsx files
let g:jsx_ext_required=0

call vundle#end()
filetype plugin indent on

" UTF-8 all the things, required for NERDTree arrows to work
scriptencoding utf-8
set encoding=utf-8

" Two space indent
set shiftwidth=2
set softtabstop=2
set tabstop=2
set expandtab

" 80 character line wrap
set textwidth=80 " automatically wrap lines at 80 characters
set colorcolumn=81 " draw a column at 81 chars to visually show line limit

" Use one space after sentences, not two.
"
" See https://stackoverflow.com/a/4760477 for context.
set nojoinspaces

" configure settings for editing text files
function SetTextEditingConfig()
  " setup spell checking
  set spell spelllang=en
  set spellfile=$HOME/.vim/spell/en.utf-8.add

  " disable line wrapping & color column
  set textwidth=0
  set colorcolumn=0

  " wrap at words, not at characters
  set linebreak

  " open all folds by default
  set nofoldenable
endfunction

function UnsetTextEditingConfig()
  " disable spell checking
  set nospell

  " re-enable line wrapping & color column
  set textwidth=80
  set colorcolumn=81

  " revert to regular line wrapping
  set nolinebreak

  " re-enable folds
  set foldenable
endfunction

autocmd BufEnter md,markdown,*.md call SetTextEditingConfig()
autocmd BufLeave md,markdown,*.md call UnsetTextEditingConfig()

syntax enable
colorscheme solarized

" dynamically set the background using the symlink at vimrc_background
runtime color/set-background.vim
