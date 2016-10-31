" for neovim, just use gvim config
source ~/.vimrc
source ~/.gvimrc

tnoremap <Esc> <C-\><C-n>
tmap <C-j> <ESC><C-j>
tmap <C-h> <ESC><C-h>
tmap <C-l> <ESC><C-l>
tmap <C-k> <ESC><C-k>
autocmd BufEnter term://* startinsert

let $TERM='xterm-256-color'

