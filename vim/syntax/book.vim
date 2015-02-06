" Created:  Tue 13 Jan 2015
" Modified: Fri 06 Feb 2015
" Author:   Josh Wainwright
" Filename: book.vim

if exists("b:current_syntax")
	finish
endif

let b:current_syntax = "book"

syn sync clear
syn sync fromstart

syn keyword lordnames LORD
syn match lordnames   "I AM"
syn match faintwords  "Selah\."

syn region quoted    start=+\v"+ end=+\v."+
			\ contains=verseNum,chapterNum,nestquote,lordnames
syn region nestquote start="\v(^|\"| |\t)\zs'" end="\v'($|\s|[\"?,-;!])@="
			\ contains=verseNum,chapterNum,lordnames contained
syn match number     "\v\d*,*\d"

syn match hashStart  "\v^#+"
syn match chapter    "\v(^# *)@<=[A-Z][A-Za-z].*$"
syn match title      "\v(^## *)@<=[A-Z][A-Za-z].*$"
syn match psalmnum   "\v^ {5}PSALM\s+\d+"
syn match chapterNum "\v^\[[ 0-9]+\] "
syn match verseNum   "\v(^\[[ 0-9]+\] +)@8<=[0-9]+"

hi def link lordnames Todo
hi def link faintwords Comment
hi def link quoted    String
hi def link nestquote Boolean
hi def link number    Number

hi def link hashStart  Comment
hi def link title      Function
hi def link chapter    Constant
hi def link psalmnum   Constant
hi def link chapterNum Type
hi def link verseNum   Identifier
