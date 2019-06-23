scriptencoding utf-8
augroup vimrc_coc
  autocmd!
  au BufWritePost coc.vim nested silent source %
augroup END

let g:endwise_abbreviations = 1
let g:endwise_no_mappings = 1

let g:ccls_close_on_jump = 1

let g:airline#extensions#coc#enabled = 1
"let g:airline#extensions#coc#error_symbol = '𝐄'
let g:airline#extensions#coc#error_symbol = '🔥'
"let g:airline#extensions#coc#warning_symbol = 'W'
let g:airline#extensions#coc#warning_symbol = '🏴'
let g:airline_section_error = '%{airline#util#wrap(airline#extensions#coc#get_error(),0)}'
let g:airline_section_warning = '%{airline#util#wrap(airline#extensions#coc#get_warning(),0)}'

let g:coc_filetype_map = {
            \ "json": "jsonc",
            \ }

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
imap <expr> <cr> pumvisible() ? "\<C-y>" : "\<CR>\<c-r>=coc#on_enter()\<CR>"
"imap <expr> ( pumvisiblle() && coc#expandable() >= 0 ? "\<C-y>" : "("

" Use `[c` and `]c` to navigate diagnostics
nmap <silent> [d <Plug>(coc-diagnostic-prev)
nmap <silent> ]d <Plug>(coc-diagnostic-next)
nmap <silent> ,d <Plug>(coc-diagnostic-info)
" Fix autofix problem of current line
nmap <silent> F  <Plug>(coc-fix-current)

" Remap keys for gotos
nmap <silent> <A-]> <Plug>(coc-definition)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>


" Highlight symbol under cursor on CursorHold

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)


augroup vimrc_coc
    " Setup formatexpr specified filetype(s).
    au FileType typescript,json setl formatexpr=CocAction('formatSelected')
    " Update signature help on jump placeholder
    au User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')

    au CursorHoldI * call CocActionAsync('showSignatureHelp') | echo getcurpos()
    au CursorHold * silent! call CocActionAsync('highlight')

    au FileType c,cpp call s:setup_ccls_mappings()
    au FileType yggdrasil nmap <silent> <buffer> K :let g:ccls_close_on_jump = !g:ccls_close_on_jump<cr>

    "autocmd FileType,BufWinEnter,WinNew * if !&modifiable || expand('%') == '' | setlocal nospell | endif
    "au BufNew * echom '|'.expand("%").'|'.&modifiable
augroup end

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

cabbrev cl CocList

" Using CocList
map \ <Plug>(coc-prefix)
nnoremap <silent> <Plug>(coc-prefix)a  :<C-u>CocList diagnostics<cr>
nnoremap <silent> <Plug>(coc-prefix)e  :<C-u>CocList extensions<cr>
nnoremap <silent> <Plug>(coc-prefix)c  :<C-u>CocList commands<cr>
nnoremap <silent> <Plug>(coc-prefix)o  :<C-u>CocList outline<cr>
nnoremap <silent> <Plug>(coc-prefix)s  :<C-u>CocList -I symbols<cr>
nnoremap <silent> <Plug>(coc-prefix)j  :<C-u>CocNext<CR>
nnoremap <silent> <Plug>(coc-prefix)k  :<C-u>CocPrev<CR>
nnoremap <silent> <Plug>(coc-prefix)p  :<C-u>CocListResume<CR>
nmap <silent> \l  <Plug>(coc-codelens-action)

function! s:setup_ccls_mappings()
    " bases and derived classes
    nn <silent> ,rB :call CocLocations('ccls','$ccls/inheritance')<cr>
    nn <silent> ,rb :call CocLocations('ccls','$ccls/inheritance',{'levels':10})<cr>
    nn <silent> ,rD :call CocLocations('ccls','$ccls/inheritance',{'derived':v:true})<cr>
    nn <silent> ,rd :botright call CocLocations('ccls','$ccls/inheritance',{'derived':v:true,'levels':10})<cr>

    " callers
    nn <silent> ,rc :call CocLocations('ccls','$ccls/call')<cr>
    " nn <silent> ,rC :call CocLocations('ccls','$ccls/call',{'callee':v:true})<cr>
    nn <silent> ,rC :CclsCallHierarchy<cr>

    " member variables / variables in a namespace
    nn <silent> ,rm :CclsMemberHierarchy<cr>
    " nn <silent> ,rm :call CocLocations('ccls','$ccls/member')<cr>
    " member functions / functions in a namespace
    " nn <silent> ,rf :call CocLocations('ccls','$ccls/member',{'kind':3})<cr>
    " nested classes / types in a namespace
    " nn <silent> ,rs :call CocLocations('ccls','$ccls/member',{'kind':2})<cr>

    nmap <silent> ,rt <Plug>(coc-type-definition)<cr>
    nn <silent> ,rv :call CocLocations('ccls','$ccls/vars')<cr>
    nn <silent> ,rV :call CocLocations('ccls','$ccls/vars',{'kind':1})<cr>


    nn <silent><buffer> <M-C-l> :call CocLocations('ccls','$ccls/navigate',{'direction':'D'})<cr>
    nn <silent><buffer> <M-C-k> :call CocLocations('ccls','$ccls/navigate',{'direction':'L'})<cr>
    nn <silent><buffer> <M-C-j> :call CocLocations('ccls','$ccls/navigate',{'direction':'R'})<cr>
    nn <silent><buffer> <M-C-h> :call CocLocations('ccls','$ccls/navigate',{'direction':'U'})<cr>
endfunction

" Highlights {{{
hi link CocErrorHighlight   SpellBad
hi link CocWarningHighlight   SpellLocal
hi link CocInfoHighlight   SpellCap
hi link CocHintHighlight   SpellRare

hi CocErrorSign guifg=#882222
hi CocWarningSign guifg=#7f4915
hi CocInfoSign   guifg=darkcyan
hi CocHintSign   guifg=darkgreen

hi CocErrorFloat guifg=#ff0000
hi CocWarningFloat guifg=#ff922b
"hi CocInfoFloat   guifg=blue

hi CocHighlightText gui=bold
hi CocHighlightRead gui=bold guibg=#003300
hi CocHighlightWrite gui=bold guibg=#440000

"}}}

" Helper funcs {{{
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction
" }}}

" vim:set foldmethod=marker:
