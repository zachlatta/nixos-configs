set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'
Plugin 'altercation/vim-colors-solarized'
Plugin 'kien/ctrlp.vim'

call vundle#end()
filetype plugin indent on

" Two space indent
set shiftwidth=2
set softtabstop=2

syntax enable
set background=dark
colorscheme solarized
