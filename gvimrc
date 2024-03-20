" An example for a gvimrc file.
" The commands in this are executed when the GUI is started.
"
" Maintainer:   Bram Moolenaar <Bram@vim.org>
" Last change:  2001 Sep 02
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.gvimrc
"             for Amiga:  s:.gvimrc
"  for MS-DOS and Win32:  $VIM\_gvimrc
"           for OpenVMS:  sys$login:.gvimrc

" Make external commands work through a pipe instead of a pseudo-tty
"set noguipty

" set the X11 font to use
" set guifont=-misc-fixed-medium-r-normal--14-130-75-75-c-70-iso8859-1

"set cmdheight=2                " Make command line two lines high


" Make shift-insert work like in Xterm
imap <S-Insert> <c-r>*
nmap <S-Insert> "*p

" Only do this for Vim version 5.0 and later.
if v:version >= 500
  augroup gvimrc
      au!
  augroup END

  " Set nice colors
  " background for normal text is light grey
  " Text below the last line is darker grey
  " Cursor is green, Cyan when ":lmap" mappings are active
  " Constants are not underlined but have a slightly lighter background

  if 0
      let s:usingWombat = 1
      if s:usingWombat
          try
              "colorscheme solarized
              "colorscheme wombat
              colorscheme wombat256
              highlight SpellBad ctermbg=52 guibg=#330000 cterm=undercurl guisp=Red
          catch
              let s:usingWombat = 0
          endtry
      endif

      if !s:usingWombat
          highlight Normal guibg=black guifg=grey
          highlight NonText guibg=black guifg=magenta
          highlight Cursor guibg=Green guifg=NONE
          highlight lCursor guibg=Cyan guifg=NONE
          highlight PMenu guibg=brown gui=bold
          highlight Folded guibg=#333333 
          highlight FoldColumn	 guibg=#333333 
          highlight LineNr	 guibg=#1a1a1a
          highlight Visual	 gui=inverse guibg=black
      endif
  endif

  set guioptions-=T
  "set guifont=Monospace\ 9
  "set guifont=Fira\ Code\ Medium\ 9
  "set guifont=Victor\ Mono\ Semibold\ 9
  "set guifont=VictorMono\ Nerd\ Font\ Semibold\ 9

  if !has('nvim')
      "make the balloon feature work
      set ballooneval

      function! MyRtagsBalloon()
          let loc = printf('%s:%s:%s', bufname(v:beval_bufnr), v:beval_lnum, v:beval_col)
          let output = system('rc -U ' . loc )
          return matchstr(output, 'Type: \zs[^\n]*')
                      \ . matchstr(output, '\nsizeof: [^\n]*')
                      \ . matchstr(output, '\nalignment[^\n]*')
      endfunction

      augroup gvimc
          autocmd FileType c,cpp setlocal balloonexpr=MyRtagsBalloon()
      augroup END

      "highlight MyCurword guibg=#134
      highlight MyCurword guibg=#111122 gui=bold guifg=white
      " cterm=bold ctermfg=white
      augroup gvimrc
          autocmd InsertEnter *.{cpp,c,h,hpp} syntax clear MyCurword
          autocmd CursorHold *.{cpp,c,h,hpp} syntax clear MyCurword | if len(expand('<cword>')) && match(expand('<cword>'), '\W') == -1 | exe "syntax keyword MyCurword " . expand("<cword>") |endif 
      augroup END
  endif

  " Use images for ycm errors
  let g:ycm_error_symbol='EE icon=/usr/share/icons/gnome/16x16/status/dialog-error.png'
  let g:ycm_warning_symbol='WW icon=/usr/share/icons/gnome/16x16/status/dialog-warning.png'

  highlight clear SignColumn
  highlight link SignColumn LineNr

  "let g:ale_sign_error='EE icon=/usr/share/icons/gnome/16x16/status/dialog-error.png'
  "let g:ale_sign_warning='WW icon=/usr/share/icons/gnome/16x16/status/dialog-warning.png'

  " Make back and forward buttons work.
  nnoremap <X1Mouse> <C-o>
  nnoremap <X2Mouse> <C-i>
  "nnoremap <ScrollWheelLeft> <C-o>
  "nnoremap <ScrollWheelRight> <C-i>

  " Make double click be goto and right-click be find refs
  "augroup gvimc
          "autocmd FileType c,cpp nmap <buffer> <2-leftmouse> ,rj
          "autocmd FileType c,cpp nmap <buffer> <rightmouse> <leftmouse>,rf
          "autocmd FileType javascript nmap <buffer> <2-leftmouse> <a-]>
  "augroup END

endif

if has("gui_running") && !has("nvim")
    set guiligatures=!\"#$%&()*+-./:<=>?@[]^_{\|~
    set guifont=VictorMono\ Nerd\ Font\ Semibold\ 10
endif

if exists('g:GtkGuiLoaded')
    "call rpcnotify(1, 'Gui', 'Font', 'Fira Code Retina 6')
    call rpcnotify(1, 'Gui', 'Option', 'Tabline', 0)
    call rpcnotify(1, 'Gui', 'Option', 'Popupmenu', 0)
    if filereadable("/usr/share/nvim-gtk/runtime/nvim_gui_shim.vim")
        unlet g:GuiLoaded
        source /usr/share/nvim-gtk/runtime/nvim_gui_shim.vim
    endif
    "GuiFont Fira Code Retina 9
    set guifont=VictorMono\ Nerd\ Font\ Semibold\ 10
    "set guifont=Victor\ Mono\ Semibold\ 9
endif

if exists('g:GuiLoaded') && &guifont == ''
  GuiFont! VictorMono Nerd Font:h9:sb
  GuiRenderLigatures 1
endif

if exists('g:neovide')
    set guifont=Victor\ Mono:h9
    let g:neovide_cursor_animation_length = 0.02
    let g:neovide_cursor_trail_size = 0.2
endif


if exists('g:fvim_loaded')
    set guifont=Fira\ Code\ Retina:h12
    FVimCursorSmoothMove v:false
    FVimFontSubpixel v:true
    FVimFontLcdRender v:true
    FVimFontAntialias v:true
    FVimFontAutohint v:false
    FVimFontAutoSnap v:false
endif

