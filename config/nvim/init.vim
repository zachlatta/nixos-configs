" PLUGGED
call plug#begin(stdpath('data') . '/plugged')

Plug 'justinmk/vim-dirvish'
Plug 'cespare/vim-toml'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

call plug#end()

" Make color schemes work nicely in terminal (must be using an advanced,
" modern terminal)
set termguicolors

" Load Lucid color scheme
colorscheme lucid

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
