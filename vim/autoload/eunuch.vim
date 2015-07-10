" Created:  Fri 12 Jun 2015
" Modified: Thu 09 Jul 2015
" Author:   Josh Wainwright
" Filename: eunuch.vim

function! s:separator()
	return !exists('+shellslash') || &shellslash ? '/' : '\\'
endfunction

function! eunuch#RemoveFile(bang, args)
	let s:file = fnamemodify(bufname(a:args),':p')
	execute 'bdelete'.a:bang
	if !bufloaded(s:file) && delete(s:file)
		echoerr 'Failed to delete "'.s:file.'"'
	endif
	unlet s:file
endfunction

function! eunuch#MoveFile(bang, args)
	let s:src = expand('%:p')
	if a:args == ''
		let s:dst = input('New file name: ', expand('%:p'), 'file')
	else
		let s:dst = expand(a:args)
	endif
	if isdirectory(s:dst) || s:dst[-1:-1] =~# '[\\/]'
		let s:dst .= (s:dst[-1:-1] =~# '[\\/]' ? '' : s:separator()) .
		fnamemodify(s:src, ':t')
	endif
	if !isdirectory(fnamemodify(s:dst, ':h'))
		call mkdir(fnamemodify(s:dst, ':h'), 'p')
	endif
	let s:dst = substitute(simplify(s:dst), '^\.\'.s:separator(), '', '')
	if !a:bang && filereadable(s:dst)
		exe 'keepalt saveas '.fnameescape(s:dst)
	elseif rename(s:src, s:dst)
		echoerr 'Failed to rename "'.s:src.'" to "'.s:dst.'"'
	else
		setlocal modified
		exe 'keepalt saveas! '.fnameescape(s:dst)
		if s:src !=# expand('%:p')
			execute 'bwipe '.fnameescape(s:src)
		endif
	endif
	unlet s:src
	unlet s:dst
endfunction

function! eunuch#Grep(bang,args,prg) abort
	let grepprg = &l:grepprg
	let grepformat = &l:grepformat
	let shellpipe = &shellpipe
	try
		let &l:grepprg = a:prg
		setlocal grepformat=%f
		if &shellpipe ==# '2>&1| tee' || &shellpipe ==# '|& tee'
			let &shellpipe = "| tee"
		endif
		execute 'grep! '.a:args
		if empty(a:bang) && !empty(getqflist())
			return 'cfirst'
		else
			return ''
		endif
	finally
		let &l:grepprg = grepprg
		let &l:grepformat = grepformat
		let &shellpipe = shellpipe
	endtry
endfunction

function! eunuch#Mkdir(bang, args)
	call mkdir(empty(a:args) ? expand('%:h') : a:args, empty(a:bang) ? '' : 'p')
	if empty(a:args)
		silent keepalt execute 'file' expand('%')
	endif
endfunction

function! eunuch#MaxLine()
		let maxcol = 0
		let lnum = 1
		while lnum <= line("$")
				call cursor(lnum, 0)
				if col("$") > maxcol
						let maxcol = col("$")
						let maxline = lnum
				endif
				let lnum += 1
		endwhile
		exec maxline
		echo "Line" maxline "has" maxcol - 1 "characters"
endfunction
