" Created:  Fri 31 Jul 2015
" Modified: Fri 31 Jul 2015
" Author:   Josh Wainwright
" Filename: tcf.vim

if version < 600
   syntax clear
elseif exists("b:current_syntax")
   finish
endif

" we define it here so that included files can test for it
if !exists("main_syntax")
   let main_syntax='tcf'
endif

syn case ignore

syn match TCFpath    "[<>|?*":= ]\zs\f\{-}[\\/]\f\+$"
syn match TCFpath    "\f*\.\(\f\{3}\|\f\)$"
syn match TCFsection "^\s*#\s\?\(Begin\|End\).*$"
syn match TCFvarname "^\s*[^=]\+\ze\s\+="
syn match TCFvardef  "<[0-9A-Za-z ]\+>"
syn match TCFvarop   "=" containedin=TCFvarname
syn match TCFmacro   "\(\$(\w\+)\|\$\$\a\|\$\w\+\$\)"
syn keyword TCFbool  t f true false
syn match TCFdate    "\u\l\l \d\{1,2} \d\{4} \d\{2}:\d\{2}:\d\{2}"
syn match TCFnumber  "\s\zs\d\+\ze\(\s\|$\)"
syn match TCFhexnum  "0x\x\+"
syn region TCFstring start=+"+ end=+"+

syn match TCFcomment "^$ .*$"

syntax include @C syntax/c.vim
syntax region cSnip matchgroup=TCFsection start="\s*# Begin \z(\(Startup \|Cleanup \)\?Code\|\(Global \)\?Declarations\|Overloading\)" end="\s*# End \z1" contains=@C

syn region TCFnormal matchgroup=TCFsection start="\s*# Begin Text" end="\s*# End Text"

hi link TCFpath    Special
hi link TCFsection Repeat
hi link TCFvarname Function
hi link TCFvarop   Operator
hi link TCFvardef  Delimiter
hi link TCFmacro   Macro
hi link TCFbool    Boolean
hi link TCFdate    Number
hi link TCFnumber  Number
hi link TCFhexnum  Number
hi link TCFstring  String

hi link TCFcomment Comment

hi link TCFnormal  Normal
