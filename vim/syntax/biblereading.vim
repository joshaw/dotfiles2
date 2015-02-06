" Created:  Thu 15 Jan 2015
" Modified: Fri 06 Feb 2015
" Author:   Josh Wainwright
" Filename: biblereading.vim

if exists("b:current_syntax")
	finish
endif

let b:current_syntax = "biblereading"

syn match emptycheckbox "\v\[ \]"
syn match fullcheckbox  "\v\[x\].*$"
syn match other         "\v^[A-Z]+$"
syn match dayofmonth    "\v(^\[ \] +)@<=\d+\."
syn match yearnum       "\v^YEAR [A-Z]+"

hi def link emptycheckbox Number
hi def link fullcheckbox  Comment
hi def link other         Identifier
hi def link dayofmonth    Type
hi def link yearnum       PreProc
