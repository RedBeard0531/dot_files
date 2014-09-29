" https://gist.github.com/tdmackey/5668946
function! GetLineAndFunc(output)
        let fllist = split(a:output, "\n")
        let res = []
        let i = 0
        echo len(fllist)
        while i < len(fllist)
                let res += [split(fllist[i + 1])[0] . ': ' . fllist[i]]
                let i += 2
        endwhile
        return res
endfunction
 
" Example - :Addr2Line vmlinux <address>
command! -nargs=+ -complete=file Addr2Line
        \ cexpr GetLineAndFunc(system('addr2line -C -i -f -e <args>'))
