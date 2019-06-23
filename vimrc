scriptencoding utf-8

let s:use_coc =  1

" Using vim-plug. See https://github.com/junegunn/vim-plug#installation.
" I use the full github urls to make it easier to see more details about each plugin (try typing gx
" over a url). Within each section, plugins are roughly sorted by "value" so the plugins I use most
" often are at the top.
call plug#begin('~/.vim/plugged')

" Vimscript enhancements
Plug 'https://github.com/tpope/vim-repeat.git' " makes . and u work better with plugins
Plug 'https://github.com/tpope/vim-scriptease' " helpers when writing vimscript

" Vim editing enhancements
Plug 'https://github.com/easymotion/vim-easymotion' " Jump anywhere you can see super fast
Plug 'https://github.com/tpope/vim-surround' " commands for adding or changing surroundings
Plug 'https://github.com/wellle/targets.vim' " More text objects (daa to delete an argument)
Plug 'https://github.com/sfiera/vim-emacsmodeline' " Teach vim to understand emacs modelines
Plug 'https://github.com/AndrewRadev/dsf.vim' " dsf -> Delete Surrounding Function call
Plug 'https://github.com/tweekmonster/braceless.vim' " text objects for indentation-based languages
"Plug 'https://github.com/junegunn/vim-peekaboo' " show contents of registers before use
Plug 'https://github.com/tpope/vim-endwise' " End block in languages that use words for blocks
Plug 'https://github.com/tpope/vim-commentary' " comment things out
Plug 'https://github.com/mbbill/undotree' " visualize the undo tree (:h undo-tree)
Plug 'https://github.com/mjbrownie/swapit' " <c-a>/<c-x> to toggle more things (like true/false)
Plug 'https://github.com/kshenoy/vim-signature' " put marks in the sign column ... meh
Plug 'https://github.com/lfv89/vim-interestingwords' " highlight interesting words with <leader>k
Plug 'https://github.com/mhinz/vim-startify'
Plug 'https://github.com/chrisbra/unicode.vim'

" Misc stuff
Plug 'https://github.com/wincent/command-t',
            \ {'do': 'cd ruby/command-t/ext/command-t && ruby extconf.rb && make'}
            \ " <leader>t to jump to files with fuzzy search
Plug 'https://github.com/mileszs/ack.vim' " :Ack command (better grep using ag)
Plug 'https://github.com/RedBeard0531/bufkill.vim' " :BW is like :bw without closing the window
Plug 'https://github.com/Valloric/ListToggle' " <leader>q and l to toggle quickfix and location lists
Plug 'https://github.com/skywind3000/asyncrun.vim' " Run builds in the background into quickfix
"Plug 'https://github.com/oplatek/Conque-Shell' " terminal in vim
Plug 'https://github.com/metakirby5/codi.vim' " Live programing output

" C++ stuff
Plug 'https://github.com/Shougo/echodoc.vim' " Show signature at bottom of window
Plug 'https://github.com/vim-scripts/a.vim' " :A to switch between .cpp and .h
Plug 'https://github.com/majutsushi/tagbar' " shows tags on side (and can tell you current function)

" JS stuff
Plug 'https://github.com/marijnh/tern_for_vim', {'do': 'npm install'} " JS autocomplete
Plug 'https://github.com/pangloss/vim-javascript.git' " Better js indent and syntax
Plug 'https://github.com/leafgarland/typescript-vim'

" Python stuff
Plug 'https://github.com/Vimjas/vim-python-pep8-indent' " better python indentation
Plug 'https://github.com/raimon49/requirements.txt.vim' " highlighting for requirements.txt

" Other filetype-specific stuff
"Plug 'https://github.com/suan/vim-instant-markdown' " show rendered output as you edit
Plug 'https://github.com/rhysd/vim-gfm-syntax' " highlight github-flavored markdown
Plug 'https://github.com/elzr/vim-json' " Better json syntax + concealing noise
Plug 'https://github.com/sukima/xmledit' " XML and HTML helpers
Plug 'https://github.com/zah/nim.vim' " Nim language support
"Plug 'https://github.com/baabelfish/nvim-nim' " Nim language support

" Git stuff
Plug 'https://github.com/airblade/vim-gitgutter.git' " show changed lines in gutter
Plug 'https://github.com/wincent/terminus' " make terminal vim more like gvim
Plug 'https://github.com/tpope/vim-fugitive.git' " Git integration
Plug 'https://github.com/tpope/vim-rhubarb' " Github support for fugitive
Plug 'https://github.com/tommcdo/vim-fugitive-blame-ext' " Show commit summary for line in :Gblame
Plug 'https://github.com/jreybert/vimagit' " :Magit to see overview of current changes
Plug 'https://github.com/rhysd/conflict-marker.vim' " Add [x and ]x to hop between conflicts
Plug 'https://github.com/gregsexton/gitv.git' " like git log in vim
Plug 'https://github.com/rhysd/git-messenger.vim'

" Eye candy
"Plug 'https://github.com/Lokaltog/vim-powerline.git', {'branch': 'develop'}
Plug 'https://github.com/vim-airline/vim-airline' " Make the statusline look better
Plug '~/.vim/bundle/vim-wombat' " my fork of https://github.com/cschlueter/vim-wombat
Plug 'https://github.com/morhetz/gruvbox'

if s:use_coc
    Plug 'https://github.com/neoclide/coc.nvim', {'do': {-> coc#util#install()}}
    Plug 'https://github.com/m-pilia/vim-ccls'
    Plug 'https://github.com/tjdevries/coc-zsh'
    Plug 'https://github.com/Shougo/neco-vim'
    Plug 'https://github.com/neoclide/coc-neco'
else
    Plug 'https://github.com/Valloric/YouCompleteMe',
                \ {'do': 'python3 ./install.py --clang-completer --clangd-completer --js-completer'}
                \ " Awesome autocompletion with fuzzy search
    Plug '~/.vim/bundle/vim-rtags' " Integration with the rtags indexer
                                   " my fork of 'https://github.com/lyuts/vim-rtags'
    Plug 'https://github.com/w0rp/ale' " Async lint engine (background check of eslint and such)
endif
call plug#end()


" Don't use Ex mode, use Q for formatting
map Q gq
" This is an alternative that also works in block mode, but the deleted
" text is lost and it only works for putting the current register.
vnoremap p "_dp

" This block contains stuff that causes problems when re-sourcing vimrc.
if !exists('s:first_load')
    let s:first_load = 1
    " Switch syntax highlighting on
    "syntax on
    set background=dark "make things look !ugly with a dark background
    "set completeopt=longest,menuone,preview "make auto-complete less stupid
endif

" Enable file type detection.
" Use the default filetype settings, so that mail gets 'tw' set to 72,
" 'cindent' is on in C files, etc.
" Also load indent files, to automatically do language-dependent indenting.
filetype plugin indent on

"clear all vimrc autocmds
augroup vimrc
    autocmd!
augroup END

" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
augroup vimrc
    autocmd BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$") |
      \   exe "normal g`\"" |
      \ endif
augroup END


""""""""""""""""""""""""""""""""""""""""""""""""""""""

"see :h 'option' for more info on any of these
set backspace=indent,eol,start " allow backspacing over everything in insert mode
set history=10000 " keep a lot of command line history
set ruler " show the cursor position all the time
set showcmd " display incomplete commands
set hlsearch " highlight bits that match current search (do /asdf<ENTER> or :nohl to remove)
set incsearch " do incremental searching
set confirm "ask to save instead of failing with an error
set clipboard^=unnamedplus "by default copy/paste with the X11 clipboard ("+ register)
set listchars=tab:\|\ ,trail:.,extends:>,precedes:<,eol:$ " what to show when I hit :set list
"set statusline=%F%m%r%h%w\ [%{GitBranch()}]\ [%Y]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]\ [%04l,%04v][%p%%]\ [LEN=%L]
set laststatus=2 "always show above status line
set mouse=a "allow mouse usage in terms (scrolling, highlighting, pasting, etc.)
set mousehide " Hide the mouse when typing text
set scrolloff=5 "try to keep at least 5 lines above and bellow the cursor when scrolling
set sidescrolloff=10 "ditto for side-scolling
set autoindent "enable the following line
set smartindent "do the Right Thing
set cinoptions=l1,g0,N-s,(0,u0,Ws,k2s,j1,J1,)1000,*1000 " setup cindent correctly. see :help cinoptions-values
set expandtab "tab key -> spaces
set shiftwidth=4 "indent by 4 spaces
set noshiftround "don't round indent to multiples of shiftwidth
set tabstop=8 "tab characters are drawn as 8 spaces
set softtabstop=4 "treat 4 spaces like a tab
set showcmd "show partial commands in the right or the status area
set hidden "allow hidden buffers. VERY GOOD. see help
set nobackup "dont make those filename~ files (they have bitten me many times)
set noswapfile "more trouble than they're worth
set wildmenu "show possible completions in command (:) mode (try hitting tab twice)
set wildmode=list:longest,full "make the wildmenu behave more like bash
set wildignore+=tags,*.o,*.git,*.svn,*.pyc "ignore these files
set ignorecase "dont care about case in searches, etc.
set smartcase "care about case if I enter any capital letters
let g:mapleader = ',' "use , instead of \ as the 'leader' key (used in some plugins)
set nostartofline "don't go to the start of line after certain commands
set formatoptions-=o "don't insert comment chars when I hit o or O
set formatoptions+=j " remove comment mark when joining lines
"set formatoptions+=a "automatically reflow comment blocks (:h fo-table)
set autoread "automatically reread files that have been updated. useful with git
set virtualedit=block " allow block selections to go past the end of lines
set notimeout ttimeout " wait for me to finish mapping, but don't wait for terminal escape codes.
set ttimeoutlen=100 " don't wait more then X ms for terminal escape codes
set title " update titlebar
set updatetime=250 " miliseconds - time before CursorHold fires
set lazyredraw " don't waste time updating screen while executing macros
set number "show line numbers
set exrc "run .vimrc files in pwd
set secure "don't let .vimrc files owned by other users do stupid things
"set spell "enable spell checking use ":set nospell" to turn it off for a single buffer
set spelllang=en_us "use US dictionary for spelling
set belloff=all "I hate that bell...
set undofile "keep persistent undo across vim runs
set undodir=~/.vim-undo/ "where to store undo files
set splitright " Make :vsplit put new window to the right, where it belongs
set viminfo='100,<50,s1,h,f0 "limit the viminfo size to speed startup.
set nojoinspaces " only add one space after punctuation when joining lines.
set previewheight=20 " bigger preview window
set helplang=en

if !isdirectory(&undodir)
    if confirm("Undo dir '".&undodir."' doesn't exist. Create?", "&Yes\n&No") == 1
        call mkdir(&undodir, 'p')
    endif
endif

"Make :make and friends work with python exceptions.
if !exists('s:python_errorformat') " don't append it multiple times.
    let s:python_errorformat='\  File "%f"\, line %l,\  File "%f"\, line %l\, in %m'
    let &errorformat .= ','.s:python_errorformat
endif

" Use xdg-open for gx action to open url as webpage.
if !empty($DISPLAY) && empty($SSH_CONNECTION) && executable('xdg-open')
    let g:netrw_browsex_viewer = 'xdg-open'
endif

if $TERM ==# 'xterm-256color' || $TERM ==# 'xterm-kitty'
    if $TERM ==# 'xterm-kitty' || $GNOME_TERMINAL_SCREEN !=# ''
        set termguicolors " use gui colors in terminal
        set t_ut= "unbreak bg colors when scrolling
    endif
    if 1
        colorscheme wombat256
        highlight GitGutterAdd    guifg=#009900 guibg=#121212 ctermfg=2
        highlight GitGutterChange guifg=#bbbb00 guibg=#121212 ctermfg=3
        highlight GitGutterDelete guifg=#ff2222 guibg=#121212 ctermfg=1
    else
        let g:gruvbox_italic=1
        let g:gruvbox_improved_strings=0
        let g:gruvbox_improved_warnings=1
        let g:gruvbox_contrast_dark='hard'
        let g:gruvbox_italicize_comments=0
        colorscheme gruvbox
    endif
else
    colorscheme wombat
endi

if 1 || $TERM ==# 'xterm-kitty' || $GNOME_TERMINAL_SCREEN !=# ''
    " gnome-terminal 3.28 and kitty support undercurl!
    if !has('nvim') && 0
        "exec "set t_Ce=\e[4:0m\e[59m"
        exec "set t_Cs=\e[4:3m\e[58;5;9m"
    endif
    highlight SpellBad cterm=undercurl guisp=red guibg=Black
    highlight SpellCap cterm=undercurl guisp=cyan guibg=Black
    highlight SpellRare cterm=undercurl guisp=green guibg=Black
    highlight SpellLocal cterm=undercurl guisp=orange guibg=Black
    "highlight SpellLocal guibg=Black
else
    " Subtle but noticeable highlighting for misspelled words
    highlight SpellBad ctermbg=52 guibg=#330000 cterm=undercurl guisp=Red
endif

if !has('nvim') 
    "make <A-]> work in terminal vim
    exec "set <A-]>=\e]"
endif

let $LC_ALL='C' " disable locale-aware sort

let g:c_comment_strings=1 " I like highlighting strings inside C comments
let g:python_highlight_all=1 "highlight everything possible in python
let g:python_highlight_space_errors=0 "except spacing issues
let g:perl_extended_vars=1 " highlight advanced perl vars inside strings

"TagList plugin settings
let g:Tlist_Exit_OnlyWindow = 1 " if you are the last, kill yourself
let g:Tlist_Enable_Fold_Column = 0 " Do not show folding tree
let g:Tlist_Display_Tag_Scope = 1 " Show tag scope next to the tag name.
let g:Tlist_Use_Right_Window = 1
let g:Tlist_Show_Menu = 1
let g:Tlist_Display_Prototype = 0
nnoremap <silent><F7> :w<CR>:TlistUpdate<CR>
nnoremap <silent><F8> :Tlist<CR>

"make <C-]> use :tagjump
nnoremap <C-]> g<C-]>

nnoremap <C-s> :wa<CR>
vnoremap <C-c> "+y

"use control-[hjkl] to move between windows
nnoremap <silent><C-j> <C-w>j
nnoremap <silent><C-k> <C-w>k
nnoremap <silent><C-l> <C-w>l
nnoremap <silent><C-h> <C-w>h

tnoremap <silent><C-j> <C-w>j
tnoremap <silent><C-k> <C-w>k
tnoremap <silent><C-l> <C-w>l
tnoremap <silent><C-h> <C-w>h
" shift-escape to exit terminal mode (at least on mintty/cygwin and gvim)
tnoremap <silent> <C-\><C-n>
tnoremap <silent><S-Esc> <C-\><C-n>
au vimrc BufWinEnter * if &buftype == 'terminal' | setlocal nospell | endif

"use readline maps in command mode
cnoremap <C-a> <HOME>
cnoremap <C-e> <END>

nmap <2-LeftMouse> gd
nnoremap <M-Left> <C-o>
nnoremap <M-Right> <C-i>

"dont require a shift to enter command mode
nnoremap ; :

"make cmdwin mode easier to use
"nnoremap q; q:
augroup vimrc
    autocmd CmdWinEnter * nnoremap <silent><buffer><esc> :q<cr>
augroup end

"make shift Y behave like shift-[cd] (copy to end of line)
nnoremap Y y$

"kill the search highlight. (Note: this is different from :set nohlsearch)
nnoremap <silent> <leader><leader> :nohlsearch<CR>

"add c++ stdlib headers to path
set path^=/usr/include/c++/*
set path^=/usr/include/c++/*/x86_64*

" FileType specific configs
augroup vimrc
    autocmd FileType cpp,c,cuda,python,gitcommit,vim,markdown,javascript setlocal spell
    autocmd FileType haskell,strace,json setlocal nospell

    autocmd FileType cpp setlocal matchpairs+=<:> " make % bounce between < and >
    autocmd FileType gitcommit setlocal textwidth=78 colorcolumn=+1
    autocmd FileType go setlocal sts=4 ts=4 noexpandtab
    autocmd FileType tex setlocal grepprg=grep\ -nH\ $*
    autocmd FileType yaml setlocal sts=2 sw=2
    autocmd FileType text setlocal textwidth=78
    autocmd FileType git,fugitiveblame setlocal nospell colorcolumn=0
    autocmd FileType gitrebase setlocal cursorline
    autocmd FileType qf,man setlocal nospell colorcolumn=0
    autocmd FileType qf nnoremap <buffer><C-CR> <CR>:cclose<CR>
    "autocmd FileType qf setlocal scrolloff=0 " grrr global
    autocmd FileType ruby,eruby setlocal omnifunc=rubycomplete#Complete
    autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading=1
    "autocmd FileType ruby,eruby let g:rubycomplete_rails = 1
    autocmd BufEnter *.log setlocal nospell nowrap tw=0
    "autocmd FileType python BracelessEnable +indent +highlight
augroup END

if !s:use_coc
augroup vimrc
    autocmd FileType c,cpp nnoremap <buffer>T :YcmCompleter GetType<CR>
    autocmd FileType c,cpp nnoremap <buffer><C-t> :YcmCompleter FixIt<CR>
    autocmd FileType c,cpp,python nnoremap <silent><buffer><A-]> :YcmComplete GoTo<CR>
    autocmd FileType c,cpp nnoremap <silent><buffer><D-]> :YcmComplete GoToDeclaration<CR>
    "autocmd FileType javascript nnoremap <silent><buffer><A-]> :YcmComplete GoTo<CR>
    "autocmd FileType javascript nnoremap <buffer>T :YcmCompleter GetType<CR>
    autocmd FileType javascript nnoremap <silent><buffer><A-]> :TernDef<CR>
    autocmd FileType javascript nnoremap <buffer>T :TernType<CR>
augroup END
endif

let g:undotree_DiffCommand = 'diff -u'
let g:undotree_SplitWidth = 30
let g:undotree_DiffpanelHeight = 20
let g:undotree_WindowLayout = 2 " wide diff view

let g:ackprg='rg --vimgrep'

"change inside of a (single-ling) string, see :help objects
nnoremap c'  ci'
nnoremap c"  ci"
nnoremap cw  ciw
nnoremap cW  ciW
nnoremap d'  da'
nnoremap d"  da"
nnoremap dw  daw
nnoremap dW  daW
nnoremap ysw ysiw
nnoremap ysW ysiW

function! GrepForWord(word)
    let @/ = '\<'.a:word.'\>'
    exec 'AckFromSearch!'
endfunction

" like * but with ctrl find current word in whole project
"nnoremap <silent><F7> *N:execute "silent Ggrep -w " . expand('<cword>')  <CR><CR>
nnoremap <silent><F7> :silent call GrepForWord(expand('<cword>'))<CR>

" open the quickfix windown whenever something adds to it
augroup vimrc
    autocmd QuickFixCmdPost * nested botright copen 10
augroup END

"use F11/F12 to move to older/newer quickfix lists
nnoremap <silent><F11> :colder<CR>
nnoremap <silent><F12> :cnewer<CR>

"use shift-w to save the file as root (I forget to use "sudo vim" a lot)
command! -bar -nargs=0 W  :silent exe "write !sudo tee % >/dev/null"|silent edit!

"better navigation of quickfix list
nnoremap <C-n> :cn<cr>
nnoremap <C-p> :cp<cr>

"better navigation of location list
nnoremap <A-N> :lnext<cr>

"better indentation (keeps selection)
vnoremap > >gv
vnoremap < <gv

augroup vimrc
    " use ghc functionality for haskell files
    autocmd Bufenter *.hs nested compiler ghc

    " autodetect scons files
    autocmd BufNewFile,BufRead SCons* nested setlocal filetype=scons
augroup END

" configure browser for haskell_doc.vim
let g:haddock_browser = 'chromium'

" allow use of tab and s-tab in command-t window
let g:CommandTCancelMap = ['<C-c>', '<S-Esc>', "\x9b"]
let g:CommandTSelectNextMap=['<C-n>', '<C-j>', '<Down>', '<Tab>']
let g:CommandTSelectPrevMap=['<C-p>', '<C-k>', '<Up>', '<S-Tab>']
let g:CommandTTraverseSCM='pwd'
let g:CommandTFileScanner='ruby'
let g:CommandTMaxHeight=0
let g:CommandTAcceptSelectionCommand='edit'
let g:CommandTAcceptSelectionSplitCommand='sp'
let g:CommandTAcceptSelectionVSplitCommand='vs'
"let g:CommandTMatchWindowReverse=0

augroup vimrc
    " close the preview window after i'm done with it
    "autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
    autocmd InsertLeave * if getcmdwintype() == '' && pumvisible() == 0|pclose|endif

    " Reload vimrc on save
    autocmd BufWritePost {.,}vimrc nested silent source %

    " Hack to make file paths relative. (Might be too slow)
    " autocmd BufNew * cd .
augroup END

"let g:ycm_enable_diagnostic_signs = 0 " interferes with git-gutter which is more valuable
let g:ycm_extra_conf_globlist = ['~/10gen/*']
let g:ycm_always_populate_location_list = 1
let g:ycm_filepath_completion_use_working_dir = 1
let g:ycm_open_loclist_on_ycm_diags = 1
let g:ycm_global_ycm_extra_conf = '~/.vim/ycm_extra_conf.py'
let g:ycm_collect_identifiers_from_tags_files = 0
let g:ycm_complete_in_comments = 0
let g:ycm_python_binary_path = '/usr/bin/python2' " for now at least
let g:ycm_semantic_triggers = {'nim': ['.']}
"let g:ycm_key_invoke_completion = '<tab>' " doesn't work :(
let g:ycm_filepath_blacklist = {
      \ 'os': 1,
      \ 'o': 1,
      \ 'd': 1,
      \}
let g:ycm_semantic_triggers =  {
  \   'cpp,cuda,objcpp': ['->', '.', '::', 're!\b[_a-zA-z][_a-zA-Z0-9]'],
  \ }
"let g:ycm_min_num_of_chars_for_completion = 99
let g:ycm_use_clangd = 1
let g:ycm_clangd_uses_ycmd_caching = 0
let g:ycm_clangd_args = ['-background-index', '-all-scopes-completion', '-completion-style=bundled']
let g:ycm_clangd_binary_path = '/bin/clangd'

let g:SignatureMarkTextHLDynamic=1 " make signature colors match gitgutter's

let g:space_no_character_movements = 1

if filereadable(expand('~/.fonts/DejaVuSansMono-Powerline.ttf'))
    let g:Powerline_symbols = 'fancy'
    if !exists('g:airline_symbols')
        let g:airline_symbols = {}
        "let g:airline_symbols.space = "\ua0"
    endif
    let g:airline_left_sep = '⮀'
    let g:airline_left_alt_sep = '⮁'
    let g:airline_right_sep = '⮂'
    let g:airline_right_alt_sep = '⮃'
    let g:airline_symbols.branch = '⭠'
    let g:airline_symbols.readonly = '⭤'
    let g:airline_symbols.linenr = '⭡'
    let g:airline_symbols.maxlinenr = ''
endif

let g:airline_highlighting_cache = 1
let g:airline_detect_spell=0
let g:airline_skip_empty_sections = 0
"let g:airline#extensions#default#layout = [
      \ ['a', 'b', 'c', 'gutter'],
      \ ['error', 'warning', 'x', 'y', 'z']]

let g:airline#parts#ffenc#skip_expected_string='utf-8[unix]'

let g:airline#extensions#tabline#enabled = 0
"let g:airline#extensions#tabline#left_sep = '|'
"let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#extensions#tabline#buffer_min_count = 2

let g:airline#extensions#ycm#enabled = 1
"let g:airline#extensions#ycm#error_symbol = '𝐄'
let g:airline#extensions#ycm#error_symbol = '🔥'
"let g:airline#extensions#ycm#warning_symbol = 'W'
let g:airline#extensions#ycm#warning_symbol = '🏴'

let g:airline#extensions#tagbar#enabled = 0
let g:airline#extensions#tagbar#flags = 'f'

let g:airline#extensions#hunks#enabled = 0
let g:airline#extensions#whitespace#enabled = 0

let g:rtagsUseLocationList=0

" enable :Man and <leader>K mappings
runtime! ftplugin/man.vim

runtime! macros/matchit.vim

"This is needed for alias vimdiff="vimdiff --noplugin"
function! s:DefGitBranch()
    function GitBranch()
        return 'NONE'
    endfunc
endfunc
augroup vimrc
    autocmd FuncUndefined GitBranch call s:DefGitBranch()
augroup END

let g:EasyMotion_smartcase = 1
let g:EasyMotion_verbose = 0
let g:EasyMotion_startofline = 0

map <space> <Plug>(easymotion-prefix)
"map <plug>(easymotion-prefix)<space> <Plug>(easymotion-jumptoanywhere)
map <plug>(easymotion-prefix)<space> <Plug>(easymotion-bd-w)
map <plug>(easymotion-prefix)w <Plug>(easymotion-bd-w)
map <plug>(easymotion-prefix)e <Plug>(easymotion-bd-e)
map <plug>(easymotion-prefix)/ <Plug>(easymotion-sn)
map <plug>(easymotion-prefix)l <Plug>(easymotion-bd-jk)
map <plug>(easymotion-prefix)L <Plug>(easymotion-overwin-line)
"nmap <plug>(easymotion-prefix)s <Plug>(easymotion-overwin-f2)
nmap <plug>(easymotion-prefix)s <Plug>(easymotion-s)
nmap S <plug>(easymotion-s)

" make plugins that use :Make use AsyncRun
command! -bang -nargs=* -complete=file Make AsyncRun -program=make @ <args>

let g:ale_linters = {}
let g:ale_linters.cpp = []
let g:ale_linters.c = []
let g:ale_vim_vint_show_style_issues = 0
let g:ale_python_pylint_options='--errors-only' " don't complain about python style

let g:markdown_fenced_languages = ['cpp', 'python', 'vim', 'bash']
let g:gfm_syntax_emoji_conceal = 1

let g:LanguageClient_loadSettings = 1
let g:LanguageClient_selectionUI = 'location-list'
let g:LanguageClient_serverCommands = {
\ 'cpp': ['cquery', '--log-file=/tmp/cq.log']
\ }

set noshowmode
let g:echodoc#enable_at_startup = 1

let g:vim_json_warnings = 0

let g:startify_change_to_dir = 0
let g:startify_enable_unsafe = 1
let g:startify_bookmarks = [
    \ {'v': '~/.vimrc'},
    \ {'c': '~/.vim/coc.vim'},
    \ {'z': '~/.zshrc'},
    \ ]

"show current function in "tabline" using tagbar function
try
    call tagbar#currenttag('%s','','fs') " make sure this works
    set tabline=%{tagbar#currenttag('%s','','fs')}
    set showtabline=2 " show tabline even if only one tab
    "autocmd vimrc CursorHold * let &ro = &ro "no-op that causes tabline to update
    if exists('&guioptions')
        " Don't use the gui tabline
        set guioptions-=e
    endif
catch
    "ignore failure
endtry

"auto close {
function! s:CloseBracket()
    let line = getline('.')
    if line =~# '^\s*\(struct\|class\|enum\) '
        return "{\<Enter>};\<Esc>O"
    elseif searchpair('(', '', ')', 'bmn', '', line('.'))
        " Probably inside a function call. Close it off.
        return "{\<Enter>});\<Esc>O"
    else
        return "{\<Enter>}\<Esc>O"
    endif
endfunctio
inoremap <expr> {<Enter> <SID>CloseBracket()

if s:use_coc
    runtime coc.vim
else
endif

"see also: my ~/.gimrc and ~/.vim directory
