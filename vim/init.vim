" for neovim, just use gvim config
"let $TERM='xterm-kitty'
source ~/.vimrc
"source ~/.gvimrc


tnoremap <Esc> <C-\><C-n>
tmap <C-j> <ESC><C-j>
tmap <C-h> <ESC><C-h>
tmap <C-l> <ESC><C-l>
tmap <C-k> <ESC><C-k>
augroup init_vim
    au!
    au BufEnter term://* startinsert
augroup END

if exists('g:GtkGuiLoaded')
    call rpcnotify(1, 'Gui', 'Font', 'Fira Code Medium 9')
    call rpcnotify(1, 'Gui', 'Option', 'Tabline', 0)
endif
