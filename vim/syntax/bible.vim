" Created:  Tue 13 Jan 2015
" Modified: Mon 19 Jan 2015
" Author:   Josh Wainwright
" Filename: bible.vim

if exists("b:current_syntax")
	finish
endif

let b:current_syntax = "bible"

syn sync clear
syn sync fromstart

syn keyword lordnames LORD
syn match lordnames   "I AM"
syn match faintwords  "Selah\."

syn region quoted    start=+\v"+ end=+\v"+
			\ contains=verseNum,chapterNum,nestquote,lordnames
syn region nestquote start="\v(\"| )'" end="\v'(\s|$|[\"?,-;!])@="
			\ contains=verseNum,chapterNum,lordnames contained
syn match number     "\v\d*,*\d"

syn match hashStart  "\v^#+"
syn match bookname   "\v(^# )@<=([1-3][snrt][tdh] )*[A-Z][A-Za-z: ]+"
syn match testament  "\v(^# )@<=.{-}TESTAMENT.*$"
syn match psalmnum   "\v^ {5}PSALM\s+\d+"
syn match chapterNum "\v^\[[ 0-9]+\] "
syn match verseNum   "\v(^\[[ 0-9]+\] +)@8<=[0-9]+"

hi def link lordnames Todo
hi def link faintwords Comment
hi def link quoted    String
hi def link nestquote Boolean
hi def link number    Number

hi def link hashStart  Comment
hi def link testament  PreProc
hi def link bookname   Constant
hi def link psalmnum   Constant
hi def link chapterNum Type
hi def link verseNum   Identifier

setlocal indentexpr=BibleIndent()

function! BibleIndent()
	let line = getline(v:lnum)
	let firstchar = line[:0]
	let prevline = getline(v:lnum - 1)

	if firstchar == "[" || firstchar == "#"
		return 0
	else
		let indprev = indent(v:lnum - 1)
		if indprev == 10 || prevline =~ '\v^\[.{3}\]'
			return 10
		elseif  line =~ '\v^\s*PSALM\s+\d+'
			return 5
		else
			return 8
		endif
	endif
endfunction

let s:showbreakstr = '\ \ \ \ \ \ \ \ '
exe 'setlocal showbreak=' . s:showbreakstr
setlocal highlight-=@:NonText
setlocal highlight+=@:Normal
setlocal nonumber
setlocal norelativenumber
setlocal nolist
setlocal colorcolumn=0
