"This most go first
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" Don't use Ex mode, use Q for formatting
map Q gq

" This is an alternative that also works in block mode, but the deleted
" text is lost and it only works for putting the current register.
vnoremap p "_dp

" Switch syntax highlighting on
syntax on

" Enable file type detection.
" Use the default filetype settings, so that mail gets 'tw' set to 72,
" 'cindent' is on in C files, etc.
" Also load indent files, to automatically do language-dependent indenting.
filetype plugin indent on

" For all text files set 'textwidth' to 78 characters.
autocmd! FileType text setlocal textwidth=78

" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
autocmd! BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
  \   exe "normal g`\"" |
  \ endif


""""""""""""""""""""""""""""""""""""""""""""""""""""""

"see :h 'option' for more info on any of these
set backspace=indent,eol,start " allow backspacing over everything in insert mode
set history=1000 " keep 1000 lines of command line history
set ruler " show the cursor position all the time
set showcmd " display incomplete commands
set hlsearch " highlight bits that match current search (do /asdf<ENTER> to remove)
set incsearch " do incremental searching
set confirm "ask to save instead of failing with an error
set clipboard+=unnamed "by default copy/paste with the X11 clipboard ("* register)
set background=dark "make things look !ugly with a dark background
set listchars=tab:\|\ ,trail:.,extends:>,precedes:<,eol:$ " what to show when I hit :set list
set statusline=%F%m%r%h%w\ [%{GitBranch()}]\ [%Y]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]\ [%04l,%04v][%p%%]\ [LEN=%L]
set laststatus=2 "always show above status line
set mouse=a "allow mouse usage in terms (scrolling, highlighting, pasting, etc.)
set mousehide " Hide the mouse when typing text
set scrolloff=5 "try to keep at least 5 lines above and bellow the cursor when scrolling
set autoindent "enable the following line
set smartindent "do the Right Thing
set nocindent "use indent scripts
set expandtab "tab key -> spaces
set shiftwidth=4 "indent by 4 spaces
set shiftround "round indent to multiples of shiftwidth
set tabstop=8 "tab characters are drawn as 8 spaces
set softtabstop=4 "treat 4 spaces like a tab
set showcmd "show partial commands in the right or the status area
set hidden "allow hidden buffers. VERY GOOD. see help
set nobackup "dont make those filename~ files (they have bitten me many times)
set noswapfile "more trouble than they're worth
set wildmenu "show possible completions in command (:) mode (try hitting tab twice)
set wildmode=list:longest,full "make the wildmenu behave more like bash
set wildignore+=*.o,*.git,*.svn "ignore these files
set wildignore+=*/build/*,*/third_party/* "ignore these dirs
set ignorecase "dont care about case in searches, etc.
set smartcase "care about case if I enter any capital letters
let mapleader = ',' "use , instead of \ as the 'leader' key (used in some plugins)
set nostartofline "don't go to the start of line after certain commands
"set textwidth=80 "wrap at 80 chars
set formatoptions-=o "don't insert comment chars when I hit o or O
"set formatoptions+=a "automatically reflow comment blocks (:h fo-table)
set autoread "automatically reread files that have been updated. useful with git
"set gdefault " the /g flag on :s substitutions by default

let python_highlight_all=1 "highlight everything possible in python
let python_highlight_space_errors=0 "except spacing issues
let perl_extended_vars=1 " highlight advanced perl vars inside strings

set number "show line numbers
"hit F11 to toggle line numbers
nnoremap <silent><F11> :set number!<CR> 

"TagList plugin settings
let Tlist_Exit_OnlyWindow = 1 " if you are the last, kill yourself
let Tlist_Enable_Fold_Column = 0 " Do not show folding tree
let Tlist_Display_Tag_Scope = 1 " Show tag scope next to the tag name.
let Tlist_Use_Right_Window = 1
let Tlist_Show_Menu = 1
let Tlist_Display_Prototype = 0
nnoremap <silent><F7> :w<CR>:TlistUpdate<CR>
nnoremap <silent><F8> :Tlist<CR>

nnoremap <silent><F9> :w<CR>:!pylint -e %<CR>

"make <C-]> use :tagjump
nnoremap <C-]> g<C-]>

nnoremap <C-s> :wa<CR>
vnoremap <C-c> "+y

"use control-[hjkl] to move between windows
nnoremap <silent><C-j> <C-w>j
nnoremap <silent><C-k> <C-w>k
nnoremap <silent><C-l> <C-w>l
nnoremap <silent><C-h> <C-w>h

"use shift-[hl] to move between buffers (tabs if you use MiniBufExplorer)
nnoremap <silent><S-h> :MBEbp<CR>
nnoremap <silent><S-l> :MBEbn<CR>

"use readline maps in command mode
cnoremap <C-a> <HOME>
cnoremap <C-e> <END>

"disable this when in the QuickFix window
"autocmd FileType qf nunmap <S-h>
"autocmd FileType qf nunmap <S-l>
autocmd! FileType qf set nospell
autocmd! FileType conque_term set nospell
autocmd! FileType haskell set nospell

"dont require a shift to enter command mode
nnoremap ; :
"make shift Y behave like shift-[cd] (copy to end of line)
nnoremap Y y$

"a cool debugging line (hit _if in 'normal' (not insert) mode to try it)
nnoremap _if ofprintf(0<C-d>stderr, "{%s}:{%d} - \n", __FILE__, __LINE__);<Esc>F\i 
autocmd! FileType cpp nnoremap _if ocout << __FILE__ << " " << __LINE__  << " " << __FUNCTION__ << " - " << endl;<Esc>F"i 

"auto close {
inoremap {<Enter> {<Enter>}<Esc>O

"Ruby stuffs
autocmd! FileType ruby,eruby let g:rubycomplete_buffer_loading=1
"autocmd FileType ruby,eruby let g:rubycomplete_rails = 1

"clicking on the 'tabs' in the MiniBufExplorer will switch to that buffer
"(even in console)
let g:miniBufExplUseSingleClick=1
let g:miniBufExplMapCTabSwitchBufs=1
let g:miniBufExplorerAutoUpdate = 1
let g:miniBufExplTabWrap = 1
let g:miniBufExplForceSyntaxEnable = 0

let g:SuperTabDefaultCompletionType = "context"
let g:SuperTabContextDefaultCompletionType = "<c-x><c-o>"
"let g:SuperTabMappingForward = "<tab>"


"change inside of a (single-ling) string, see :help objects
nnoremap c' ci'
nnoremap c" ci"
nnoremap cw ciw
nnoremap d' da'
nnoremap d" da"
nnoremap dw daw

" like * but with ctrl find current word in whole project
nnoremap <F7> *N:execute "Ack -w " . expand('<cword>')  <CR><CR>

"use shift-w to save the file as root (I forget to use "sudo vim" a lot)
command! -bar -nargs=0 W  :silent exe "write !sudo tee % >/dev/null"|silent edit!

"autosave on make
cabbr make wa\|make

"better navigation of quickfix list
nnoremap <C-n> :cn<cr>
nnoremap <C-p> :cp<cr>

"better indentation (keeps selection)
vnoremap > >gv
vnoremap < <gv

" use ghc functionality for haskell files
au Bufenter *.hs compiler ghc

" autodetect scons files
au BufNewFile,BufRead SCons* set filetype=scons 

" configure browser for haskell_doc.vim
let g:haddock_browser = "chromium"

" allow use of tab and s-tab in command-t window
let g:CommandTSelectNextMap=['<C-n>', '<C-j>', '<Down>', '<Tab>']
let g:CommandTSelectPrevMap=['<C-p>', '<C-k>', '<Up>', '<S-Tab>']

autocmd! FileType go setlocal sts=4 ts=4 noexpandtab

"If using vim7 
if version >= 700
  autocmd! FileType tex setlocal grepprg=grep\ -nH\ $*
  set spell "enable spell checking use ":set nospell" to turn it off for a single buffer
  set spelllang=en_us "use US dictionary for spelling
  autocmd! FileType ruby,eruby set omnifunc=rubycomplete#Complete "use ruby auto-completion
  set completeopt=longest,menu,preview "make auto-complete less stupid
endif

if version >= 703
    set undofile
    set undodir=~/.vim-undo/
endif

" close the preview window after i'm done with it
"autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
autocmd! InsertLeave * if pumvisible() == 0|pclose|endif

autocmd! BufWritePost .vimrc source %

if filereadable('./SConstruct')
    compiler scons
endif

set exrc
set secure

let g:clang_use_library = 1
"let g:clang_debug = 1

let g:syntastic_enable_signs=1
let g:syntastic_auto_loc_list=1
"SyntasticEnable cpp

let g:space_no_character_movements = 1

"This is needed for alias vimdiff="vimdiff --noplugin"
autocmd! FuncUndefined GitBranch call s:DefGitBranch()
function! s:DefGitBranch()
    function GitBranch()
        return "NONE"
    endfunc
endfunc

"see also: my ~/.gimrc and ~/.vim directory
