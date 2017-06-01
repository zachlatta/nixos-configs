set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'
Plugin 'altercation/vim-colors-solarized'
Plugin 'kien/ctrlp.vim'
Plugin 'christoomey/vim-tmux-navigator'

call vundle#end()
filetype plugin indent on

" Two space indent
set shiftwidth=2
set softtabstop=2

" 80 character line wrap
set tw=80 " automatically wrap lines at 80 characters
set colorcolumn=81 " draw a column at 81 chars to visually show line limit

syntax enable
set background=dark
colorscheme solarized
