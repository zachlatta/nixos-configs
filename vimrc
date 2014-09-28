" Because Fish
set shell=/bin/sh

set nocompatible               " be iMproved
filetype on                    " if it's already off
filetype off                   " required!

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/vundle'
Plugin 'altercation/vim-colors-solarized'
Plugin 'scrooloose/nerdtree'
Plugin 'vim-ruby/vim-ruby'
Plugin 'tpope/vim-rails'
Plugin 'tpope/vim-rvm'
Plugin 'kien/ctrlp.vim'
Plugin 'scrooloose/nerdcommenter'
Plugin 'Rip-Rip/clang_complete'
Plugin 'terhechte/syntastic'
Plugin 'b4winckler/vim-objc'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-surround'
Plugin 'elzr/vim-json'
Plugin 'tpope/vim-liquid'
Plugin 'chrisbra/csv.vim'
Plugin 'bling/vim-airline'
Plugin 'ledger/vim-ledger'
Plugin 'ekalinin/Dockerfile.vim'
Plugin 'digitaltoad/vim-jade'
Plugin 'jdonaldson/vaxe'
Plugin 'jamessan/vim-gnupg'
Plugin 'fatih/vim-go'
Plugin 'Valloric/YouCompleteMe'
Plugin 'pangloss/vim-javascript'
Plugin 'othree/javascript-libraries-syntax.vim'
Plugin 'dag/vim-fish'
Plugin 'peterhoeg/vim-qml'
Plugin 'kchmck/vim-coffee-script'
Plugin 'Matt-Deacalion/vim-systemd-syntax'
Plugin 'jceb/vim-orgmode'

call vundle#end()            " required
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

" Incremental search
set incsearch
set hlsearch

" Ctrl-P shortcuts
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'

" :noh to clear highlighting
nnoremap <esc> :noh<return><esc>

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

" Use AngularJS syntax by default for Javascript projects
autocmd BufReadPre *.js let b:javascript_lib_use_angularjs = 1

" Syntastic config
let g:syntastic_ruby_checkers = ['mri', 'rubocop']

" Mail
augroup filetypedetect
 autocmd BufRead,BufNewFile *mutt-*              setfiletype mail
augroup END

" Omnifunc Autocomplete
set omnifunc=syntaxcomplete#Complete
