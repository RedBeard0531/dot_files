" Vimball Archiver by Charles E. Campbell, Jr., Ph.D.
UseVimball
finish
compiler/ghc.vim	[[[1
312

" Vim Compiler File
" Compiler:	GHC
" Maintainer:	Claus Reinke <claus.reinke@talk21.com>
" Last Change:	03/11/2007
"
" part of haskell plugins: http://www.cs.kent.ac.uk/~cr3/toolbox/haskell/Vim/

" ------------------------------ paths & quickfix settings first
"

if exists("current_compiler") && current_compiler == "ghc"
  finish
endif
let current_compiler = "ghc"

let s:scriptname = "ghc.vim"

if (!exists("g:ghc") || !executable(g:ghc)) 
  if !executable('ghc') 
    echoerr s:scriptname.": can't find ghc. please set g:ghc, or extend $PATH"
    finish
  else
    let g:ghc = 'ghc'
  endif
endif    
let ghc_version = substitute(system(g:ghc . ' --version'),'\n','','')

" set makeprg (for quickfix mode) 
execute 'setlocal makeprg=' . g:ghc .'\ -e\ :q\ %'
"execute 'setlocal makeprg=' . g:ghc .'\ --make\ %'

" quickfix mode: 
" ignore banner and empty lines, 
" fetch file/line-info from error message
setlocal errorformat=%E%f:%l:%c:\ %m,
                    \%E%f:%l:%c:,
                    \%+C\ \ %#%m

" oh, wouldn't you guess it - ghc reports (partially) to stderr..
setlocal shellpipe=2>

" ------------------------- but ghc can do a lot more for us..
"

" allow map leader override
if !exists("maplocalleader")
  let maplocalleader='_'
endif

" initialize map of identifiers to their types
let b:ghc_types = {}

if exists("g:haskell_functions")
  finish
endif
let g:haskell_functions = "ghc"

" avoid hit-enter prompts
set cmdheight=3

map <LocalLeader>T :call GHC_ShowType(1)<cr>
map <LocalLeader>t :call GHC_ShowType(0)<cr>
function! GHC_ShowType(addTypeDecl)
  let namsym   = Haskell_GetNameSymbol(getline('.'),col('.'),0)
  if namsym==[]
    redraw
    echo 'no name/symbol under cursor!'
    return 0
  endif
  let [_,symb,qual,unqual] = namsym
  let name  = qual=='' ? unqual : qual.'.'.unqual
  let pname = ( symb ? '('.name.')' : name ) 
  call GHC_HaveTypes()
  if !has_key(b:ghc_types,name)
    redraw
    echo pname "type not known"
  else
    redraw
    for type in split(b:ghc_types[name],' -- ')
      echo pname "::" type
      if a:addTypeDecl
        call append( line(".")-1, pname . " :: " . type )
      endif
    endfor
  endif
endfunction

" show type of identifier under mouse pointer in balloon
if has("balloon_eval")
  set ballooneval
  set balloondelay=600
  set balloonexpr=GHC_TypeBalloon()
  function! GHC_TypeBalloon()
    if exists("b:current_compiler") && b:current_compiler=="ghc" 
      let [line] = getbufline(v:beval_bufnr,v:beval_lnum)
      let namsym = Haskell_GetNameSymbol(line,v:beval_col,0)
      if namsym==[]
        return ''
      endif
      let [start,symb,qual,unqual] = namsym
      let name  = qual=='' ? unqual : qual.'.'.unqual
      let pname = name " ( symb ? '('.name.')' : name )
      silent call GHC_HaveTypes()
      if has("balloon_multiline")
        return (has_key(b:ghc_types,pname) ? split(b:ghc_types[pname],' -- ') : '') 
      else
        return (has_key(b:ghc_types,pname) ? b:ghc_types[pname] : '') 
      endif
    else
      return ''
    endif
  endfunction
endif

map <LocalLeader>si :call GHC_ShowInfo()<cr>
function! GHC_ShowInfo()
  let namsym   = Haskell_GetNameSymbol(getline('.'),col('.'),0)
  if namsym==[]
    redraw
    echo 'no name/symbol under cursor!'
    return 0
  endif
  let [_,symb,qual,unqual] = namsym
  let name = qual=='' ? unqual : (qual.'.'.unqual)
  let output = GHC_Info(name)
  redraw
  echo output
endfunction

function! GHC_HaveTypes()
  if b:ghc_types == {}
    return GHC_BrowseAll()
  endif
endfunction

" update b:ghc_types after successful make
au QuickFixCmdPost make if getqflist()==[] | silent call GHC_BrowseAll() | endif

command! GHCReload call GHC_BrowseAll()
function! GHC_BrowseAll()
  " let imports = Haskell_GatherImports()
  " let modules = keys(imports[0]) + keys(imports[1])
  let imports = {} " no need for them at the moment
  let current = GHC_NameCurrent()
  let b:ghc_types = {}
  if current != []
    return GHC_BrowseMultiple(imports,['*'.current[0]])
  else
    return GHC_BrowseMultiple(imports,['*Main'])
  endif
endfunction

function! GHC_NameCurrent()
  let last = line("$")
  let l = 1
  while l<last
    let ml = matchlist( getline(l), '^module\s*\([^ (]*\)')
    if ml != []
      let [_,module;x] = ml
      return [module]
    endif
    let l += 1
  endwhile
  redraw
  echo "cannot find module header for file " . expand("%")
  return []
endfunction

function! GHC_BrowseMultiple(imports,modules)
  redraw
  echo "browsing modules" a:modules
  let command = ":browse " . join( a:modules, " \n :browse ") 
  let command = substitute(command,'\(:browse \(\S*\)\)','putStrLn "-- \2" \n \1','g')
  let output = system(g:ghc . ' -v0 --interactive ' . expand("%") , command )
  return GHC_Process(a:imports,output)
endfunction

function! GHC_Info(what)
  call GHC_HaveTypes()
  let output = system(g:ghc . ' -v0 --interactive ' . expand("%"), ":i ". a:what)
  return output
endfunction

function! GHC_Process(imports,output)
  let b       = a:output
  let imports = a:imports
  let linePat = '^\(.\{-}\)\n\(.*\)'
  let contPat = '\s\+\(.\{-}\)\n\(.*\)'
  let typePat = '^\(\s*\)\(\S*\)\s*::\(.*\)'
  let modPat  = '^-- \(\S*\)'
  if !(b=~modPat)
    echo s:scriptname.": GHCi reports errors (try :make?)"
    return 0
  endif
  let ml = matchlist( b , linePat )
  while ml != []
    let [_,l,rest;x] = ml
    let mlDecl = matchlist( l, typePat )
    if mlDecl != []
      let [_,indent,id,type;x] = mlDecl
      let ml2 = matchlist( rest , '^'.indent.contPat )
      while ml2 != []
        let [_,c,rest;x] = ml2
        let type .= c
        let ml2 = matchlist( rest , '^'.indent.contPat )
      endwhile
      let id   = substitute(id, '^(\(.*\))$', '\1', '')
      let type = substitute( type, '\s\+', " ", "g" )
      " using :browse *<current>, we get both unqualified and qualified ids
      if current_module " || has_key(imports[0],module) 
        if has_key(b:ghc_types,id) && !(matchstr(b:ghc_types[id],escape(type,'[].'))==type)
          let b:ghc_types[id] .= ' -- '.type
        else
          let b:ghc_types[id] = type
        endif
      endif
      if 0 " has_key(imports[1],module) 
        let qualid = module.'.'.id
        let b:ghc_types[qualid] = type
      endif
    else
      let mlMod = matchlist( l, modPat )
      if mlMod != []
        let [_,module;x] = mlMod
        let current_module = module[0]=='*'
        let module = current_module ? module[1:] : module
      endif
    endif
    let ml = matchlist( rest , linePat )
  endwhile
  return 1
endfunction

" use ghci :browse index for insert mode omnicompletion (CTRL-X CTRL-O)
function! GHC_CompleteImports(findstart, base)
  if a:findstart 
    let namsym   = Haskell_GetNameSymbol(getline('.'),col('.'),-1) " insert-mode: we're 1 beyond the text
    if namsym==[]
      redraw
      echo 'no name/symbol under cursor!'
      return -1
    endif
    let [start,symb,qual,unqual] = namsym
    return (start-1)
  else " find keys matching with "a:base"
    let res = []
    let l   = len(a:base)-1
    call GHC_HaveTypes()
    for key in keys(b:ghc_types) 
      if key[0 : l]==a:base
        let res += [{"word":key,"menu":":: ".b:ghc_types[key],"dup":1}]
      endif
    endfor
    return res
  endif
endfunction
set omnifunc=GHC_CompleteImports
set completeopt=menu,menuone,longest

map <LocalLeader>ct :call GHC_CreateTagfile()<cr>
function! GHC_CreateTagfile()
  redraw
  echo "creating tags file" 
  let output = system(g:ghc . ' -e ":ctags" ' . expand("%"))
  " for ghcs older than 6.6, you would need to call another program 
  " here, such as hasktags
  echo output
endfunction

command! -nargs=1 GHCi redraw | echo system(g:ghc.' '.expand("%").' -e <f-args>')

" use :make 'not in scope' errors to explicitly list imported ids
" cursor needs to be on import line, in correctly loadable module
map <LocalLeader>ie :call GHC_MkImportsExplicit()<cr>
function! GHC_MkImportsExplicit()
  let save_cursor = getpos(".")
  let line   = getline('.')
  let lineno = line('.')
  let ml     = matchlist(line,'^import\(\s*qualified\)\?\s*\([^( ]\+\)')
  if ml!=[]
    let [_,q,mod;x] = ml
    silent make
    if getqflist()==[]
      call setline(lineno,'-- '.line)
      silent write
      silent make
      let qflist = getqflist()
      call setline(lineno,line)
      silent write
      let ids = []
      for d in qflist
        let ml = matchlist(d.text,'Not in scope: `\([^'']*\)''')
        if ml!=[]
          let [_,qid;x] = ml
          let id  = ( qid =~ "^[A-Z]" ? substitute(qid,'.*\.\([^.]*\)$','\1','') : qid )
          let pid = ( id =~ "[a-zA-Z0-9_']\\+" ? id : '('.id.')' )
          let ids += [pid]
        endif
      endfor
      call setline(lineno,'import'.q.' '.mod.'('.join(ids,',').')')
    endif
  endif
  call setpos('.', save_cursor)
endfunction

let opts = ["-fglasgow-exts","-fallow-undecidable-instances","-fallow-overlapping-instances","-fno-monomorphism-restriction","-fno-mono-pat-binds","-fno-cse","-fbang-patterns","-funbox-strict-fields"]
for o in opts
  exe 'amenu ]OPTIONS_GHC.'.o.' :call append(0,"{-# OPTIONS_GHC '.o.' #-}")<cr>'
endfor
map <LocalLeader>opt :popup ]OPTIONS_GHC<cr>

ftplugin/haskell.vim	[[[1
108

" todo: allow disabling and undo
" (Claus Reinke, last modified: 21/08/2007)
"
" part of haskell plugins: http://www.cs.kent.ac.uk/~cr3/toolbox/haskell/Vim/

" try gf on import line, or ctrl-x ctrl-i, or [I, [i, ..
set include=^import\\s*\\(qualified\\)\\?\\s*
set includeexpr=substitute(v:fname,'\\.','/','g').'.hs'


" find start/extent of name/symbol under cursor;
" return start, symbolic flag, qualifier, unqualified id
" (this is used in both haskell_doc.vim and in GHC.vim)
function! Haskell_GetNameSymbol(line,col,off)
  let name    = "[a-zA-Z0-9_']"
  let symbol  = "[-!#$%&\*\+/<=>\?@\\^|~:.]"
  "let [line]  = getbufline(a:buf,a:lnum)
  let line    = a:line

  " find the beginning of unqualified id or qualified id component 
  let start   = (a:col - 1) + a:off
  if line[start] =~ name
    let pattern = name
  elseif line[start] =~ symbol
    let pattern = symbol
  else
    return []
  endif
  while start > 0 && line[start - 1] =~ pattern
    let start -= 1
  endwhile
  let id    = matchstr(line[start :],pattern.'*')
  " call confirm(id)

  " expand id to left and right, to get full id
  let idPos = id[0] == '.' ? start+2 : start+1
  let posA  = match(line,'\<\(\([A-Z]'.name.'*\.\)\+\)\%'.idPos.'c')
  let start = posA>-1 ? posA+1 : idPos
  let posB  = matchend(line,'\%'.idPos.'c\(\([A-Z]'.name.'*\.\)*\)\('.name.'\+\|'.symbol.'\+\)')
  let end   = posB>-1 ? posB : idPos

  " special case: symbolic ids starting with .
  if id[0]=='.' && posA==-1 
    let start = idPos-1
    let end   = posB==-1 ? start : end
  endif

  " classify full id and split into qualifier and unqualified id
  let fullid   = line[ (start>1 ? start-1 : 0) : (end-1) ]
  let symbolic = fullid[-1:-1] =~ symbol  " might also be incomplete qualified id ending in .
  let qualPos  = matchend(fullid, '\([A-Z]'.name.'*\.\)\+')
  let qualifier = qualPos>-1 ? fullid[ 0 : (qualPos-2) ] : ''
  let unqualId  = qualPos>-1 ? fullid[ qualPos : -1 ] : fullid
  " call confirm(start.'/'.end.'['.symbolic.']:'.qualifier.' '.unqualId)

  return [start,symbolic,qualifier,unqualId]
endfunction

function! Haskell_GatherImports()
  let imports={0:{},1:{}}
  let i=1
  while i<=line('$')
    let res = Haskell_GatherImport(i)
    if !empty(res)
      let [i,import] = res
      let prefixPat = '^import\s*\(qualified\)\?\s\+'
      let modulePat = '\([A-Z][a-zA-Z0-9_''.]\+\)'
      let asPat     = '\(\s\+as\s\+'.modulePat.'\)\?'
      let hidingPat = '\(\s\+hiding\s*\((.*)\)\)\?'
      let listPat   = '\(\s*\((.*)\)\)\?'
      let importPat = prefixPat.modulePat.asPat.hidingPat.listPat.'\s*$'
      let [_,qualified,module,_,as,_,hiding,_,explicit;x] = matchlist(import,importPat)
      let what = as=='' ? module : as
      if qualified=='qualified'
        let imports[1][what] = {'line':i,'hiding':hiding,'explicit':explicit}
      else
        let imports[1][what] = {'line':i,'hiding':hiding,'explicit':explicit}
        let imports[0][what] = {'line':i,'hiding':hiding,'explicit':explicit}
      endif
    endif
    let i+=1
  endwhile
  if !has_key(imports[1],'Prelude') 
    let imports[0]['Prelude'] = {'line':-1}
    let imports[1]['Prelude'] = {'line':-1}
  endif
  return imports
endfunction

" collect lines belonging to a single import statement;
" return number of last line and collected import statement
" (assume opening parenthesis, if any, is on the first line)
function! Haskell_GatherImport(lineno)
  let lineno = a:lineno
  let import = getline(lineno)
  if !(import=~'^import') | return [] | endif
  let open  = strlen(substitute(import,'[^(]','','g'))
  let close = strlen(substitute(import,'[^)]','','g'))
  while open!=close
    let lineno += 1
    let linecont = getline(lineno)
    let open  += strlen(substitute(linecont,'[^(]','','g'))
    let close += strlen(substitute(linecont,'[^)]','','g'))
    let import .= linecont
  endwhile
  return [lineno,import]
endfunction
ftplugin/haskell_doc.vim	[[[1
543
"
" use haddock docs and index files
" show documentation, complete & qualify identifiers 
"
" (Claus Reinke; last modified: 19/10/2007)
" 
" part of haskell plugins: http://www.cs.kent.ac.uk/~cr3/toolbox/haskell/Vim/

" :Doc <name> and :IDoc <name> open haddocks for <name> in opera
"
"   :Doc needs qualified name (default Prelude) and package (default base)
"   :IDoc needs unqualified name, looks up possible links in g:haddock_index
"
"   :DocIndex populates g:haddock_index from haddock's index files
"   :ExportDocIndex saves g:haddock_index to cache file
"   :ImportDocIndex reloads g:haddock_index from cache file
"
" all the following use the haddock index (g:haddock_index)
"
" _? opens haddocks for unqualified name under cursor, 
"    suggesting alternative full qualifications in popup menu
"
" _. fully qualifies unqualified name under cursor,
"    suggesting alternative full qualifications in popup menu
"
" _i  add import <module>(<name>) statement for unqualified <name> under cursor,
" _im add import <module>         statement for unqualified <name> under cursor,
"    suggesting alternative full qualifications in popup menu
"    (this currently adds one statement per call, instead of
"     merging into existing import statements, but it's a start;-)
"
" CTRL-X CTRL-U (user-defined insert mode completion) 
"   suggests completions of unqualified names in popup menu

let s:scriptname = "haskell_doc.vim"

" script parameters
"   g:haddock_browser            *mandatory* which browser to call
"   g:haddock_browser_callformat [optional] how to call browser
"   g:haddock_indexfiledir       [optional] where to put 'haddock_index.vim'
"   g:haddock_docdir             [optional] where to find html docs
"   g:ghc                        [optional] which ghc to call

" initialise nested dictionary, to be populated 
" - from haddock index files via :DocIndex
" - from previous cached version via :ImportDocIndex
let g:haddock_index = {}

" initialise dictionary, mapping modules with haddocks to their packages,
" populated via MkHaddockModuleIndex() or HaveModuleIndex()
let g:haddock_moduleindex = {}

" program to open urls, please set this in your vimrc
  "examples (for windows):
  "let g:haddock_browser = "C:/Program Files/Opera/Opera.exe"
  "let g:haddock_browser = "C:/Program Files/Mozilla Firefox/firefox.exe"
  "let g:haddock_browser = "C:/Program Files/Internet Explorer/IEXPLORE.exe"
if !exists("g:haddock_browser")
  echoerr s:scriptname." WARNING: please set g:haddock_browser!"
endif

if (!exists("g:ghc") || !executable(g:ghc)) 
  if !executable('ghc') 
    echoerr s:scriptname." can't find ghc. please set g:ghc, or extend $PATH"
    finish
  else
    let g:ghc = 'ghc'
  endif
endif    

if exists("g:haddock_docdir") && isdirectory(g:haddock_docdir)
  let s:docdir = g:haddock_docdir
elseif executable('ghc-pkg')
" try to figure out location of html docs
" first choice: where the base docs are
  let field = substitute(system('ghc-pkg field base haddock-html'),'\n','','')
  let field = substitute(field,'haddock-html: \(.*\)libraries.base','\1','')
  let field = substitute(field,'\\','/','g')
  let alternate = substitute(field,'html','doc/html','')
  if isdirectory(field)
    let s:docdir = field
  elseif isdirectory(alternate)
    let s:docdir = alternate
  endif
else
  echoerr s:scriptname." can't find ghc-pkg."
endif

" second choice: try some known suspects for windows/unix
if !exists('s:docdir') || !isdirectory(s:docdir)
  let s:ghc_libdir = substitute(system(g:ghc . ' --print-libdir'),'\n','','')
  let location1 = s:ghc_libdir . '/doc/html/'
  let s:ghc_version = substitute(system('ghc --numeric-version'),'\n','','')
  let location2 = '/usr/share/doc/ghc-' . s:ghc_version . '/html/' 
  if isdirectory(location1)
    let s:docdir = location1
  elseif isdirectory(location2)
    let s:docdir = location2
  else " give up
    echoerr s:scriptname." can't find locaton of html documentation (set g:haddock_docdir)."
    finish
  endif
endif

" todo: can we turn s:docdir into a list of paths, and
" include docs for third-party libs as well?

let s:libraries         = s:docdir . 'libraries/'
let s:guide             = s:docdir . 'users_guide/'
let s:index             = 'index.html'
if exists("g:haddock_indexfiledir") && filewritable(g:haddock_indexfiledir)
  let s:haddock_indexfiledir = g:haddock_indexfiledir 
elseif filewritable(s:libraries)
  let s:haddock_indexfiledir = s:libraries
elseif filewritable($HOME)
  let s:haddock_indexfiledir = $HOME.'/'
else "give up
  echoerr s:scriptname." can't locate index file. please set g:haddock_indexfiledir"
  finish
endif
let s:haddock_indexfile = s:haddock_indexfiledir . 'haddock_index.vim'

" different browser setups require different call formats;
" you might want to call the browser synchronously or 
" asynchronously, and the latter is os-dependent;
"
" by default, the browser is started in the background when on 
" windows or if running in a gui, and in the foreground otherwise
" (eg, console-mode for remote sessions, with text-mode browsers).
"
" you can override these defaults in your vimrc, via a format 
" string including 2 %s parameters (the first being the browser 
" to call, the second being the url).
if !exists("g:haddock_browser_callformat")
  if has("win32") || has("win64")
    let g:haddock_browser_callformat = 'start %s file://%s'
  else
    if has("gui_running")
      let g:haddock_browser_callformat = '%s file://%s '.printf(&shellredir,'/dev/null').' &'
    else
      let g:haddock_browser_callformat = '%s file://%s'
    endif
  endif
endif

" allow map leader override
if !exists("maplocalleader")
  let maplocalleader='_'
endif

command! DocSettings call DocSettings()
function! DocSettings()
  for v in ["g:haddock_browser","g:haddock_browser_callformat","g:haddock_docdir","g:haddock_indexfiledir","s:ghc_libdir","s:ghc_version","s:docdir","s:libraries","s:guide","s:haddock_indexfile"]
    if exists(v)
      echo v '=' eval(v)
    else
      echo v '='
    endif
  endfor
endfunction

function! DocBrowser(url)
  "echomsg "DocBrowser(".url.")"
  if (!exists("g:haddock_browser") || !executable(g:haddock_browser))
    echoerr s:scriptname." can't find documentation browser. please set g:haddock_browser"
    return
  endif
  " start browser to open url, according to specified format
  silent exe '!'.printf(g:haddock_browser_callformat,g:haddock_browser,escape(a:url,'#%')) 
endfunction

"usage examples:
" :Doc length
" :Doc Control.Monad.when
" :Doc Data.List.
" :Doc Control.Monad.State.runState mtl
" :Doc -top
" :Doc -libs
" :Doc -guide
command! -nargs=+ Doc  call Doc('v',<f-args>)
command! -nargs=+ Doct call Doc('t',<f-args>)

function! Doc(kind,qualname,...) 
  let suffix   = '.html'
  let relative = '#'.a:kind.'%3A'

  if a:qualname=="-top"
    call DocBrowser(s:docdir . s:index)
    return
  elseif a:qualname=="-libs"
    call DocBrowser(s:libraries . s:index)
    return
  elseif a:qualname=="-guide"
    call DocBrowser(s:guide . s:index)
    return
  endif

  if a:0==0 " no package specified
    let package = 'base/'
  else
    let package = a:1 . '/'
  endif

  if match(a:qualname,'\.')==-1 " unqualified name
    let [qual,name] = [['Prelude'],a:qualname]
    let file = join(qual,'-') . suffix . relative . name
  elseif a:qualname[-1:]=='.' " module qualifier only
    let parts = split(a:qualname,'\.')
    let quallen = len(parts)-1
    let [qual,name] = [parts[0:quallen],parts[-1]]
    let file = join(qual,'-') . suffix
  else " qualified name
    let parts = split(a:qualname,'\.')
    let quallen = len(parts)-2
    let [qual,name] = [parts[0:quallen],parts[-1]]
    let file = join(qual,'-') . suffix . relative . name
  endif

  let path = s:libraries . package . file
  call DocBrowser(path)
endfunction

" TODO: add commandline completion for :IDoc
" indexed variant of Doc, looking up links in g:haddock_index
" usage:
"  1. :IDoc length
"  2. click on one of the choices, or select by number (starting from 0)
command! -nargs=+ IDoc call IDoc(<f-args>)
function! IDoc(name,...) 
  call HaveIndex()
  if !has_key(g:haddock_index,a:name)
    echoerr a:name 'not found in haddock index'
    return
  endif
  let choices = g:haddock_index[a:name]
  if a:0==0
    let choice = inputlist(keys(choices))
  else
    let choice = a:1
  endif

  let path = s:libraries . values(choices)[choice]
  call DocBrowser(path)
endfunction

command! -nargs=1 -complete=customlist,CompleteHaddockModules MDoc call MDoc(<f-args>)
function! MDoc(module)
  let suffix   = '.html'
  call HaveIndex() 
  if !has_key(g:haddock_moduleindex,a:module)
    echoerr a:module 'not found in haddock module index'
    return
  endif
  let package = g:haddock_moduleindex[a:module]
  let file    = substitute(a:module,'\.','-','g') . suffix
  let path    = s:libraries . package . '/' . file
  call DocBrowser(path)
endfunction

function! CompleteHaddockModules(al,cl,cp)
  call HaveModuleIndex()
  let s:choices = keys(g:haddock_moduleindex)
  return CompleteAux(a:al,a:cl,a:cp)
endfunction

" create a dictionary g:haddock_index, containing the haddoc index
command! DocIndex call DocIndex()
function! DocIndex()
  let files   = split(globpath(s:libraries,'doc-index-*.html'),'\n')
  "let files   = [s:libraries.'doc-index-33.html']
  let entryPat= '.\{-}"indexentry"[^>]*>\([^<]*\)<\(\%([^=]\{-}TD CLASS="\%(indexentry\)\@!.\{-}</TD\)*\)[^=]\{-}\(\%(="indexentry\|TABLE\).*\)'
  let linkPat = '.\{-}HREF="\([^"]*\)".>\([^<]*\)<\(.*\)'
  let g:haddock_index = {}

  redraw
  echo 'populating g:haddock_index from haddock index files in ' s:libraries
  for file in files  
    echo file[len(s:libraries):]
    let contents = join(readfile(file))
    let ml = matchlist(contents,entryPat)
    while ml!=[]
      let [_,entry,links,r;x] = ml
      "echo entry links
      let ml2 = matchlist(links,linkPat)
      let link = {}
      while ml2!=[]
        let [_,l,m,links;x] = ml2
        "echo l m
        let link[m] = l
        let ml2 = matchlist(links,linkPat)
      endwhile
      let g:haddock_index[DeHTML(entry)] = deepcopy(link)
      "echo entry g:haddock_index[entry]
      let ml = matchlist(r,entryPat)
    endwhile
  endfor
  return 1
endfunction

command! ExportDocIndex call ExportDocIndex()
function! ExportDocIndex()
  call HaveIndex()
  let entries = []
  for key in keys(g:haddock_index)
    let entries += [key,string(g:haddock_index[key])]
  endfor
  call writefile(entries,s:haddock_indexfile)
  redir end
endfunction

command! ImportDocIndex call ImportDocIndex()
function! ImportDocIndex()
  if filereadable(s:haddock_indexfile)
    let lines = readfile(s:haddock_indexfile)
    let i=0
    while i<len(lines)
      let [key,dict] = [lines[i],lines[i+1]]
      sandbox let g:haddock_index[key] = eval(dict) 
      let i+=2
    endwhile
    return 1
  else
    return 0
  endif
endfunction

function! HaveIndex()
  return (g:haddock_index!={} || ImportDocIndex() || DocIndex() )
endfunction

function! MkHaddockModuleIndex()
  let g:haddock_moduleindex = {}
  call HaveIndex()
  for key in keys(g:haddock_index)
    let dict = g:haddock_index[key]
    for module in keys(dict)
      let [_,package;x] = matchlist(dict[module],'^\([^\/]*\)\/')
      let g:haddock_moduleindex[module] = package
    endfor
  endfor
endfunction

function! HaveModuleIndex()
  return (g:haddock_moduleindex!={} || MkHaddockModuleIndex() )
endfunction

" decode HTML symbol encodings (are these all we need?)
function! DeHTML(entry)
  let res = a:entry
  let decode = { '&lt;': '<', '&gt;': '>', '&amp;': '\\&' }
  for enc in keys(decode)
    exe 'let res = substitute(res,"'.enc.'","'.decode[enc].'","g")'
  endfor
  return res
endfunction

" find haddocks for word under cursor
" also lists possible definition sites
map <LocalLeader>? :call Haddock()<cr>
function! Haddock()
  amenu ]Popup.- :echo '-'<cr>
  aunmenu ]Popup
  call HaveIndex()
  let namsym   = Haskell_GetNameSymbol(getline('.'),col('.'),0)
  if namsym==[]
    redraw
    echo 'no name/symbol under cursor!'
    return 0
  endif
  let [start,symb,qual,unqual] = namsym
  let name = unqual
  if !has_key(g:haddock_index,name)
    echoerr name 'not found in haddock index'
    return
  endif
  let dict = g:haddock_index[name]
  if qual!=''
    for key in keys(dict)
      if key==qual
        call DocBrowser(s:libraries . dict[key])
      endif
    endfor
  elseif has("gui_running")
    let i=0
    for key in keys(dict)
      exe 'amenu ]Popup.'.escape(key,'\.').' :call IDoc("'.escape(name,'|').'",'.i.')<cr>'
      let i+=1
    endfor
    popup ]Popup
  else
    let s:choices = keys(dict)
    let key = input('browse docs for '.name.' in: ','','customlist,CompleteAux')
    if key!=''
      call DocBrowser(s:libraries . dict[key])
    endif
  endif
endfunction

" used to pass on choices to CompleteAux
let s:choices=[]

" if there's no gui, use commandline completion instead of :popup
" completion function CompleteAux suggests completions for a:al, wrt to s:choices
function! CompleteAux(al,cl,cp)
  "echomsg '|'.a:al.'|'.a:cl.'|'.a:cp.'|'
  let res = []
  let l = len(a:al)-1
  for r in s:choices
    if l==-1 || r[0 : l]==a:al
      let res += [r]
    endif
  endfor
  return res
endfunction

" use haddock name index for insert mode completion (CTRL-X CTRL-U)
function! CompleteHaddock(findstart, base)
  if a:findstart 
    let namsym   = Haskell_GetNameSymbol(getline('.'),col('.'),-1) " insert-mode: we're 1 beyond the text
    if namsym==[]
      redraw
      echo 'no name/symbol under cursor!'
      return -1
    endif
    let [start,symb,qual,unqual] = namsym
    return (start-1)
  else " find keys matching with "a:base"
    let res  = []
    let l    = len(a:base)-1
    let qual = a:base =~ '^[A-Z][a-zA-Z0-9_'']*\(\.[A-Z][a-zA-Z0-9_'']*\)*\.\?$'
    call HaveIndex() 
    for key in keys(g:haddock_index)
      if key[0 : l]==a:base
        for m in keys(g:haddock_index[key])
          let res += [{"word":key,"menu":m,"dup":1}]
        endfor
      elseif qual " this tends to be slower
        for m in keys(g:haddock_index[key])
          let word = m . '.' . key
          if word[0 : l]==a:base
            let res += [{"word":word,"menu":m,"dup":1}]
          endif
        endfor
      endif
    endfor
    return res
  endif
endfunction
set completefunc=CompleteHaddock
set completeopt=menu,menuone,longest

" fully qualify an unqualified name
map <LocalLeader>. :call Qualify()<cr>
function! Qualify()
  amenu ]Popup.- :echo '-'<cr>
  aunmenu ]Popup
  call HaveIndex()
  let namsym   = Haskell_GetNameSymbol(getline('.'),col('.'),0)
  if namsym==[]
    redraw
    echo 'no name/symbol under cursor!'
    return 0
  endif
  let [start,symb,qual,unqual] = namsym
  if qual!=''  " TODO: should we support re-qualification?
    redraw
    echo 'already qualified'
    return 0
  endif
  let name = unqual
  let line         = line('.')
  let prefix       = (start<=1 ? '' : getline(line)[0:start-2] )
  if !has_key(g:haddock_index,name)
    echoerr name 'not found in haddock index'
    return
  endif
  let i=0
  let dict   =g:haddock_index[name]
  if has("gui_running")
    for key in keys(dict)
      let lhs=escape(prefix.name,'/.|\')
      let rhs=escape(prefix.key.'.'.name,'/&|\')
      exe 'amenu ]Popup.'.escape(key,'\.').' :'.line.'s/'.lhs.'/'.rhs.'/<cr>:noh<cr>'
      let i+=1
    endfor
    popup ]Popup
  else
    let s:choices = keys(dict)
    let key = input('qualify '.name.' with: ','','customlist,CompleteAux')
    if key!=''
      let lhs=escape(prefix.name,'/.\')
      let rhs=escape(prefix.key.'.'.name,'/&\')
      exe line.'s/'.lhs.'/'.rhs.'/'
      noh
    endif
  endif
endfunction

" create import for a (qualified) name
map <LocalLeader>i :call Import(0)<cr>
map <LocalLeader>im :call Import(1)<cr>
function! Import(module)
  amenu ]Popup.- :echo '-'<cr>
  aunmenu ]Popup
  call HaveIndex()
  let namsym   = Haskell_GetNameSymbol(getline('.'),col('.'),0)
  if namsym==[]
    redraw
    echo 'no name/symbol under cursor!'
    return 0
  endif
  let [start,symb,qual,unqual] = namsym
  let name       = unqual
  let pname      = ( symb ? '('.name.')' : name )
  let importlist = a:module ? '' : '('.pname.')'

  if qual!=''
    exe 'call append(search(''\%1c\(import\|module\|{-# OPTIONS\)'',''nb''),''import '.qual.importlist.''')'
    return
  endif

  let line   = line('.')
  let prefix = getline(line)[0:start-1]
  if !has_key(g:haddock_index,name)
    echoerr name 'not found in haddock index'
    return
  endif
  let dict   =g:haddock_index[name]
  if has("gui_running")
    for key in keys(dict)
      " exe 'amenu ]Popup.'.escape(key,'\.').' :call append(search("\\%1c\\(import\\\\|module\\\\|{-# OPTIONS\\)","nb"),"import '.key.importlist.'")<cr>'
      exe 'amenu ]Popup.'.escape(key,'\.').' :call append(search(''\%1c\(import\\|module\\|{-# OPTIONS\)'',''nb''),''import '.key.escape(importlist,'|').''')<cr>'
    endfor
    popup ]Popup
  else
    let s:choices = keys(dict)
    let key = input('import '.name.' from: ','','customlist,CompleteAux')
    if key!=''
      exe 'call append(search(''\%1c\(import\|module\|{-# OPTIONS\)'',''nb''),''import '.key.importlist.''')'
    endif
  endif
endfunction

ftplugin/haskell_hpaste.vim	[[[1
75
" rudimentary hpaste support for vim
" (using netrw for reading, wget for posting/annotating)
"
" claus reinke, last modified: 19/08/2007
"
" part of haskell plugins: http://www.cs.kent.ac.uk/~cr3/toolbox/haskell/Vim/

" unless wget is in your PATH, you need to set g:wget
" before loading this script. windows users are out of 
" luck, unless they have wget installed (such as the 
" cygwin one looked for here), or adapt this script to 
" whatever alternative they have at hand (perhaps using 
" vim's perl/python bindings?)
if !exists("g:wget")
  if executable("wget")
    let g:wget = "!wget -q"
  else
    let g:wget = "!c:\\cygwin\\bin\\wget -q"
  endif
endif

" read (recent) hpaste files
" show index in new buffer, where ,r will open current entry
" and ,p will annotate current entry with current buffer
command! HpasteIndex call HpasteIndex()
function! HpasteIndex()
  new
  read http://hpaste.org
  %s/\_$\_.//g
  %s/<tr[^>]*>//g
  %s/<\/tr>//g
  g/<\/table>/d
  g/DOCTYPE/d
  %s/<td><a href="\/\([0-9]*\)">view<\/a><\/td><td>\([^<]*\)<\/td><td>\([^<]*\)<\/td><td>\([^<]*\)<\/td><td>\([^<]*\)<\/td>/\1 \2 (\3) "\4" \5/
  map <buffer> ,r 0ye:noh<cr>:call HpasteEditEntry('"')<cr>
endfunction

" load an existing entry for editing
command! -nargs=1 HpasteEditEntry call HpasteEditEntry(<f-args>)
function! HpasteEditEntry(entry)
  exe 'edit! http://hpaste.org/'.a:entry.'/0/plain'
  exe 'map <buffer> ,p :call HpasteAnnotate('''.a:entry.''')<cr>'
endfunction

" annotate existing entry (only to be called via ,p in HpasteIndex)
function! HpasteAnnotate(entry)
  let nick  = input("nick? ")
  let title = input("title? ")
  if nick=='' || title==''
    echo "nick or title missing. aborting annotation"
    return
  endif
  call HpastePost('annotate/'.a:entry,nick,title)
endfunction

" post new hpaste entry
" using 'wget --post-data' and url-encoded content
command! HpastePostNew  call HpastePost('new',<args>)
function! HpastePost(mode,nick,title,...)
  let lines = getbufline("%",1,"$") 
  let pat   = '\([^[:alnum:]]\)'
  let code  = '\=printf("%%%02X",char2nr(submatch(1)))'
  let lines = map(lines,'substitute(v:val."\r\n",'''.pat.''','''.code.''',''g'')')

  let url   = 'http://hpaste.org/' . a:mode 
  let nick  = substitute(a:nick,pat,code,'g')
  let title = substitute(a:title,pat,code,'g')
  if a:0==0
    let announce = 'false'
  else
    let announce = a:1
  endif
  let cmd = g:wget.' --post-data="content='.join(lines,'').'&nick='.nick.'&title='.title.'&announce='.announce.'" '.url
  exe escape(cmd,'%')
endfunction
doc/haskellmode.txt	[[[1
398
*haskellmode.txt*	Haskell Mode Plugins	05/09/2007

Authors:
    Claus Reinke <claus.reinke@talk21.com> ~

Homepage:
    http://www.cs.kent.ac.uk/people/staff/cr3/toolbox/haskell/Vim/

CONTENTS                                                         *haskellmode*

    1. Overview                                     |haskellmode-overview|
        1.1 Runtime Requirements                    |haskellmode-requirements|
        1.2 Quick Reference                         |haskellmode-quickref|
    2. Settings                                     |haskellmode-settings|
      2.1 GHC and web browser                       |haskellmode-settings-main|
      2.2 Fine tuning - more configuration options  |haskellmode-settings-fine|
    3. GHC Compiler Integration                     |haskellmode-compiler|
    4. Haddock Integration                          |haskellmode-haddock|
        4.1 Indexing                                |haskellmode-indexing|
        4.2 Lookup                                  |haskellmode-lookup|
        4.3 Editing                                 |haskellmode-editing|
    5. Hpaste Integration                           |haskellmode-hpaste|
    6. Additional Resources                         |haskellmode-resources|

==============================================================================
                                                        *haskellmode-overview*
1. Overview ~

    The Haskell mode plugins provide advanced support for Haskell development
    using GHC/GHCi on Windows and Unix-like systems. The functionality is
    based on Haddock-generated library indices, on GHCi's interactive
    commands, or on simply activating (some of) Vim's built-in program editing
    support in Haskell-relevant fashion. These plugins live side-by-side with
    the pre-defined |syntax-highlighting| support for |haskell| sources, and
    any other Haskell-related plugins you might want to install (see
    |haskellmode-resources|).

    The Haskell mode plugins consist of three filetype plugins (haskell.vim,
    haskell_doc.vim, haskell_hpaste.vim), which by Vim's |filetype| detection
    mechanism will be auto-loaded whenever files with the extension '.hs' are
    opened, and one compiler plugin (ghc.vim) which you will need to load from
    your vimrc file (see |haskellmode-settings|).


                                                    *haskellmode-requirements*
1.1 Runtime Requirements ~

    The plugins require a recent installation of GHC/GHCi. The functionality
    derived from Haddock-generated library indices also requires a local
    installation of the Haddock documentation for GHC's libraries (if there is
    no documentation package for your system, you can download a tar-ball from
    haskell.org), as well as an HTML browser (see |haddock_browser|). If you 
    want to use the experimental hpaste interface, you will also need Wget.

    * GHC/GHCi ~
      Provides core functionality. http://www.haskell.org/ghc

    * HTML library documentation files and indices generated by Haddock ~
      These usually come with your GHC installation, possibly as a separate
      package. If you cannot get them this way, you can download a tar-ball
      from  http://www.haskell.org/ghc/docs/latest/

    * HTML browser with basic CSS support ~
      For browsing Haddock docs.

    * Wget ~
      For interfacing with http://hpaste.org.

      Wget is widely available for modern Unix-like operating systems. Several
      ports also exist for Windows, including:

      - Official GNU Wget (natively compiled for Win32)
        http://www.gnu.org/software/wget/#downloading

      - UnxUtils Wget (natively compiled for Win32, bundled with other ported
        Unix utilities)
        http://sourceforge.net/projects/unxutils/

      - Cygwin Wget (emulated POSIX in Win32, must be run under Cygwin)
        http://cygwin.com/packages/wget/

                                                    *haskellmode-quickref*
1.2 Quick Reference ~

|:make|               load into GHCi, show errors (|quickfix| |:copen|)
|_ct|                 create |tags| file 
|_si|                 show info for id under cursor
|_t|                  show type for id under cursor
|_T|                  insert type declaration for id under cursor
|balloon|             show type for id under mouse pointer
|_?|                  browse Haddock entry for id under cursor
|:IDoc| {identifier}  browse Haddock entry for unqualified {identifier}
|:MDoc| {module}      browse Haddock entry for {module}
|_.|                  qualify unqualified id under cursor
|_i|                  add 'import <module>(<identifier>)' for id under cursor
|_im|                 add 'import <module>' for id under cursor
|_ie|                 make imports explit for import statement under cursor
|_opt|                add OPTIONS_GHC pragma
|i_CTRL-X_CTRL-O|     insert-mode completion based on imported ids (|haskellmode-XO|)
|i_CTRL-X_CTRL-U|     insert-mode completion based on documented ids (|haskellmode-XU|)
|i_CTRL-N|            insert-mode completion based on imported sources
|:GHCi|{command/expr} run GHCi command/expr in current module

|:DocSettings|        show current Haddock-files-related plugin settings
|:DocIndex|           populate Haddock index 
|:ExportDocIndex|     cache current Haddock index to a file
|:HpasteIndex|        Read index of most recent entries from hpaste.org
|:HpastePostNew|      Submit current buffer as a new hpaste 


==============================================================================
                                                        *haskellmode-settings*
2. Settings ~

    The plugins try to find their dependencies in standard locations, so if
    you're lucky, you will only need to set |compiler| to ghc, and configure
    the location of your favourite web browser. Given the variety of things to
    guess, however, some dependencies might not be found correctly, or the
    defaults might not be to your liking, in which case you can do some more
    fine tuning. All of this configuration should happen in your |vimrc|.

                                                   *haskellmode-settings-main*
2.1 GHC and web browser ~

                                                 *compiler-ghc* *ghc-compiler*
    To use the features provided by the GHC |compiler| plugin, use the
    following |autocommand| in your vimrc:
>
        au BufEnter *.hs compiler ghc
<
                                                                       *g:ghc*
    If the compiler plugin can't locate your GHC binary, or if you have
    several versions of GHC installed and have a preference as to which binary
    is used, set |g:ghc|:
>
        :let g:ghc="/usr/bin/ghc-6.6.1"
<
                                                           *g:haddock_browser*
    The preferred HTML browser for viewing Haddock documentation can be set as
    follows:
>
        :let g:haddock_browser="/usr/bin/firefox"
<

                                                   *haskellmode-settings-fine*
2.2 Fine tuning - more configuration options ~

    Most of the fine tuning is likely to happen for the haskellmode_doc.vim
    plugin, so you can check the current settings for this plugin via the
    command |:DocSettings|. If all the settings reported there are to your
    liking, you probably won't need to do any fine tuning.

                                                *g:haddock_browser_callformat*
    By default, the web browser|g:haddock_browser| will be started
    asynchronously (in the background) on Windows or when vim is running in a
    GUI, and synchronously (in the foreground) otherwise. These settings seem
    to work fine if you are using a console mode browser (eg, when editing in
    a remote session), or if you are starting a GUI browser that will launch
    itself in the background. But if these settings do not work for you, you
    can change the default browser launching behavior.

    This is controlled by |g:haddock_browser_callformat|. It specifies a
    format string which uses two '%s' parameters, the first representing the
    path of the browser to launch, and the second is the documentation URL
    (minus the protocol specifier, i.e. file://) passed to it by the Haddock
    plugin.  For instance, to launch a GUI browser on Unix-like systems and
    force it to the background (see also |shellredir|):
>
        :let g:haddock_browser_callformat = '%s file://%s '.printf(&shellredir,'/dev/null').' &'
<
                                                            *g:haddock_docdir*
    Your system's installed Haddock documentation for GHC and its libraries
    should be automatically detected. If the plugin can't locate them, you
    must point |g:haddock_docdir| to the path containing the master index.html
    file for the subdirectories 'libraries', 'Cabal', 'users_guide', etc.:
>
        :let g:haddock_docdir="/usr/local/share/doc/ghc/html/"
<
                                                      *g:haddock_indexfiledir*
    The information gathered from Haddock's index files will be stored in a
    file called 'haddock_index.vim' in a directory derived from the Haddock
    location, or in $HOME. To configure another directory for the index file,
    use: 
>
        :let g:haddock_indexfiledir="~/.vim"
<
                                                                      *g:wget*
    If you also want to try the experimental hpaste functionality, you might
    you need to set |g:wget| before the |hpaste| plugin is loaded (unless wget
    is in your PATH):
>
        :let g:wget="C:\Program Files\wget\wget.exe"
<

    Finally, the mappings actually use|<LocalLeader>|behind the scenes, so if
    you have to, you can redefine|maplocalleader|to something other than '_'.
    Just remember that the docs still refer to mappings starting with '_', to
    avoid confusing the majority of users!-)

==============================================================================
                                                  *haskellmode-compiler* *ghc*
3. GHC Compiler Integration ~

    The GHC |compiler| plugin sets the basic |errorformat| and |makeprg| to
    enable |quickfix| mode using GHCi, and provides functionality for show
    info (|_si|), show type (|_t| or mouse |balloon|), add type declaration
    (|_T|), create tag file (|_ct|), and insert-mode completion
    (|i_CTRL-X_CTRL-O|) based on GHCi browsing of the current and imported
    modules. 

    To avoid frequent calls to GHCi, type information is cached in Vim. The
    cache will be populated the first time a command depends on it, and will
    be refreshed every time a |:make| goes through without generating errors
    (if the |:make| does not succeed, the old types will remain available in
    Vim).  You can also unconditionally force reloading of type info using
    |:GHCReload| (if GHCi cannot load your file, the type info will be empty).


    In addition to the standard|quickfix| commands, the GHC compiler plugin
    provides:

                                                                  *:GHCReload*
:GHCReload              Reload modules and unconditionally refresh cache of
                        type info. Usually, |:make| is prefered, as that will
                        refresh the cache only if GHCi reports no errors, and
                        show the errors otherwise.

                                                                       *:GHCi*
:GHCi {command/expr}    Run GHCi commands/expressions in the current module.                  

                                                                         *_ct*
_ct                     Create |tags| file for the current Haskell source
                        file. This uses GHCi's :ctags command, so it will work
                        recursively, but will only list tags for exported
                        entities.

                                                                        *_opt*
_opt                    Shows a menu of frequently used GHC compiler options 
                        (selecting an entry adds the option as a pragma to the
                        start of the file).

                                                                         *_si*
_si                     Show extended information for the name under the
                        cursor. Uses GHCi's :info command.

                                                                          *_t*
_t                      Show type for the name under the cursor. Uses cached
                        info from GHCi's :browse command.

                                                                          *_T*
_T                      Insert type declaration for the name under the cursor.
                        Uses cached info from GHCi's :browse command.

                                *haskellmode-XO* *haskellmode-omni-completion*
CTRL-X CTRL-O           Standard insert-mode omni-completion based on the
                        cached type info from GHCi browsing current and
                        imported modules. Only names from the current and from
                        imported modules are included (the completion menu
                        also show the type of each identifier).

==============================================================================
                                               *haskellmode-haddock* *haddock*
4. Haddock Integration ~

    Haskell mode integrates with Haddock-generated HTML documentation,
    providing features such as navigating to the Haddock entry for the
    identifier under the cursor (|_?|), completion for the identifier under
    the cursor (|i_CTRL-X_CTRL-U|), and adding import statements (|_i| |_im|)
    or module qualifier (|_.|) for the identifier under the cursor.

    These commands operate on an internal Haddock index built from the
    platform's installed Haddock documentation for GHC's libraries. Since
    populating this index takes several seconds, it should be stored as a 
    file called 'haddock_index.vim' in the directory specified by
    |g:haddock_indexfiledir|.

    Some commands present a different interface (popup menu or command-line
    completion) according to whether the current Vim instance is graphical or
    console-based (actually: whether or not the GUI is running). Such
    differences are marked below with the annotations (GUI) and (CLI),
    respectively.

    |:DocSettings| shows the settings for this plugin. If you are happy with
    them, you can call |:ExportDocIndex| to populate and write out the
    documentation index (should be called once for every new version of GHC).

                                                                *:DocSettings*
:DocSettings            Show current Haddock-files-related plugin settings.


                                                        *haskellmode-indexing*
4.1 Indexing ~

                                                                   *:DocIndex*
:DocIndex               Populate the Haddock index from the GHC library
                        documentation.

                                                             *:ExportDocIndex*
:ExportDocIndex         Cache the current Haddock index to a file (populate
                        index first, if empty).


                                                          *haskellmode-lookup*
4.2 Lookup ~

                                                                          *_?*
_?                      Open the Haddock entry (in |haddock_browser|) for an
                        identifier under the cursor, selecting full
                        qualifications from a popup menu (GUI) or via
                        command-line completion (CLI), if the identifier is
                        not qualified.

                                                                       *:IDoc*
:IDoc {identifier}      Open the Haddock entry for the unqualified
                        {identifier} in |haddock_browser|, suggesting possible
                        full qualifications.

                                                                       *:MDoc*
:MDoc {module}          Open the Haddock entry for {module} in
                        |haddock_browser| (with command-line completion for
                        the fully qualified module name).


                                                         *haskellmode-editing*
4.3 Editing ~

                                                                          *_.*
_.                      Fully qualify the unqualified name under the cursor
                        selecting full qualifications from a popup menu (GUI)
                        or via command-line completion (CLI).

                                                                          *_i*
_i                      Add 'import <module>(<identifier>)' statement for the
                        identifier under the cursor, selecting fully qualified
                        modules from a popup menu (GUI) or via command-line
                        completion (CLI), if the identifier is not qualified.
                        This currently adds one import statement per call
                        instead of merging into existing import statements.

                                                                         *_im*
_im                     Add 'import <module>' statement for the identifier
                        under the cursor, selecting fully qualified modules
                        from a popup menu (GUI) or via command-line completion
                        (CLI), if the identifier is not qualified.  This
                        currently adds one import statement per call instead
                        of merging into existing import statements.

                                                                         *_ie*
_ie                     On an 'import <module>' line, in a correctly loadable
                        module, temporarily comment out import and use :make
                        'not in scope' errors to explicitly list imported
                        identifiers.

                                *haskellmode_XU* *haskellmode-user-completion*
CTRL-X CTRL-U           User-defined insert mode name completion based on all
                        names known to the Haddock index, including package
                        names. Completions are presented in a popup menu which
                        also displays the fully qualified module from which
                        each entry may be imported.

==============================================================================
                                                 *haskellmode-hpaste* *hpaste*
5. Hpaste Integration ~

    This experimental feature allows browsing and posting to
    http://hpaste.org, a Web-based pastebin tailored for Haskell code.


                                                                *:HpasteIndex*
:HpasteIndex            Read the most recent entries from hpaste.org. Show an
                        index of the entries in a new buffer, where ',r' will
                        open the current highlighted entry and ',p' will
                        annotate it with the current buffer.

                                                              *:HpastePostNew*
:HpastePostNew          Submit current buffer as a new hpaste entry.

==============================================================================
                                                       *haskellmode-resources*
6. Additional Resources ~

    An illustrated walk-through of these plugins is available at:

    http://www.cs.kent.ac.uk/people/staff/cr3/toolbox/haskell/Vim/vim.html

    Other Haskell-related Vim plugins can be found here:

    http://www.haskell.org/haskellwiki/Libraries_and_tools/Program_development#Vim

    Make sure to read about Vim's other program-editing features in its online
    |user-manual|. Also have a look at Vim tips and plugins at www.vim.org -
    two other plugins I tend to use when editing Haskell are AlignPlugin.vim
    (to line up regexps for definitions, keywords, comments, etc. in
    consecutive lines) and surround.vim (to surround text with quotes,
    brackets, parentheses, comments, etc.).

==============================================================================
 vim:tw=78:ts=8:ft=help:
