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
    let $NVIM_GTK_PREFER_DARK_THEME=1
    let $NVIM_GTK_NO_WINDOW_DECORATION=1
    call rpcnotify(1, 'Gui', 'Font', 'Fira Code Medium 9')
    call rpcnotify(1, 'Gui', 'Option', 'Tabline', 0)
    call rpcnotify(1, 'Gui', 'Option', 'Popupmenu', 0)
endif
