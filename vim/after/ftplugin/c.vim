" c.vim adds 'o' to formatoptions which I don't like
setlocal formatoptions-=o

" Treat /// at the start of a line as a comment marker.
" Need this to be before // so remove that and re-add it
setlocal comments-=://
setlocal comments+=:///
setlocal comments+=://
