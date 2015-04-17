" Created:  Tue 13 Jan 2015
" Modified: Fri 17 Apr 2015
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

syn region quoted    start=+\v"+ end=+\v."+ contains=verseNum,nestquote,lordnames,appostrophe,number
syn region nestquote start=+\v(^|"| |\t)\zs'+ end=+\v'($|\s|["?,-;!])@=+ contains=verseNum,lordnames,appostrophe,number,nestnestquote contained
syn region nestnestquote start=+\v"+ end=+\v."+ contains=verseNum,lordnames,appostrophe,number contained

" syn match number     "\v\d*,*\d"

syn match hashStart  "\v^#+"
syn match booktitle  "\v^# .*$" contains=hashStart
syn match title      "\v^## .*$" contains=hashStart
syn match chapter    "\v^### .*$" contains=hashStart
syn match psalmnum   "\v^ {5}PSALM\s+\d+"
syn match verseNum   "\v^\[[ 0-9]+\] +[0-9]+" contains=chapterNum
syn match chapterNum "\v^\[[ 0-9]+\] " contained

if has('conceal')
	setlocal conceallevel=2
	setlocal concealcursor=nc
	syn match appostrophe "\vs'\zss" contained conceal
endif

hi def link lordnames     Todo
hi def link faintwords    Comment
hi def link quoted        String
hi def link nestquote     Boolean
hi def link nestnestquote Type
hi def link number        Number

hi def link hashStart  Comment
hi def link booktitle  Function
hi def link title      Function
hi def link chapter    Constant
hi def link psalmnum   Constant
hi def link chapterNum Type
hi def link verseNum   Identifier
