" PLUGGED
call plug#begin(stdpath('data') . '/plugged')

" base nvim setup
Plug 'scrooloose/nerdtree'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'neoclide/coc.nvim', { 'branch': 'release' }
Plug 'tpope/vim-fugitive'

" language specific
Plug 'yuezk/vim-js'
Plug 'MaxMEllon/vim-jsx-pretty'
Plug 'cespare/vim-toml'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'jparise/vim-graphql'

" add-on modes
Plug 'junegunn/goyo.vim'

call plug#end()

" Load color scheme
syntax enable
colorscheme lucario

" When wrapping lines, don't split words in two. Wrap at word end.
set linebreak

" 2 space indent
set expandtab
set shiftwidth=2
set softtabstop=2

" C-w + hjkl to work nicer in terminal
tnoremap <C-w>h <C-\><C-n><C-w>h
tnoremap <C-w>j <C-\><C-n><C-w>j
tnoremap <C-w>k <C-\><C-n><C-w>k
tnoremap <C-w>l <C-\><C-n><C-w>l

" C-[ to escape out of terminal
tnoremap <C-[> <C-\><C-n>

" Don't show line numbers in terminal
" - from https://github.com/neovim/neovim/issues/6832#issuecomment-305507194
au TermOpen * setlocal nonumber norelativenumber

" Run rustfmt automatically when saving files
let g:rustfmt_autosave = 1

" goimports instead of gofmt on save
let g:go_fmt_command = "goimports"

" Enable GraphQL formatting for .prisma files
au BufNewFile,BufRead *.prisma setfiletype graphql

" Make JS formatting colorful
let g:vim_jsx_pretty_colorful_config = 1

"
" NERDTree Setup
"
let g:NERDTreeShowHidden = 1
let g:NERDTreeMinimalUI = 1
let g:NERDTreeIgnore = []
let g:NERDTreeStatusline = ''

" Automaticaly close nvim if NERDTree is only thing left open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" Toggle with ,ne
let mapleader = ","
nnoremap <leader>ne :NERDTreeToggle<CR>

" fzf setup
nnoremap <C-p> :FZF<CR>
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit'
\}
let $FZF_DEFAULT_COMMAND = 'fd --type f'
