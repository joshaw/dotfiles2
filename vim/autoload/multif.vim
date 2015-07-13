" Created:  Fri 10 Jul 2015
" Modified: Mon 13 Jul 2015
" Author:   Josh Wainwright
" Filename: multi-f.vim

function! multif#multif(char, direction, till)
	let c = nr2char(a:char)
	let g:fchar = a:char
	let flags = 's'
	let fin = ''
	if a:direction == 1
		let stopl = line('w$')
		if a:till == 1
			let fin = 'h'
		endif
	else
		let flags .= 'b'
		let stopl = line('w0')
		if a:till == 1
			let fin = 'l'
		endif
	endif
	call search('\V'.c, flags, stopl, 5)
	silent! exe "normal!" fin
endfunction
