" Created:  Sat 01 Aug 2015
" Modified: Sat 01 Aug 2015
" Author:   Josh Wainwright
" Filename: sysearch.vim

if version < 600
   syntax clear
elseif exists("b:current_syntax")
   finish
endif

" we define it here so that included files can test for it
if !exists("main_syntax")
   let main_syntax='sysearch'
endif

syn match SysearchPath "\S.*$"

syn match SysearchTypeGroup "^\s*\d\+\s\+.*" contains=SysearchType,SysearchPath
syn match SysearchType "^\s*\d\+\s" contained

syn match SysearchComment "^\s\+0.*"

hi def link SysearchType Number
hi def link SysearchPath String

hi def link SysearchComment Comment
