" Created:  Tue 13 Jan 2015
" Modified: Tue 23 Jun 2015
" Author:   Josh Wainwright
" Filename: bible.vim

if exists("b:current_syntax")
	finish
endif

let b:current_syntax = "bible"

syn sync clear
syn sync fromstart

syn keyword biblelordnames LORD
syn match biblelordnames   "I AM"
syn match biblefaintwords  "Selah\.\?"

syn region biblequoted    start=+\v"+ end=+\v."+
			\ contains=bibleverseNum,biblenestquote,biblelordnames,bibleappostrophe,biblenumber
syn region biblenestquote start=+\v(^|"| |\t)\zs'+ end=+\v'($|\s|["?,-;!])@=+
			\ contains=bibleverseNum,biblelordnames,bibleappostrophe,biblenumber,biblenestnestquote contained
syn region biblenestnestquote start=+\v"+ end=+\v."+
			\ contains=bibleverseNum,biblelordnames,bibleappostrophe,biblenumber contained

" syn match number     "\v\d*,*\d"

syn match biblehashStart  "\v^#+"
syn match biblebibletitle  "\v^# .*$" contains=biblehashStart
syn match bibletitle      "\v^## .*$" contains=biblehashStart
syn match biblechapter    "\v^### .*$" contains=biblehashStart
syn match biblepsalmnum   "\v^ {5}PSALM\s+\d+"
syn match bibleverseNum   "\v^\[[ 0-9]+\] +[0-9]+" contains=biblechapterNum
syn match biblechapterNum "\v^\[[ 0-9]+\] " contained

if has('conceal')
	setlocal conceallevel=2
	setlocal concealcursor=nc
	syn match bibleappostrophe "\vs'\zss" contained conceal
endif

hi def link biblelordnames     Todo
hi def link biblefaintwords    Comment
hi def link biblequoted        String
hi def link biblenestquote     Boolean
hi def link biblenestnestquote Type
hi def link biblenumber        Number

hi def link biblehashStart  Comment
hi def link bibletitle      Function
hi def link bibletitle      Function
hi def link biblechapter    Constant
hi def link biblepsalmnum   Constant
hi def link biblechapterNum Type
hi def link bibleverseNum   Identifier
