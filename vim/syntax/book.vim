" Created:  Tue 13 Jan 2015
" Modified: Wed 15 Apr 2015
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
syn match faintwords  "Selah\.\?"

syn region quoted    start=+\v"+ end=+\v."+
			\ contains=verseNum,chapterNum,nestquote,lordnames,appostrophe
syn region nestquote start="\v(^|\"| |\t)\zs'" end="\v'($|\s|[\"?,-;!])@="
			\ contains=verseNum,chapterNum,lordnames,appostrophe contained
syn match number     "\v\d*,*\d"

syn match hashStart  "\v^#+"
syn match chapter    "\v(^# *)@<=.*$"
syn match title      "\v(^## *)@<=.*$"
syn match booktitle  "\v(^### *)@<=.*$"
syn match psalmnum   "\v^ {5}PSALM\s+\d+"
syn match chapterNum "\v^\[[ 0-9]+\] "
syn match verseNum   "\v(^\[[ 0-9]+\] +)@8<=[0-9]+"

if has('conceal')
	setlocal conceallevel=2
	setlocal concealcursor=nc
	syn match appostrophe "\vs'\zss" contained conceal
endif

hi def link lordnames Todo
hi def link faintwords Comment
hi def link quoted    String
hi def link nestquote Boolean
hi def link number    Number

hi def link hashStart  Comment
hi def link booktitle  Function
hi def link title      Function
hi def link chapter    Constant
hi def link psalmnum   Constant
hi def link chapterNum Type
hi def link verseNum   Identifier
