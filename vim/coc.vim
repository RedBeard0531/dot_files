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
      \ coc#pum#visible() ? coc#pum#next(1):
      \ <SID>CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
"imap <expr> <cr> pumvisible() ? "\<C-y>" : "\<CR>\<c-r>=coc#on_enter()\<CR>"
"imap <expr> ( pumvisiblle() && coc#expandable() >= 0 ? "\<C-y>" : "("
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<CR>\<c-r>=coc#on_enter()\<CR>"
nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"

" Use `[c` and `]c` to navigate diagnostics
nmap <silent> [d <Plug>(coc-diagnostic-prev)
nmap <silent> ]d <Plug>(coc-diagnostic-next)
nmap <silent> [D <Plug>(coc-diagnostic-prev-error)
nmap <silent> ]D <Plug>(coc-diagnostic-next-error)
nmap <silent> ,d <Plug>(coc-diagnostic-info)
" Fix autofix problem of current line
nmap <silent> F  <Plug>(coc-fix-current)

" Remap keys for gotos
nmap <silent> <A-]> <Plug>(coc-definition)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gD <Plug>(coc-declaration)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references-used)
nmap <silent> gR <Plug>(coc-references)
nmap <silent> gl <Plug>(coc-openlink)

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

nnoremap <silent><nowait> <leader>o  :call <SID>ToggleOutline()<CR>
nnoremap <silent><nowait> <m-o> :call <SID>GoToOutline()<CR>

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

    au CursorHoldI * if has_key(b:, 'coc_diagnostic_info') | silent! call CocActionAsync('showSignatureHelp') | endif
    au CursorHold * silent! call CocActionAsync('highlight')

    au FileType help nmap <buffer> gd <c-]>

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
"nmap <leader>a  <Plug>(coc-codeaction-cursor) 
nmap <leader>a  :call CocActionAsync('codeAction', 'cursor')<cr>
nmap <leader>A  :call CocActionAsync('codeAction', 'currline')<cr>
nmap <leader><c-a>  :call CocActionAsync('codeAction', '')<cr>
"nmap <leader>a  <Plug>(coc-codeaction-cursor) 

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

cabbrev cl CocList

function! PrintArgs(n, clicks, button, mods)
    "PP a:
    PP getmousepos()
endfunction

if has("nvim")
    let &winbar='%{%get(b:, "coc_symbol_line", "")%}%=%1234@PrintArgs@%f%X'
else
    let &tabline='%{%get(b:, "coc_symbol_line", "")%}'
endif

" Using CocList
map \ <Plug>(coc-prefix)
"nnoremap <silent> <Plug>(coc-prefix)a  :<C-u>CocList diagnostics<cr>
nnoremap <silent> <Plug>(coc-prefix)e  :<C-u>CocList extensions<cr>
nnoremap <silent> <Plug>(coc-prefix)c  :<C-u>CocList commands<cr>
nnoremap <silent> <Plug>(coc-prefix)o  :<C-u>CocList outline<cr>
nnoremap <silent> <Plug>(coc-prefix)f  :<C-u>CocList files<cr>
"nnoremap <silent> <Plug>(coc-prefix)s  :<C-u>CocList -I symbols<cr>
nnoremap <silent> <Plug>(coc-prefix)j  :<C-u>CocNext<CR>
nnoremap <silent> <Plug>(coc-prefix)k  :<C-u>CocPrev<CR>
nnoremap <silent> <Plug>(coc-prefix)p  :<C-u>CocListResume<CR>
nmap <silent> \l  <Plug>(coc-codelens-action)

nnoremap <silent> <Plug>(coc-prefix)a  :Telescope coc diagnostics<cr>
nnoremap <silent> <Plug>(coc-prefix)s  :Telescope coc workspace_symbols<cr>

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
hi CocUnusedHighlight cterm=undercurl gui=undercurl guisp=Gray guibg=Black

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

hi link CocSemParameter LspCxxHlSymParameter
hi link CocSemProperty LspCxxHlGroupMemberVariable
hi link CocSemStaticProperty LspCxxHlSymFieldStatic
hi link CocSemStaticVariable LspCxxHlSymVariableStatic

hi link CocSemGlobalScopeVariable LspCxxHlSymFileVariable
hi link CocSemFileScopeVariable CocSemGlobalScopeVariable

hi link CocSemFileScopeReadonlyVariable CocSemGlobalScopeVariable
hi link CocSemReadonlyFileScopeVariable CocSemGlobalScopeVariable

hi link CocSemMethod LspCxxHlSymMethod
hi link CocSemNamespace LspCxxHlSymNamespace
hi link CocSemEnum LspCxxHlSymEnum
hi link CocSemEnumMember LspCxxHlSymEnumMember
hi link CocSemTypeParameter LspCxxHlSymTemplateParameter

hi link CocSemVariable Normal
" hi link CocSemMethod Function

"hi link CocSemDefaultLibraryVariable jsGlobalObjects
"hi link CocSemDefaultLibraryNamespace Namespace
"hi link CocSemDefaultLibrary Type

hi link commentTSWarning Todo

hi CocPumVirtualText guifg=#706965
hi CocMenuSel guibg=#164606 gui=bold

if has("nvim")
  hi link @property.special Special
endif
hi link Delimiter Normal

"}}}

" Helper funcs {{{
function! s:CheckBackspace() abort
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

function! s:ToggleOutline() abort
  let winid = coc#window#find('cocViewId', 'OUTLINE')
  if winid == -1
      call CocActionAsync('showOutline', 1)
  else
      call coc#window#close(winid)
  endif
endfunction

function! s:GoToOutline() abort
  let winid = coc#window#find('cocViewId', 'OUTLINE')
  if winid == -1
      CocOutline
  else
      call win_gotoid(winid)
  endif
endfunction
" }}}

" vim:set foldmethod=marker:
