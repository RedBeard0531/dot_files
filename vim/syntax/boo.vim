" Vim syntax file
" Language:	boo
" Maintainer:	Mathias Stearn <mstearn@umd.edu>
" Filenames:	*.boo
"
" Based on python.vim 
" by Neil Schemenauer <nas@python.ca> and Dmitry Vasiliev <dima@hlabs.spb.ru>
" 
" and boo.vim
" by Rodrigo B. de Oliveira
"
" Thanks:
"
"    Rodrigo B. de Oliveira
"        for the boo language

"
" Options:
"
"    For set option do: let OPTION_NAME = 1
"    For clear option do: let OPTION_NAME = 0
"
" Option names:
"
"    For highlight builtin functions:
"       boo_highlight_builtins
"
"    For highlight standard exceptions:
"       boo_highlight_exceptions
"
"    For highlight indentation errors:
"       boo_highlight_indent_errors
"
"    For highlight trailing spaces:
"       boo_highlight_space_errors
"
"    For fast machines:
"       boo_slow_sync
"

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

" Not override previously set options
if !exists("boo_highlight_builtins")
  let boo_highlight_builtins = 1
endif
if !exists("boo_highlight_exceptions")
  let boo_highlight_exceptions = 1
endif
if !exists("boo_highlight_indent_errors")
  let boo_highlight_indent_errors = 1
endif
if !exists("boo_highlight_space_errors")
  let boo_highlight_space_errors = 0
endif

syn keyword booStatement        break continue 
syn keyword booStatement        except exec ensure
syn keyword booStatement        pass print raise
syn keyword booStatement        return try
syn keyword booStatement        assert
syn keyword booStatement        self
syn keyword booStatement        internal final private override static public protected virtual partial
syn keyword booStatement        ref
syn keyword booStatement        yield
syn keyword booStatement        enum
syn keyword booStatement        of def class constructor destructor nextgroup=booFunction skipwhite
syn keyword booStatement        def interface nextgroup=booFunction skipwhite
syn keyword booStatement        def struct nextgroup=booFunction skipwhite
syn keyword booStatement        namespace event delegate
syn keyword booType             sbyte short int long byte ushort uint ulong single double decimal char bool 
syn keyword booRepeat   	for while
syn keyword booConditional      if unless elif else
syn keyword booOperator 	and in is not or
syn keyword booPreCondit        import from
syn keyword booTodo             WARNING TODO FIXME XXX contained
syn keyword booCast		cast as

syn match   booFunction 	"[a-zA-Z_][a-zA-Z0-9_]*" contained
syn match   booComment  	"#.*$" contains=booTodo,@Spell
syn match   booComment2  	"//.*$" contains=booTodo,@Spell
syn region  booRegionComment    start="/\*"  end="\*/" contains=booTodo,@Spell

syn match   booRun		"\%^#!.*$"

" Errors

" TODO: Mixing spaces and tabs also may be used for pretty formatting multiline
" statements. For now I don't know how to work around this.
if exists("boo_highlight_indent_errors") && boo_highlight_indent_errors != 0
  syn match booIndentError	"^\s*\( \t\|\t \)\s*\S"me=e-1 display
endif

" Trailing space errors
if exists("boo_highlight_space_errors") && boo_highlight_space_errors != 0
  syn match booSpaceError	"\s\+$" display
endif

" Strings
syn region booString            start=+'+ skip=+\\\\\|\\'+ excludenl end=+'+ end=+$+ keepend contains=booEscape,booEscapeError,@Spell
syn region booString            start=+"+ skip=+\\\\\|\\"+ excludenl end=+"+ end=+$+ keepend contains=booEscape,booEscapeError,@Spell
syn region booRawString 	start=+"""+ end=+"""+ keepend contains=booSpaceError,@Spell
syn match  booEscape            +\\[abfnrtv'"\\]+ display contained
syn match  booEscape		"\\\o\o\=\o\=" display contained
syn match  booEscapeError	"\\\o\{,2}[89]" display contained
syn match  booEscape            "\\x\x\{2}" display contained
syn match  booEscapeError	"\\x\x\=\X" display contained
syn match  booEscape            "\(\\u\x\{4}\|\\U\x\{8}\)" display contained
syn match  booEscapeError       "\(\\u\x\{,3}\X\|\\U\x\{,7}\X\)" display contained
syn match  booEscape            "\\\$"

syn region Normal               matchgroup=booStrInterp start=+${+ end=+}+ contains=TOP,@Spell contained containedin=booString,booRawString

syn region booRegex            start=+/+ skip=+\\\\\|\\/+ excludenl end=+/+ end=+$+ keepend contains=booRegexSpaceError
syn region booAtRegex            start=+@/+ skip=+\\\\\|\\/+ excludenl end=+/+ end=+$+ keepend 
syn match booRegexSpaceError    "\s" display contained containedin=booRegex

" Numbers (ints, longs, floats, complex)
syn match   booHexNumber	"\<0[xX]\x\+\>" display
syn match   booInt      	"\<\d\+\>" display
syn match   booFloat		"\.\d\+\([eE][+-]\=\d\+\)\=\>" display
syn match   booFloat		"\<\d\+[eE][+-]\=\d\+\>" display
syn match   booFloat		"\<\d\+\.\d*\([eE][+-]\=\d\+\)\=" display

syn match   booTimespan         "\<\d\+\(ms\|s\|m\|h\|d\)" 

syn match   booOctalError	"\<0\o*[89]\d*\>" display
syn match   booHexError	        "\<0[xX]\X\+\>" display

if exists("boo_highlight_builtins") && boo_highlight_builtins != 0
  " builtin functions, types and objects, not really part of the syntax
  syn keyword booBuiltin        Ellipsis string NotImplemented false true abs
  syn keyword booBuiltin        apply regex buffer callable chr classmethod cmp
  syn keyword booBuiltin        coerce compile complex delattr dict divmod
  syn keyword booBuiltin        eval execfile float globals duck
  syn keyword booBuiltin        hasattr hash hex id input bool int intern isa
  syn keyword booBuiltin        issubclass len locals long map max
  syn keyword booBuiltin        min object oct open ord pow property range
  syn keyword booBuiltin        raw_input reduce reload repr round setattr
  syn keyword booBuiltin        slice staticmethod str super tuple typeof unichr
  syn keyword booBuiltin        unicode vars xrange zip null
endif

if exists("boo_highlight_exceptions") && boo_highlight_exceptions != 0
  " Builtin exceptions and warnings
  syn keyword booException      ArithmeticError AssertionError AttributeError
  syn keyword booException      DeprecationWarning EOFError EnvironmentError
  syn keyword booException      Exception FloatingPointError IOError
  syn keyword booException      ImportError IndentationError IndexError
  syn keyword booException      KeyError KeyboardInterrupt LookupError
  syn keyword booException      MemoryError NameError NotImplementedError
  syn keyword booException      OSError OverflowError OverflowWarning
  syn keyword booException      ReferenceError RuntimeError RuntimeWarning
  syn keyword booException      StandardError StopIteration SyntaxError
  syn keyword booException      SyntaxWarning SystemError SystemExit TabError
  syn keyword booException      TypeError UnboundLocalError UnicodeError
  syn keyword booException      UserWarning ValueError Warning WindowsError
  syn keyword booException      ZeroDivisionError
endif

if exists("boo_slow_sync") && boo_slow_sync != 0
  syn sync minlines=2000
else
  " This is fast but code inside triple quoted strings screws it up. It
  " is impossible to fix because the only way to know if you are inside a
  " triple quoted string is to start from the beginning of the file.
  syn sync match booSync grouphere NONE "):$"
  syn sync maxlines=200
endif

if version >= 508 || !exists("did_boo_syn_inits")
  if version <= 508
    let did_boo_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink booStatement		Statement
  HiLink booImport		Statement
  HiLink booFunction		Function
  HiLink booConditional		Conditional
  HiLink booPreCondit           PreCondit
  HiLink booRepeat		Repeat
  HiLink booException		Exception
  HiLink booOperator		Operator
  HiLink booCast                Operator   
  HiLink booType                Type

  HiLink booComment		Comment
  HiLink booComment2		Comment
  HiLink booRegionComment	Comment
  HiLink booRun			Special
  HiLink booTodo		Todo

  HiLink booError		Error
  HiLink booIndentError		Error
  HiLink booSpaceError		Error
  HiLink booRegexError		Error

  HiLink booString		String
  HiLink booRawString		String
  HiLink booRegex		String
  HiLink booAtRegex		String

  HiLink booEscape		Special
  HiLink booRawEscape		Special
  HiLink booEscapeError		Error
  HiLink booStrInterp   	Special

  HiLink booStrFormat		Special

  HiLink booDocTest		Special
  HiLink booDocTest2		Special

  HiLink booNumber		Number
  HiLink booHexNumber		Number
  HiLink booFloat		Float
  HiLink booTimespan		Number
  HiLink booOctalError		Error
  HiLink booHexError		Error

  HiLink booBuiltin Function

  HiLink booExClass	Structure

  delcommand HiLink
endif

let b:current_syntax = "boo"
