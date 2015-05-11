" Created:  Thu 15 Jan 2015
" Modified: Mon 11 May 2015
" Author:   Josh Wainwright
" Filename: biblereading.vim

if exists("b:current_syntax")
	finish
endif

let b:current_syntax = "biblereading"

syn match bibread_emptycheckbox "\v\[ \]"
syn match bibread_fullcheckbox  "\v\[x\].*$"
syn match bibread_other         "\v^[A-Z]+$"
syn match bibread_dayofmonth    "\v(^\[ \] +)@<=\d+\."
syn match bibread_yearnum       "\v^YEAR [A-Z]+"

hi def link bibread_emptycheckbox Number
hi def link bibread_fullcheckbox  Comment
hi def link bibread_other         Identifier
hi def link bibread_dayofmonth    Type
hi def link bibread_yearnum       PreProc
