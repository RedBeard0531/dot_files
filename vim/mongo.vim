" Use ':runtime mongo.vim' to activate this file. You can put that in a .vimrc in your mongo
" directory and it will happen automatically if you set exrc in your main .vimrc.
" TODO move some of this into the mongo repo.

if filereadable(expand('buildscripts/errorcodes.py'))
    python sys.path.append('.')
    python from buildscripts import errorcodes
    function! s:getNextErrorCode()
        python errorcodes.codes = []
        python errorcodes.readErrorCodes()
        return pyeval('errorcodes.getNextCode()')
    endf
    inoremap <C-E> <C-R>=<SID>getNextErrorCode()<CR>
endif

"using ^= rather than += to prepend rather than append
set path^=src/
set path^=src/mongo/
set path^=src/third_party/**
set path^=src/third_party/asio-*/asio/include/

"This is the error format used in js stack traces.
"Copy the trace and run :cexpr(@+) to populate the quickfix list with the paste buffer.
set errorformat^=%m@%f:%l:%c,@%f:%l:%c

"ignore these dirs in command-t
let g:CommandTWildIgnore=&wildignore . ',*/build/*,src/third_party/[^w]*,src/mongo/gotools/*'

"make vim automatically get very close to our coding format.
"TODO should this be restricted to specific paths or file types?
set expandtab "tab key -> spaces
set shiftwidth=4 "indent by 4 spaces
set softtabstop=4 "treat 4 spaces like a tab
set textwidth=100 "code should stop at 100 chars 
set colorcolumn=+1 "draw a wall where code should end
set cinoptions=l1,g0,N-s,(0,u0,Ws,k2s,j1,J1,)1000,*1000 " setup cindent correctly

let g:filetype_i = 'c'

function! s:EnableCheetahSyntax()
    if has_key(b:, 'current_syntax')
        unlet b:current_syntax 
    endif
    runtime syntax/cheetah.vim"
endfunction

augroup MongoVimRC
    autocmd!
    autocmd BufRead */src/third_party/wiredtiger/*.[chi] setlocal sts=8 ts=8 sw=8 noet tw=80
    autocmd BufWritePre */{jstests,src/mongo}/*.{cpp,h,js} %pyf /usr/share/clang/clang-format.py

    autocmd BufNewFile,BufRead *.idl set filetype=yaml
    autocmd BufNewFile,BufRead error_codes.err let b:ale_enabled=0

    autocmd BufNewFile,BufRead *.tpl.{h,cpp,js}  call s:EnableCheetahSyntax()

    autocmd FileType cpp syn keyword MongoMinor uassertStatusOK
    autocmd FileType cpp hi MongoMinor guifg=#555555
augroup END

let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_javascript_checkers = []
let g:syntastic_javascript_eslint_exec = './build/eslint'

let g:ale_linters.javascript = ['eslint']
let g:ale_javascript_eslint_executable = './build/eslint'
let g:ale_python_pylint_options='--errors-only' " don't complain about python style

let g:clang_format_path='./build/clang-format'

let g:javascript_plugin_jsdoc = 1

nnoremap <silent><S-F7> *N:execute "silent Ggrep -w " . expand('<cword>') . " src/mongo"  <CR><CR>

if executable('buildscripts/mongosymb.py')
    command! -nargs=+ -complete=file Addr2Line
        \ cgetexpr system('python2 buildscripts/mongosymb.py <args> \| sed -e "s/^ ??:0:0://"', @*)
endif

command! -nargs=+ Rtags cexpr system('rc <args> ' . expand('%') . ':' . line('.') . ':' . col('.'))

command! -nargs=* -bang -complete=file Scons AsyncRun<bang>  @ buildscripts/scons.py 
    \ --modules=  MONGO_VERSION=0.0.0 MONGO_GIT_HASH=unknown 
    \ CCFLAGS=-Wa,--compress-debug-sections CC=clang CXX=clang++ VERBOSE=0
    \ --cache=nolinked --implicit-cache <args>

function! s:NinjaComplete(arg_lead, cmd, pos)
    return system('ninja -t targets all | cut -d: -f1')
endf
command! -nargs=* -bang -complete=custom,s:NinjaComplete Ninja AsyncRun<bang> -save=1 ninja <args>

command! -nargs=0 -bang WCC w | cexpr system('ninja '.pyeval('os.path.relpath("'.expand('%:r').'.cpp^")'))
nmap <F5> :WCC<CR>
