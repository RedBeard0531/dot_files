"=============================================================================
"    Copyright: Copyright (C) 2007 Michael Hofmann
"               Permission is hereby granted to use and distribute this code,
"               with or without modifications, provided that this copyright
"               notice is copied with it. Like anything else that's free,
"               bufexplorer.vim is provided *as is* and comes with no
"               warranty of any kind, either expressed or implied. In no
"               event will the copyright holder be liable for any damages
"               resulting from the use of this software.
" Name Of File: errormarker.vim
"  Description: Sets markers for compile errors
"   Maintainer: Michael Hofmann <mh21@piware.de>
"      Version: See g:loaded_errormarker for version number.
"        Usage: Normally, this file should reside in the plugins
"               directory and be automatically sourced. If not, you must
"               manually source this file using ':source bufexplorer.vim'.
"
"=============================================================================

" Exit quickly when the script has already been loaded or when 'compatible'
" is set.
if exists("g:loaded_errormarker") || &cp
  finish
endif

" Version number.
let g:loaded_errormarker = "0.1"

" Setup the autocommands that handle the MRUList and other stuff.
augroup errormarker
    autocmd QuickFixCmdPost make call <SID>SetErrorMarkers()
augroup END

function! s:SetErrorMarkers()
    let &balloonexpr = "<SNR>" . s:SID() . "_ErrorMessageBalloons()"
    set ballooneval

    if has('win32')
        sign define errorsign text=EE linehl=Todo
    else
    sign define errorsign text=EE icon=/usr/share/icons/gnome/16x16/status/dialog-error.png 
    endif
    sign unplace *
    let l:i = 1
    for d in getqflist()
        if (d.bufnr == 0 || d.lnum == 0)
            continue
        endif
        execute ":sign place " . l:i . " line=" . d.lnum .
                    \ " name=errorsign buffer=" . d.bufnr
        let l:i = l:i + 1
    endfor
endfunction

function! s:ErrorMessageBalloons()
    for d in getqflist()
        if (d.bufnr == v:beval_bufnr && d.lnum == v:beval_lnum)
            return d.text
        endif
    endfor
    return ""
endfunction

function! s:SID()
    return matchstr (expand ('<sfile>'), '<SNR>\zs\d\+\ze_SID$')
endfunction

