" Created:  Fri 06 Feb 2015
" Modified: Fri 13 Mar 2015
" Author:   Josh Wainwright
" Filename: book.vim

let b:bible = 0
if getline(1) =~ "###"
	let b:bible = 1
endif
setlocal indentexpr=BookIndent()

function! BookIndent()
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
setlocal colorcolumn=+1
setlocal nocursorline
setlocal textwidth=65
setlocal formatoptions+=a
setlocal scrolloff=999

if executable('par')
	setlocal formatprg=par\ -w65j
endif
