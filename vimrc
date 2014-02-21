" Because Fish
set shell=/bin/sh

set nocompatible               " be iMproved
filetype on                    " if it's already off
filetype off                   " required!

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'
Bundle 'altercation/vim-colors-solarized'
Bundle 'scrooloose/nerdtree'
Bundle 'vim-ruby/vim-ruby'
Bundle 'tpope/vim-rails'
Bundle 'tpope/vim-rvm'
Bundle 'kien/ctrlp.vim'
Bundle 'scrooloose/nerdcommenter'
Bundle 'Rip-Rip/clang_complete'
Bundle 'terhechte/syntastic'
Bundle 'b4winckler/vim-objc'
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-surround'
Bundle 'elzr/vim-json'
Bundle 'tpope/vim-liquid'
Bundle 'jnwhiteh/vim-golang'
Bundle 'chrisbra/csv.vim'
Bundle 'bling/vim-airline'
Bundle 'ledger/vim-ledger'
Bundle 'Blackrush/vim-gocode'
Bundle 'ekalinin/Dockerfile.vim'
Bundle 'digitaltoad/vim-jade'

filetype plugin indent on

" Show sidebar signs
let g:syntastic_enable_signs=1

" Status line configuration
set statusline+=%#warningmsg#  " Add Error ruler.
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
nnoremap <silent> ` :Errors<CR>

" Spaces instead of tabs
set tabstop=2
set shiftwidth=2
set expandtab

" Ctrl-P shortcuts
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'

" 80 columns or else
if exists('+colorcolumn')
  set colorcolumn=80
else
  au BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>80v.\+', -1)
endif

" Solarized config
syntax on
set background=dark
colorscheme solarized

" .layout files should be highlighted as xml files
au BufRead,BufNewFile *.layout set filetype=xml
" .md files = markdown
au BufRead,BufNewFile *.md set filetype=markdown
" Turn on spell checking for markdown files
au BufRead,BufNewFile *.md setlocal spell spelllang=en_us
" .fish file = fish
au BufRead,BufNewFile .fish set filetype=fish
" .ledger file = ledger
au BufRead,BufNewFile .ledger set filetype=ledger

" auto format go source files on save
autocmd FileType go autocmd BufWritePre <buffer> Fmt

" Syntastic config
let g:syntastic_ruby_checkers = ['mri', 'rubocop']

" Mail
augroup filetypedetect
 autocmd BufRead,BufNewFile *mutt-*              setfiletype mail
augroup END

" Omnifunc Autocomplete
set omnifunc=syntaxcomplete#Complete

" GoImport
let g:gofmt_command = "goimports"
