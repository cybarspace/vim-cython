" Vim syntax file
" Language:             Cython
" Current Maintainer:   Sheikh Saad <cybarspace.github.io>
" URL:                  https://github.com/cybarspace/cython.vim
" Last Change:          05-Mar-2021
" Filenames:            *.pyx
" Version:              0.2
"
" Based on python.vim (from Vim 6.1 distribution)
" Dmitry Vasiliev <dima at hlabs dot org>
"
" Options
" =======
"
"    :let OPTION_NAME = 1                   Enable option
"    :let OPTION_NAME = 0                   Disable option
"
"
" Option to select Python version
" -------------------------------
"
"    python_version_2                       Enable highlighting for Python 2
"                                           (Python 3 highlighting is enabled
"                                           by default). Can also be set as
"                                           a buffer (b:python_version_2)
"                                           variable.
"
"    You can also use the following local to buffer commands to switch
"    between two highlighting modes:
"
"    :Python2Syntax                         Switch to Python 2 highlighting
"                                           mode
"    :Python3Syntax                         Switch to Python 3 highlighting
"                                           mode
"
" Option names used by the script
" -------------------------------
"
"    python_highlight_builtins              Highlight builtin functions and
"                                           objects
"    python_highlight_builtin_objs          Highlight builtin objects only
"    python_highlight_builtin_funcs         Highlight builtin functions only
"    python_highlight_exceptions            Highlight standard exceptions
"    python_highlight_string_formatting     Highlight % string formatting
"    python_highlight_string_format         Highlight str.format syntax
"    python_highlight_string_templates      Highlight string.Template syntax
"    python_highlight_indent_errors         Highlight indentation errors
"    python_highlight_space_errors          Highlight trailing spaces
"    python_highlight_doctests              Highlight doc-tests
"    python_print_as_function               Highlight 'print' statement as
"                                           function for Python 2
"    python_highlight_file_headers_as_comments
"                                           Highlight shebang and coding
"                                           headers as comments
"
"    python_highlight_all                   Enable all the options above
"                                           NOTE: This option don't override
"                                           any previously set options
"
"    python_slow_sync                       Can be set to 0 for slow machines
"

" For version 5.x: Clear all syntax items
" For versions greater than 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

"
" Commands
"
command! -buffer Python2Syntax let b:python_version_2 = 1 | let &syntax=&syntax
command! -buffer Python3Syntax let b:python_version_2 = 0 | let &syntax=&syntax

" Enable option if it's not defined
function! s:EnableByDefault(name)
  if !exists(a:name)
    let {a:name} = 1
  endif
endfunction

" Check if option is enabled
function! s:Enabled(name)
  return exists(a:name) && {a:name}
endfunction

" Is it Python 2 syntax?
function! s:Python2Syntax()
  if exists("b:python_version_2")
      return b:python_version_2
  endif
  return s:Enabled("g:python_version_2")
endfunction

"
" Default options
"

call s:EnableByDefault("g:python_slow_sync")

if s:Enabled("g:python_highlight_all")
  call s:EnableByDefault("g:python_highlight_builtins")
  if s:Enabled("g:python_highlight_builtins")
    call s:EnableByDefault("g:python_highlight_builtin_objs")
    call s:EnableByDefault("g:python_highlight_builtin_funcs")
  endif
  call s:EnableByDefault("g:python_highlight_exceptions")
  call s:EnableByDefault("g:python_highlight_string_formatting")
  call s:EnableByDefault("g:python_highlight_string_format")
  call s:EnableByDefault("g:python_highlight_string_templates")
  call s:EnableByDefault("g:python_highlight_indent_errors")
  call s:EnableByDefault("g:python_highlight_space_errors")
  call s:EnableByDefault("g:python_highlight_doctests")
  call s:EnableByDefault("g:python_print_as_function")
endif

"
" Builtin isolator
"

syn match pythonBuiltinIsolator	"\(\.[\n \t]*\)\@160<!\<\K\+\>"

"
" Keywords
"

syn keyword pythonStatement     break continue del
syn keyword pythonStatement     exec return
syn keyword pythonStatement     pass raise
syn keyword pythonStatement     global assert
syn keyword pythonStatement     lambda
syn keyword pythonStatement     with
syn keyword pythonStatement     def class nextgroup=pythonFunction skipwhite

syn keyword pythonClassVar    self clssyn match pythonOperator        '\V=\|-\|+\|*\|@\|/\|%\|&\||\|^\|~\|<\|>\|!='

syn keyword pythonRepeat        for while
syn keyword pythonConditional   if elif else
" Cython: removed
" " The standard pyrex.vim unconditionally removes the pythonInclude group, so
" " we provide a dummy group here to avoid crashing pyrex.vim.
" syn keyword pythonInclude       import
syn keyword pythonImport        import
" Cython: removed
" syn keyword pythonException     try except finally
syn keyword pythonException     try finally
syn keyword pythonOperator      and in is not or

syn match pythonStatement   "\<yield\>" display
syn match pythonImport      "\<from\>" display
" Cython: added
syn match pythonException   "\<except\>?\?"

if s:Python2Syntax()
  if !s:Enabled("g:python_print_as_function")
    syn keyword pythonStatement  print
  endif
  syn keyword pythonImport      as
  " Cython: removed
  " syn match   pythonFunction    "[a-zA-Z_][a-zA-Z0-9_]*" display contained
else
  syn keyword pythonStatement   as nonlocal None
  syn match   pythonStatement   "\<yield\s\+from\>" display
  syn keyword pythonBoolean     True False
  " Cython: removed
  " syn match   pythonFunction    "\%([^[:cntrl:][:space:][:punct:][:digit:]]\|_\)\%([^[:cntrl:][:punct:][:space:]]\|_\)*" display contained
  syn keyword pythonStatement   await
  syn match   pythonStatement   "\<async\s\+def\>" nextgroup=pythonFunction skipwhite
  syn match   pythonStatement   "\<async\s\+with\>" display
  syn match   pythonStatement   "\<async\s\+for\>" display
endif

" Cython: added
syn keyword pythonStatement const gil new nogil
syn keyword pythonStatement cppclass enum struct union nextgroup=pythonFunction skipwhite
syn keyword pythonStatement cpdef nextgroup=cythonType,pythonFunction skipwhite
syn match pythonStatement "\v<cdef(\s+(api|public api|public|class|enum|inline|readonly|struct|packed struct|union))?>" nextgroup=cythonType,pythonFunction skipwhite
syn match pythonStatement "\v<ctypedef(\s+(enum|fused|struct|union))?>" nextgroup=pythonFunction skipwhite
syn keyword pythonConditional ELIF ELSE IF
syn keyword pythonImport DEF
syn keyword pythonImport cimport include
syn match pythonImport "\v<cdef\s+extern\s+from\ze\s+(\"|'|\*)"
" Note (also for pythonFunction below): \zs doesn't work there.
syn match pythonImport "\v%(<cdef\s+extern\s+from\s+(\"[^"]+\"|'[^']+'|\*)\s+)@<=namespace\ze(\s+\"[^"]+\"|'[^']+')"
" Cython: we cannot use the "contained" mechanism because we may need to match
" a return type declaration first, so we back-assert a def.
" (\s|\w|\\\n|\.|(\[.*\])|\*)*: return type, may be a dotted name, an array or a
" pointer.
syn match pythonFunction
      \ "\v%(%(def\s|class\s|cppclass\s|ctypedef\s|cpdef\s|cdef\s|enum\s|struct\s|union\s|\@)%(\s|\w|\\\n|\.|%(\[.*\])|\*)*)@<=<\h\w*>\ze\W*%(\:|\()"
syn match cythonType
      \ "\v%(cdef\s+)@<=(\w|\.)+"

"
" Decorators (new in Python 2.4)
"

syn match   pythonDecorator	"^\s*\zs@" display nextgroup=pythonDottedName skipwhite
if s:Python2Syntax()
  syn match   pythonDottedName "[a-zA-Z_][a-zA-Z0-9_]*\%(\.[a-zA-Z_][a-zA-Z0-9_]*\)*" display contained
else
  syn match   pythonDottedName "\%([^[:cntrl:][:space:][:punct:][:digit:]]\|_\)\%([^[:cntrl:][:punct:][:space:]]\|_\)*\%(\.\%([^[:cntrl:][:space:][:punct:][:digit:]]\|_\)\%([^[:cntrl:][:punct:][:space:]]\|_\)*\)*" display contained
endif
syn match   pythonDot        "\." display containedin=pythonDottedName

"
" Comments
"

syn match   pythonComment	"#.*$" display contains=pythonTodo,@Spell
if !s:Enabled("g:python_highlight_file_headers_as_comments")
  syn match   pythonRun		"\%^#!.*$"
  syn match   pythonCoding	"\%^.*\%(\n.*\)\?#.*coding[:=]\s*[0-9A-Za-z-_.]\+.*$"
  " Cython.Compiler.Parsing._match_compiler_directive_comment.
  syn match   pythonDirective	"\v^\#\s*cython\s*\:\s*((\w|\.)+\s*\=.*)$"
  " Cython.Build.Dependencies.DistutilsInfo.__init__.
  syn match   pythonDirective   "\v^\#\s*distutils:.*"
endif
syn keyword pythonTodo		TODO FIXME XXX contained

"
" Errors
"

syn match pythonError		"\<\d\+\D\+\>" display
syn match pythonError		"[$?]" display
syn match pythonError		"[&|]\{2,}" display
syn match pythonError		"[=]\{3,}" display

" Mixing spaces and tabs also may be used for pretty formatting multiline
" statements
if s:Enabled("g:python_highlight_indent_errors")
  syn match pythonIndentError	"^\s*\%( \t\|\t \)\s*\S"me=e-1 display
endif

" Trailing space errors
if s:Enabled("g:python_highlight_space_errors")
  syn match pythonSpaceError	"\s\+$" display
endif

"
" Strings
"

if s:Python2Syntax()
  " Python 2 strings
  syn region pythonString   start=+[bB]\='+ skip=+\\\\\|\\'\|\\$+ excludenl end=+'+ end=+$+ keepend contains=pythonBytesEscape,pythonBytesEscapeError,pythonUniEscape,pythonUniEscapeError,@Spell
  syn region pythonString   start=+[bB]\="+ skip=+\\\\\|\\"\|\\$+ excludenl end=+"+ end=+$+ keepend contains=pythonBytesEscape,pythonBytesEscapeError,pythonUniEscape,pythonUniEscapeError,@Spell
  syn region pythonString   start=+[bB]\="""+ end=+"""+ keepend contains=pythonBytesEscape,pythonBytesEscapeError,pythonUniEscape,pythonUniEscapeError,pythonDocTest2,pythonSpaceError,@Spell
  syn region pythonString   start=+[bB]\='''+ end=+'''+ keepend contains=pythonBytesEscape,pythonBytesEscapeError,pythonUniEscape,pythonUniEscapeError,pythonDocTest,pythonSpaceError,@Spell
else
  " Python 3 byte strings
  syn region pythonBytes		start=+[bB]'+ skip=+\\\\\|\\'\|\\$+ excludenl end=+'+ end=+$+ keepend contains=pythonBytesError,pythonBytesContent,@Spell
  syn region pythonBytes		start=+[bB]"+ skip=+\\\\\|\\"\|\\$+ excludenl end=+"+ end=+$+ keepend contains=pythonBytesError,pythonBytesContent,@Spell
  syn region pythonBytes		start=+[bB]"""+ end=+"""+ keepend contains=pythonBytesError,pythonBytesContent,pythonDocTest2,pythonSpaceError,@Spell
  syn region pythonBytes		start=+[bB]'''+ end=+'''+ keepend contains=pythonBytesError,pythonBytesContent,pythonDocTest,pythonSpaceError,@Spell

  syn match pythonBytesError    ".\+" display contained
  syn match pythonBytesContent  "[\u0000-\u00ff]\+" display contained contains=pythonBytesEscape,pythonBytesEscapeError
endif

syn match pythonBytesEscape       +\\[abfnrtv'"\\]+ display contained
syn match pythonBytesEscape       "\\\o\o\=\o\=" display contained
syn match pythonBytesEscapeError  "\\\o\{,2}[89]" display contained
syn match pythonBytesEscape       "\\x\x\{2}" display contained
syn match pythonBytesEscapeError  "\\x\x\=\X" display contained
syn match pythonBytesEscape       "\\$"

syn match pythonUniEscape         "\\u\x\{4}" display contained
syn match pythonUniEscapeError    "\\u\x\{,3}\X" display contained
syn match pythonUniEscape         "\\U\x\{8}" display contained
syn match pythonUniEscapeError    "\\U\x\{,7}\X" display contained
syn match pythonUniEscape         "\\N{[A-Z ]\+}" display contained
syn match pythonUniEscapeError    "\\N{[^A-Z ]\+}" display contained

if s:Python2Syntax()
  " Python 2 Unicode strings
  syn region pythonUniString  start=+[uU]'+ skip=+\\\\\|\\'\|\\$+ excludenl end=+'+ end=+$+ keepend contains=pythonBytesEscape,pythonBytesEscapeError,pythonUniEscape,pythonUniEscapeError,@Spell
  syn region pythonUniString  start=+[uU]"+ skip=+\\\\\|\\"\|\\$+ excludenl end=+"+ end=+$+ keepend contains=pythonBytesEscape,pythonBytesEscapeError,pythonUniEscape,pythonUniEscapeError,@Spell
  syn region pythonUniString  start=+[uU]"""+ end=+"""+ keepend contains=pythonBytesEscape,pythonBytesEscapeError,pythonUniEscape,pythonUniEscapeError,pythonDocTest2,pythonSpaceError,@Spell
  syn region pythonUniString  start=+[uU]'''+ end=+'''+ keepend contains=pythonBytesEscape,pythonBytesEscapeError,pythonUniEscape,pythonUniEscapeError,pythonDocTest,pythonSpaceError,@Spell
else
  " Python 3 strings
  syn region pythonString   start=+'+ skip=+\\\\\|\\'\|\\$+ excludenl end=+'+ end=+$+ keepend contains=pythonBytesEscape,pythonBytesEscapeError,pythonUniEscape,pythonUniEscapeError,@Spell
  syn region pythonString   start=+"+ skip=+\\\\\|\\"\|\\$+ excludenl end=+"+ end=+$+ keepend contains=pythonBytesEscape,pythonBytesEscapeError,pythonUniEscape,pythonUniEscapeError,@Spell
  syn region pythonString   start=+"""+ end=+"""+ keepend contains=pythonBytesEscape,pythonBytesEscapeError,pythonUniEscape,pythonUniEscapeError,pythonDocTest2,pythonSpaceError,@Spell
  syn region pythonString   start=+'''+ end=+'''+ keepend contains=pythonBytesEscape,pythonBytesEscapeError,pythonUniEscape,pythonUniEscapeError,pythonDocTest,pythonSpaceError,@Spell
endif

if s:Python2Syntax()
  " Python 2 Unicode raw strings
  syn region pythonUniRawString start=+[uU][rR]'+ skip=+\\\\\|\\'\|\\$+ excludenl end=+'+ end=+$+ keepend contains=pythonRawEscape,pythonUniRawEscape,pythonUniRawEscapeError,@Spell
  syn region pythonUniRawString start=+[uU][rR]"+ skip=+\\\\\|\\"\|\\$+ excludenl end=+"+ end=+$+ keepend contains=pythonRawEscape,pythonUniRawEscape,pythonUniRawEscapeError,@Spell
  syn region pythonUniRawString start=+[uU][rR]"""+ end=+"""+ keepend contains=pythonUniRawEscape,pythonUniRawEscapeError,pythonDocTest2,pythonSpaceError,@Spell
  syn region pythonUniRawString start=+[uU][rR]'''+ end=+'''+ keepend contains=pythonUniRawEscape,pythonUniRawEscapeError,pythonDocTest,pythonSpaceError,@Spell

  syn match  pythonUniRawEscape       "\([^\\]\(\\\\\)*\)\@<=\\u\x\{4}" display contained
  syn match  pythonUniRawEscapeError  "\([^\\]\(\\\\\)*\)\@<=\\u\x\{,3}\X" display contained
endif

" Python 2/3 raw strings
if s:Python2Syntax()
  syn region pythonRawString  start=+[bB]\=[rR]'+ skip=+\\\\\|\\'\|\\$+ excludenl end=+'+ end=+$+ keepend contains=pythonRawEscape,@Spell
  syn region pythonRawString  start=+[bB]\=[rR]"+ skip=+\\\\\|\\"\|\\$+ excludenl end=+"+ end=+$+ keepend contains=pythonRawEscape,@Spell
  syn region pythonRawString  start=+[bB]\=[rR]"""+ end=+"""+ keepend contains=pythonDocTest2,pythonSpaceError,@Spell
  syn region pythonRawString  start=+[bB]\=[rR]'''+ end=+'''+ keepend contains=pythonDocTest,pythonSpaceError,@Spell
else
  syn region pythonRawString  start=+[rR]'+ skip=+\\\\\|\\'\|\\$+ excludenl end=+'+ end=+$+ keepend contains=pythonRawEscape,@Spell
  syn region pythonRawString  start=+[rR]"+ skip=+\\\\\|\\"\|\\$+ excludenl end=+"+ end=+$+ keepend contains=pythonRawEscape,@Spell
  syn region pythonRawString  start=+[rR]"""+ end=+"""+ keepend contains=pythonDocTest2,pythonSpaceError,@Spell
  syn region pythonRawString  start=+[rR]'''+ end=+'''+ keepend contains=pythonDocTest,pythonSpaceError,@Spell

  syn region pythonRawBytes  start=+[bB][rR]'+ skip=+\\\\\|\\'\|\\$+ excludenl end=+'+ end=+$+ keepend contains=pythonRawEscape,@Spell
  syn region pythonRawBytes  start=+[bB][rR]"+ skip=+\\\\\|\\"\|\\$+ excludenl end=+"+ end=+$+ keepend contains=pythonRawEscape,@Spell
  syn region pythonRawBytes  start=+[bB][rR]"""+ end=+"""+ keepend contains=pythonDocTest2,pythonSpaceError,@Spell
  syn region pythonRawBytes  start=+[bB][rR]'''+ end=+'''+ keepend contains=pythonDocTest,pythonSpaceError,@Spell
endif

syn match pythonRawEscape +\\['"]+ display transparent contained

if s:Enabled("g:python_highlight_string_formatting")
  " % operator string formatting
  if s:Python2Syntax()
    syn match pythonStrFormatting	"%\%(([^)]\+)\)\=[-#0 +]*\d*\%(\.\d\+\)\=[hlL]\=[diouxXeEfFgGcrs%]" contained containedin=pythonString,pythonUniString,pythonUniRawString,pythonRawString
    syn match pythonStrFormatting	"%[-#0 +]*\%(\*\|\d\+\)\=\%(\.\%(\*\|\d\+\)\)\=[hlL]\=[diouxXeEfFgGcrs%]" contained containedin=pythonString,pythonUniString,pythonUniRawString,pythonRawString
  else
    syn match pythonStrFormatting	"%\%(([^)]\+)\)\=[-#0 +]*\d*\%(\.\d\+\)\=[hlL]\=[diouxXeEfFgGcrs%]" contained containedin=pythonString,pythonRawString
    syn match pythonStrFormatting	"%[-#0 +]*\%(\*\|\d\+\)\=\%(\.\%(\*\|\d\+\)\)\=[hlL]\=[diouxXeEfFgGcrs%]" contained containedin=pythonString,pythonRawString
  endif
endif

if s:Enabled("g:python_highlight_string_format")
  " str.format syntax
  if s:Python2Syntax()
    syn match pythonStrFormat "{{\|}}" contained containedin=pythonString,pythonUniString,pythonUniRawString,pythonRawString
    syn match pythonStrFormat	"{\%(\%([^[:cntrl:][:space:][:punct:][:digit:]]\|_\)\%([^[:cntrl:][:punct:][:space:]]\|_\)*\|\d\+\)\=\%(\.\%([^[:cntrl:][:space:][:punct:][:digit:]]\|_\)\%([^[:cntrl:][:punct:][:space:]]\|_\)*\|\[\%(\d\+\|[^!:\}]\+\)\]\)*\%(![rsa]\)\=\%(:\%({\%(\%([^[:cntrl:][:space:][:punct:][:digit:]]\|_\)\%([^[:cntrl:][:punct:][:space:]]\|_\)*\|\d\+\)}\|\%([^}]\=[<>=^]\)\=[ +-]\=#\=0\=\d*,\=\%(\.\d\+\)\=[bcdeEfFgGnosxX%]\=\)\=\)\=}" contained containedin=pythonString,pythonUniString,pythonUniRawString,pythonRawString
  else
    syn match pythonStrFormat "{{\|}}" contained containedin=pythonString,pythonRawString
    syn match pythonStrFormat	"{\%(\%([^[:cntrl:][:space:][:punct:][:digit:]]\|_\)\%([^[:cntrl:][:punct:][:space:]]\|_\)*\|\d\+\)\=\%(\.\%([^[:cntrl:][:space:][:punct:][:digit:]]\|_\)\%([^[:cntrl:][:punct:][:space:]]\|_\)*\|\[\%(\d\+\|[^!:\}]\+\)\]\)*\%(![rsa]\)\=\%(:\%({\%(\%([^[:cntrl:][:space:][:punct:][:digit:]]\|_\)\%([^[:cntrl:][:punct:][:space:]]\|_\)*\|\d\+\)}\|\%([^}]\=[<>=^]\)\=[ +-]\=#\=0\=\d*,\=\%(\.\d\+\)\=[bcdeEfFgGnosxX%]\=\)\=\)\=}" contained containedin=pythonString,pythonRawString
  endif
endif

if s:Enabled("g:python_highlight_string_templates")
  " string.Template format
  if s:Python2Syntax()
    syn match pythonStrTemplate	"\$\$" contained containedin=pythonString,pythonUniString,pythonUniRawString,pythonRawString
    syn match pythonStrTemplate	"\${[a-zA-Z_][a-zA-Z0-9_]*}" contained containedin=pythonString,pythonUniString,pythonUniRawString,pythonRawString
    syn match pythonStrTemplate	"\$[a-zA-Z_][a-zA-Z0-9_]*" contained containedin=pythonString,pythonUniString,pythonUniRawString,pythonRawString
  else
    syn match pythonStrTemplate	"\$\$" contained containedin=pythonString,pythonRawString
    syn match pythonStrTemplate	"\${[a-zA-Z_][a-zA-Z0-9_]*}" contained containedin=pythonString,pythonRawString
    syn match pythonStrTemplate	"\$[a-zA-Z_][a-zA-Z0-9_]*" contained containedin=pythonString,pythonRawString
  endif
endif

if s:Enabled("g:python_highlight_doctests")
  " DocTests
  syn region pythonDocTest	start="^\s*>>>" end=+'''+he=s-1 end="^\s*$" contained
  syn region pythonDocTest2	start="^\s*>>>" end=+"""+he=s-1 end="^\s*$" contained
endif

"
" Numbers (ints, longs, floats, complex)
"

if s:Python2Syntax()
  syn match   pythonHexError	"\<0[xX]\x*[g-zG-Z]\+\x*[lL]\=\>" display
  syn match   pythonOctError	"\<0[oO]\=\o*\D\+\d*[lL]\=\>" display
  syn match   pythonBinError	"\<0[bB][01]*\D\+\d*[lL]\=\>" display

  syn match   pythonHexNumber	"\<0[xX]\x\+[lL]\=\>" display
  syn match   pythonOctNumber "\<0[oO]\o\+[lL]\=\>" display
  syn match   pythonBinNumber "\<0[bB][01]\+[lL]\=\>" display

  syn match   pythonNumberError	"\<\d\+\D[lL]\=\>" display
  syn match   pythonNumber	"\<\d[lL]\=\>" display
  syn match   pythonNumber	"\<[0-9]\d\+[lL]\=\>" display
  syn match   pythonNumber	"\<\d\+[lLjJ]\>" display

  syn match   pythonOctError	"\<0[oO]\=\o*[8-9]\d*[lL]\=\>" display
  syn match   pythonBinError	"\<0[bB][01]*[2-9]\d*[lL]\=\>" display
else
  syn match   pythonHexError	"\<0[xX]\x*[g-zG-Z]\x*\>" display
  syn match   pythonOctError	"\<0[oO]\=\o*\D\+\d*\>" display
  syn match   pythonBinError	"\<0[bB][01]*\D\+\d*\>" display

  syn match   pythonHexNumber	"\<0[xX]\x\+\>" display
  syn match   pythonOctNumber "\<0[oO]\o\+\>" display
  syn match   pythonBinNumber "\<0[bB][01]\+\>" display

  syn match   pythonNumberError	"\<\d\+\D\>" display
  syn match   pythonNumberError	"\<0\d\+\>" display
  syn match   pythonNumber	"\<\d\>" display
  syn match   pythonNumber	"\<[1-9]\d\+\>" display
  syn match   pythonNumber	"\<\d\+[jJ]\>" display

  syn match   pythonOctError	"\<0[oO]\=\o*[8-9]\d*\>" display
  syn match   pythonBinError	"\<0[bB][01]*[2-9]\d*\>" display
endif

syn match   pythonFloat		"\.\d\+\%([eE][+-]\=\d\+\)\=[jJ]\=\>" display
syn match   pythonFloat		"\<\d\+[eE][+-]\=\d\+[jJ]\=\>" display
syn match   pythonFloat		"\<\d\+\.\d*\%([eE][+-]\=\d\+\)\=[jJ]\=" display

"
" Builtin objects and types
"

if s:Enabled("g:python_highlight_builtin_objs")
  if s:Python2Syntax()
    syn keyword pythonBuiltinObj	None
    syn keyword pythonBoolean		True False
  endif
  syn keyword pythonBuiltinObj	Ellipsis NotImplemented
  syn keyword pythonBuiltinObj	__debug__ __doc__ __file__ __name__ __package__ __spec__
endif

"
" Builtin functions
"

if s:Enabled("g:python_highlight_builtin_funcs")
  if s:Python2Syntax()
    syn keyword pythonBuiltinFunc	apply basestring buffer callable coerce
                \ execfile file help intern long raw_input
                \ reduce reload unichr unicode xrange
                \ contained containedin=pythonBuiltinIsolator
    if s:Enabled("g:python_print_as_function")
      syn keyword pythonBuiltinFunc	print
                  \ contained containedin=pythonBuiltinIsolator
    endif
  else
    syn keyword pythonBuiltinFunc	ascii exec memoryview print
                \ contained containedin=pythonBuiltinIsolator
  endif
  syn keyword pythonBuiltinFunc	__import__ abs all any
              \	bin bool bytearray bytes
              \	chr classmethod cmp compile complex
              \	delattr dict dir divmod enumerate eval
              \	filter float format frozenset getattr
              \	globals hasattr hash hex id
              \	input int isinstance
              \	issubclass iter len list locals map max
              \	min next object oct open ord
              \	pow property range
              \	repr reversed round set setattr
              \	slice sorted staticmethod str sum super tuple
              \	type vars zip
              \ contained containedin=pythonBuiltinIsolator
endif

" Cython: added (see Compiler/Parsing.py)
syn keyword pythonBuiltinFunc NULL sizeof
syn keyword cythonType void bint char short int long size_t ssize_t ptrdiff_t
            \ unsigned signed Py_hash_t Py_ssize_t Py_UNICODE Py_UCS4
            \ float double
" Cython: define property statement here
syn match pythonStatement "\v<property>" nextgroup=pythonFunction skipwhite
syn match pythonFunction "\%(property\s*\)\@<=\h\w*" contained

"
" Builtin exceptions and warnings
"

if s:Enabled("g:python_highlight_exceptions")
  if s:Python2Syntax()
    syn keyword pythonExClass	StandardError contained containedin=pythonBuiltinIsolator
  else
    syn keyword pythonExClass	BlockingIOError ChildProcessError
                \ ConnectionError BrokenPipeError
                \ ConnectionAbortedError ConnectionRefusedError
                \ ConnectionResetError FileExistsError
                \ FileNotFoundError InterruptedError
                \ IsADirectoryError NotADirectoryError
                \ PermissionError ProcessLookupError TimeoutError
                \ contained containedin=pythonBuiltinIsolator
    syn keyword pythonExClass	ResourceWarning contained containedin=pythonBuiltinIsolator
  endif
  syn keyword pythonExClass	BaseException
              \	Exception ArithmeticError
              \	LookupError EnvironmentError
              \ AssertionError AttributeError BufferError EOFError
              \	FloatingPointError GeneratorExit IOError
              \	ImportError IndexError KeyError
              \	KeyboardInterrupt MemoryError NameError
              \	NotImplementedError OSError OverflowError
              \	ReferenceError RuntimeError StopIteration
              \	SyntaxError IndentationError TabError
              \	SystemError SystemExit TypeError
              \	UnboundLocalError UnicodeError
              \	UnicodeEncodeError UnicodeDecodeError
              \	UnicodeTranslateError ValueError VMSError
              \	WindowsError ZeroDivisionError
              \ contained containedin=pythonBuiltinIsolator

    syn keyword pythonExClass	Warning UserWarning BytesWarning DeprecationWarning
              \	PendingDepricationWarning SyntaxWarning
              \	RuntimeWarning FutureWarning
              \	ImportWarning UnicodeWarning
              \ contained containedin=pythonBuiltinIsolator
end

if s:Enabled("g:python_slow_sync")
  syn sync minlines=2000
else
  " This is fast but code inside triple quoted strings screws it up. It
  " is impossible to fix because the only way to know if you are inside a
  " triple quoted string is to start from the beginning of the file.
  syn sync match pythonSync grouphere NONE "):$"
  syn sync maxlines=200
endif

if version >= 508 || !exists("did_python_syn_inits")
  if version <= 508
    let did_python_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink pythonStatement        Statement
  HiLink pythonImport           Include
  HiLink pythonFunction         Function
  HiLink cythonType             Type
  HiLink pythonConditional      Conditional
  HiLink pythonRepeat           Repeat
  HiLink pythonException        Exception
  HiLink pythonOperator         Operator

  HiLink pythonDecorator        Define
  HiLink pythonDottedName       Function
  HiLink pythonDot              Normal

  HiLink pythonComment          Comment
  if !s:Enabled("g:python_highlight_file_headers_as_comments")
    HiLink pythonCoding           Special
    HiLink pythonRun              Special
    HiLink pythonDirective        Special
  endif
  HiLink pythonTodo             Todo

  HiLink pythonError            Error
  HiLink pythonIndentError      Error
  HiLink pythonSpaceError       Error

  HiLink pythonString           String
  HiLink pythonRawString        String

  HiLink pythonUniEscape        Special
  HiLink pythonUniEscapeError   Error

  if s:Python2Syntax()
    HiLink pythonUniString          String
    HiLink pythonUniRawString       String
    HiLink pythonUniRawEscape       Special
    HiLink pythonUniRawEscapeError  Error
  else
    HiLink pythonBytes              String
    HiLink pythonRawBytes           String
    HiLink pythonBytesContent       String
    HiLink pythonBytesError         Error
    HiLink pythonBytesEscape        Special
    HiLink pythonBytesEscapeError   Error
  endif

  HiLink pythonStrFormatting    Special
  HiLink pythonStrFormat        Special
  HiLink pythonStrTemplate      Special

  HiLink pythonDocTest          Special
  HiLink pythonDocTest2         Special

  HiLink pythonNumber           Number
  HiLink pythonHexNumber        Number
  HiLink pythonOctNumber        Number
  HiLink pythonBinNumber        Number
  HiLink pythonFloat            Float
  HiLink pythonNumberError      Error
  HiLink pythonOctError         Error
  HiLink pythonHexError         Error
  HiLink pythonBinError         Error

  HiLink pythonBoolean          Boolean

  HiLink pythonBuiltinObj       Structure
  HiLink pythonBuiltinFunc      Function

  HiLink pythonExClass          Structure
  HiLink pythonClassVar         Identifier

  delcommand HiLink
endif

let b:current_syntax = "cython"
