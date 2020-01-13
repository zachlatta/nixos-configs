" When wrapping lines, don't split words in two. Wrap at word end.
set linebreak

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
