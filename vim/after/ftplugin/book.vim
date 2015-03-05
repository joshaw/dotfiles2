" Created:  Fri 06 Feb 2015
" Modified: Mon 02 Mar 2015
" Author:   Josh Wainwright
" Filename: book.vim

let b:bible = 0
if getline(1) =~ "###"
	let b:bible = 1
endif
setlocal indentexpr=BibleIndent()

function! BibleIndent()
	if ! b:bible
		return
	endif
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
setlocal tabstop=4
setlocal highlight-=@:NonText
setlocal highlight+=@:Normal
setlocal nolist
setlocal colorcolumn=0
setlocal nocursorline
setlocal textwidth=65

if executable('par')
	setlocal formatprg=par\ -w65j
endif
