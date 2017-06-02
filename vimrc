scriptencoding utf-8

"This most go first
call pathogen#infect()
call pathogen#helptags()

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
"set nocompatible

" Don't use Ex mode, use Q for formatting
map Q gq
" This is an alternative that also works in block mode, but the deleted
" text is lost and it only works for putting the current register.
vnoremap p "_dp

" This block does causes problems when re-sourcing vimrc.
if !exists('g:syntax_on')
    " runtime defaults.vim

    " Switch syntax highlighting on
    syntax on
    set background=dark "make things look !ugly with a dark background
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
"set autoindent "enable the following line
"set smartindent "do the Right Thing
"set nocindent "use indent scripts
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
set wildignore+=*.o,*.git,*.svn "ignore these files
set ignorecase "dont care about case in searches, etc.
set smartcase "care about case if I enter any capital letters
let g:mapleader = ',' "use , instead of \ as the 'leader' key (used in some plugins)
set nostartofline "don't go to the start of line after certain commands
"set textwidth=80 "wrap at 80 chars
set formatoptions-=o "don't insert comment chars when I hit o or O
set formatoptions+=j " remove comment mark when joining lines
"set formatoptions+=a "automatically reflow comment blocks (:h fo-table)
set autoread "automatically reread files that have been updated. useful with git
"set gdefault " the /g flag on :s substitutions by default
set virtualedit=block " allow block selections to go past the end of lines
set notimeout ttimeout " wait for me to finish mapping, but don't wait for terminal escape codes.
set ttimeoutlen=100 " don't wait more then X ms for terminal escape codes
set title " update titlebar
set updatetime=250 " miliseconds - time before CursorHold fires
set lazyredraw " don't waste time updating screen while executing macros
set number "show line numbers
set exrc "run .vimrc files in pwd
set secure "don't let .vimrc files owned by other users do stupid things
set spell "enable spell checking use ":set nospell" to turn it off for a single buffer
set spelllang=en_us "use US dictionary for spelling
set completeopt=longest,menuone,preview "make auto-complete less stupid
set belloff=all "I hate that bell...
set undofile "keep persistent undo across vim runs
set undodir=~/.vim-undo/ "where to store undo files

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

" When sshing I don't use gvim but I still want my pretty colors. On local machine, I want vim to
" look like a normal terminal app. I know, I'm weird.
if $SSH_CONNECTION !=# '' && $TERM ==# 'xterm-256color'
    set termguicolors " use gui colors in terminal
    colorscheme wombat256
    set t_ut= "unbreak bg colors when scolling
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
nnoremap <silent><S-h> :bp<CR>
nnoremap <silent><S-l> :bn<CR>

"use readline maps in command mode
cnoremap <C-a> <HOME>
cnoremap <C-e> <END>

"dont require a shift to enter command mode
nnoremap ; :

"make cmdwin mode easier to use
nnoremap q; q:
augroup vimrc
    autocmd CmdWinEnter * nnoremap <silent><buffer><esc> :q<cr>
augroup end

"make shift Y behave like shift-[cd] (copy to end of line)
nnoremap Y y$

"kill the search highlight. (Note: this is different from :set nohlsearch)
nnoremap <silent> <leader><leader> :nohlsearch<CR>

"auto close {
function! s:CloseBracket()
    let line = getline('.')
    if line =~ '^\s*\(struct\|class\|enum\) '
        return "{\<Enter>};\<Esc>O"
    elseif searchpair('(', '', ')', 'bmn', '', line('.'))
        " Probably inside a function call. Close it off.
        return "{\<Enter>});\<Esc>O"
    else
        return "{\<Enter>}\<Esc>O"
    endif
endfunction
inoremap <expr> {<Enter> <SID>CloseBracket()

"add c++ stdlib headers to path
set path^=/usr/include/c++/*
set path^=/usr/include/c++/*/x86_64*

"I hate that hot pink default
highlight PMenu guibg=brown guifg=lightgrey
highlight PMenuSel guibg=lightgrey guifg=brown

" Subtle but noticeable highlighting for misspelled words
highlight SpellBad ctermbg=52 guibg=#330000 cterm=undercurl guisp=Red

" FileType specific configs
augroup vimrc
    autocmd FileType cpp setlocal matchpairs+=<:> " make % bounce between < and >
    autocmd FileType c,cpp nnoremap <buffer>T :YcmCompleter GetType<CR>
    autocmd FileType c,cpp nnoremap <buffer><C-t> :YcmCompleter FixIt<CR>
    autocmd FileType c,cpp,python nnoremap <silent><buffer><A-]> :YcmComplete GoTo<CR>
    autocmd FileType c,cpp nnoremap <silent><buffer><D-]> :YcmComplete GoToDeclaration<CR>
    "autocmd FileType javascript nnoremap <silent><buffer><A-]> :YcmComplete GoTo<CR>
    "autocmd FileType javascript nnoremap <buffer>T :YcmCompleter GetType<CR>
    autocmd FileType javascript nnoremap <silent><buffer><A-]> :TernDef<CR>
    autocmd FileType javascript nnoremap <buffer>T :TernType<CR>
    autocmd FileType gitcommit setlocal textwidth=78 colorcolumn=+1
    autocmd FileType go setlocal sts=4 ts=4 noexpandtab
    autocmd FileType tex setlocal grepprg=grep\ -nH\ $*
    autocmd FileType yaml setlocal sts=2 sw=2
    autocmd FileType text setlocal textwidth=78
    autocmd FileType git,fugitiveblame setlocal nospell colorcolumn=0
    autocmd FileType qf,man setlocal nospell colorcolumn=0
    autocmd FileType qf nnoremap <buffer><C-CR> <CR>:cclose<CR>
    "autocmd FileType qf setlocal scrolloff=0 " grrr global
    autocmd FileType conque_term setlocal nospell timeout
    autocmd FileType haskell setlocal nospell
    autocmd FileType strace setlocal nospell
    autocmd FileType ruby,eruby setlocal omnifunc=rubycomplete#Complete
    autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading=1
    "autocmd FileType ruby,eruby let g:rubycomplete_rails = 1
    autocmd BufEnter *.log setlocal nospell nowrap tw=0
    "autocmd FileType python BracelessEnable +indent +highlight
augroup END

"clicking on the 'tabs' in the MiniBufExplorer will switch to that buffer
"(even in console)
let g:miniBufExplUseSingleClick=1
let g:miniBufExplMapCTabSwitchBufs=1
let g:miniBufExplorerAutoUpdate = 1
let g:miniBufExplTabWrap = 1
let g:miniBufExplForceSyntaxEnable = 0

let g:SuperTabDefaultCompletionType = 'context'
let g:SuperTabContextDefaultCompletionType = '<c-x><c-o>'
"let g:SuperTabMappingForward = "<tab>"

let g:undotree_DiffCommand = 'diff -u'
let g:undotree_SplitWidth = 30
let g:undotree_DiffpanelHeight = 20
let g:undotree_WindowLayout = 2 " wide diff view

let g:ackprg='ag --vimgrep'

"change inside of a (single-ling) string, see :help objects
nnoremap c' ci'
nnoremap c" ci"
nnoremap cw ciw
nnoremap d' da'
nnoremap d" da"
nnoremap dw daw

function! GrepForWord(word)
    let @/ = '\<'.a:word.'\>'
    AckFromSearch!
endfunction

" like * but with ctrl find current word in whole project
"nnoremap <silent><F7> *N:execute "silent Ggrep -w " . expand('<cword>')  <CR><CR>
nnoremap <silent><F7> :silent call GrepForWord(expand('<cword>'))<CR>

" open the quickfix windown whenever something adds to it
augroup vimrc
    autocmd QuickFixCmdPost * nested botright cwindow 10
augroup END

"use F11/F12 to move to older/newer quickfix lists
nnoremap <silent><F11> :colder<CR>
nnoremap <silent><F12> :cnewer<CR>

"use shift-w to save the file as root (I forget to use "sudo vim" a lot)
command! -bar -nargs=0 W  :silent exe "write !sudo tee % >/dev/null"|silent edit!

"autosave on make
"cabbr make wa\|make

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
let g:CommandTSelectNextMap=['<C-n>', '<C-j>', '<Down>', '<Tab>']
let g:CommandTSelectPrevMap=['<C-p>', '<C-k>', '<Up>', '<S-Tab>']
let g:CommandTTraverseSCM='pwd'
let g:CommandTFileScanner='ruby'
let g:CommandTMaxHeight=0
"let g:CommandTMatchWindowReverse=0

augroup vimrc
    " close the preview window after i'm done with it
    "autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
    autocmd InsertLeave * if getcmdwintype() == '' && pumvisible() == 0|pclose|endif

    " Reload vimrc on save (does weird things, need to debug...)
    autocmd BufWritePost .vimrc silent noautocmd source %
augroup END

let g:clang_use_library = 1
let g:clang_ibrary_path = '/usr/lib/llvm/libclang.so'
let g:clang_complete_macros=1
let g:clang_periodic_quickfix=0
let g:clang_complete_copen = 1
let g:clang_jumpto_declaration_key = '<A-]>'
let g:clang_jumpto_back_key = '<A-T>'
"let g:clang_snippets = 1
"let g:clang_snippets_engine = 'ultisnips'
"let g:clang_debug = 1

"let g:UltiSnipsExpandTrigger="<s-tab>"
let g:UltiSnipsJumpForwardTrigger='<s-tab>'
"let g:UltiSnipsJumpBackwardTrigger="<c-tab>"

"let g:syntastic_enable_signs=1
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list=1
let g:syntastic_c_checker = 'clang'
let g:syntastic_c_no_include_search = 1
let g:syntastic_cpp_compiler = 'clang++'
let g:syntastic_cpp_no_include_search = 1
let g:syntastic_cpp_errorformat =
            \ '%-G%f:%s:,'.
            \ '%f:%l:%c: %trror: %m,'.
            \ '%f:%l:%c: %tarning: %m,'.
            \ '%I%f:%l:%c: note: %m,'.
            \ '%f:%l:%c: %m,'.
            \ '%f:%l: %trror: %m,'.
            \ '%f:%l: %tarning: %m,'.
            \ '%I%f:%l: note: %m,'.
            \ '%f:%l: %m,'.
            \ '%I%m'
"SyntasticEnable cpp

"let g:ycm_enable_diagnostic_signs = 0 " interferes with git-gutter which is more valuable
let g:ycm_extra_conf_globlist = ['~/10gen/*']
let g:ycm_always_populate_location_list = 0
let g:ycm_filepath_completion_use_working_dir = 1
let g:ycm_open_loclist_on_ycm_diags = 1
let g:ycm_global_ycm_extra_conf = '~/.vim/ycm_extra_conf.py'
let g:ycm_collect_identifiers_from_tags_files = 0
let g:ycm_complete_in_comments = 0
"let g:ycm_key_invoke_completion = '<tab>' " doesn't work :(

let g:UltiSnipsExpandTrigger='<c-tab>'
"let g:UltiSnipsListSnippets="<leader>s"
let g:UltiSnipsJumpForwardTrigger='<c-tab>'
let g:UltiSnipsJumpBackwardTrigger='<s-tab>'

let g:delimitMate_expand_cr = 1
let g:delimitMate_expand_space = 1
let g:delimitMate_jump_expansion = 1
let g:delimitMate_balance_matchpairs = 1

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
endif


let g:airline_detect_spell=0
let g:airline_skip_empty_sections = 1
let g:airline#extensions#default#layout = [
      \ ['a', 'b', 'c'],
      \ ['error', 'warning', 'x', 'y', 'z']]

let g:airline#extensions#tabline#enabled = 1
"let g:airline#extensions#tabline#left_sep = '|'
"let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#extensions#tabline#buffer_min_count = 2

let g:airline#extensions#ycm#enabled = 1
let g:airline#extensions#ycm#error_symbol = '𝐄'
let g:airline#extensions#ycm#warning_symbol = 'W'

let g:rtagsUseLocationList=0

" enable :Man and <leader>K mappings
runtime! ftplugin/man.vim
nmap K ,K
augroup vimrc
    autocmd FileType help nmap <buffer> K g<C-]>
augroup END

runtime! macros/matchit.vim

if !has('gui_running')
    if !has('nvim')
        "make <A-]> work in terminal vim
        execute "set <A-]>=\e]"

        "make the mouse work correctly in cygwin
        set ttymouse=sgr
    endif

    "change cursor icon based on mode
    let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1
    let &t_SI = "\<Esc>[6 q" "insert - pipe
    let &t_SR = "\<Esc>[4 q" "replace - underbar
    let &t_EI = "\<Esc>[2 q" "normal - block
endif

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

let g:ConqueTerm_CloseOnEnd = 1
let g:ConqueTerm_StartMessages = 0
let g:ConqueTerm_CWInsert = 1
let g:ConqueTerm_InsertOnEnter = 1

" make plugins that use :Make use AsyncRun
command! -bang -nargs=* -complete=file Make AsyncRun -program=make @ <args>

let g:ale_linters = {}
let g:ale_linters.cpp = []
let g:ale_linters.c = []
let g:ale_vim_vint_show_style_issues = 0

"see also: my ~/.gimrc and ~/.vim directory
