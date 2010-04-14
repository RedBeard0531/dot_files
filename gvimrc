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

set ch=2                " Make command line two lines high


" Make shift-insert work like in Xterm
map <S-Insert> <MiddleMouse>
map! <S-Insert> <MiddleMouse>

" Only do this for Vim version 5.0 and later.
if version >= 500

  " I like highlighting strings inside C comments
  let c_comment_strings=1

  " Switch on syntax highlighting if it wasn't on yet.
  if !exists("syntax_on")
    syntax on
  endif

  " Switch on search pattern highlighting.
  set hlsearch

  " For Win32 version, have "K" lookup the keyword in a help file
  "if has("win32")
  "  let winhelpfile='windows.hlp'
  "  map K :execute "!start winhlp32 -k <cword> " . winhelpfile <CR>
  "endif

  " Set nice colors
  " background for normal text is light grey
  " Text below the last line is darker grey
  " Cursor is green, Cyan when ":lmap" mappings are active
  " Constants are not underlined but have a slightly lighter background

  highlight Normal guibg=black guifg=grey
  highlight NonText guibg=black guifg=magenta
  highlight Cursor guibg=Green guifg=NONE
  highlight lCursor guibg=Cyan guifg=NONE
  highlight PMenu guibg=brown gui=bold
  highlight Folded guibg=#333333 
  highlight FoldColumn	 guibg=#333333 
  set background=dark

  set updatetime=1000 " miliseconds - time before CursorHold fires
  highlight Curword guibg=#334
  autocmd InsertEnter *.{cpp,c,h} syntax clear Curword
  autocmd CursorHold *.{cpp,c,h} syntax clear Curword | if len(expand('<cword>')) && match(expand('<cword>'), '\W') == -1 | exe "syntax keyword Curword " . expand("<cword>") |endif 

  set spelllang=en_us
  :map K :!xterm -bg black -fg gray -e "man <cword>"<cr><cr> 
endif

