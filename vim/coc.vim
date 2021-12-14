scriptencoding utf-8
augroup vimrc_coc
  autocmd!
  au BufWritePost coc.vim nested silent source %
augroup END

let g:endwise_abbreviations = 1
let g:endwise_no_mappings = 1

let g:ccls_close_on_jump = 1
let g:coc_default_semantic_highlight_groups = 1

let g:airline#extensions#coc#enabled = 1
"let g:airline#extensions#coc#error_symbol = '𝐄'
let g:airline#extensions#coc#error_symbol = '🔥'
"let g:airline#extensions#coc#warning_symbol = 'W'
let g:airline#extensions#coc#warning_symbol = '🏴'
"let g:airline_section_error = '%{airline#util#wrap(airline#extensions#coc#get_error(),0)}'
"let g:airline_section_warning = '%{airline#util#wrap(airline#extensions#coc#get_warning(),0)}'

let g:coc_filetype_map = {
            \ "json": "jsonc",
            \ }

let g:coc_quickfix_open_command = 'botright copen'

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
"imap <expr> <cr> pumvisible() ? "\<C-y>" : "\<CR>\<c-r>=coc#on_enter()\<CR>"
imap <expr> <cr> pumvisible() ? coc#_select_confirm() : "\<CR>\<c-r>=coc#on_enter()\<CR>"
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

if has("menu")
    set mousemodel=popup_setpos

    unmenu PopUp
    nmenu <silent> PopUp.Go\ To\ Definition  <Plug>(coc-definition)
    nmenu <silent> PopUp.Go\ To\ Type <Plug>(coc-type-definition)
    nmenu <silent> PopUp.Go\ To\ Implementation(s) <Plug>(coc-implementation)
    nmenu <silent> PopUp.Go\ To\ References <Plug>(coc-references)
    nmenu <silent> PopUp.-sep1- :
    nmenu <silent> PopUp.Show\ Docs <SID>show_documentation()<CR>
    nmenu <silent> PopUp.Show\ Members :CclsMemberHierarchy<cr>
    nmenu <silent> PopUp.Show\ Callers :CclsCallHierarchy<cr>
    nmenu <silent> PopUp.-sep2- :
    nmenu <silent> PopUp.Rename <Plug>(coc-rename)
endif


" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> ,v <Plug>(coc-range-select)
xmap <silent> ,v <Plug>(coc-range-select)
nmap <silent> <a-v> <Plug>(coc-range-select)
xmap <silent> <a-v> <Plug>(coc-range-select)

" Highlight symbol under cursor on CursorHold

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  V<Plug>(coc-format-selected)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

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
    
    autocmd User EasyMotionPromptBegin silent! CocDisable
    autocmd User EasyMotionPromptEnd silent! CocEnable
augroup end

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line (maybe should use -line?)
"nmap <leader>a  <Plug>(coc-codeaction-line) 
nmap <leader>a  :call CocActionAsync('codeAction', 'cursor')<cr>

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
nnoremap <silent> <Plug>(coc-prefix)f  :<C-u>CocList files<cr>
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

hi CocHighlightText gui=bold guibg=black
hi CocHighlightRead gui=bold guibg=#003300
hi CocHighlightWrite gui=bold guibg=#440000

hi LspCxxHlGroupMemberVariable guifg=#ffffff gui=bold
hi LspCxxHlSymParameter guifg=#e5cccc
hi LspCxxHlSymVariableStatic guifg=#aacccc
hi LspCxxHlSymFieldStatic guifg=#ff55ff
hi LspCxxHlSymUnknownStaticField guifg=#ff55ff
hi LspCxxHlSymFileVariable guifg=#ff5555
hi link LspCxxHlSymNamespaceVariable LspCxxHlSymFileVariable

"}}}

" Helper funcs {{{
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

function! s:show_documentation()
  if (index(['vim','help', 'man'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction
" }}}

" vim:set foldmethod=marker:
