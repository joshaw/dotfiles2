" Created:  Thu 17 Apr 2014
" Modified: Wed 28 Jan 2015
" Author:   Josh Wainwright
" Filename: timestamp.vim
"
" auto-update last update if there's a update tag
autocmd! BufWritePre * :call Timestamp()

" to update timestamp when saving if its in the first few lines of a file
function! Timestamp()

	let l:winview = winsaveview()

	let pat = '\v\C%(Modified\s*:\s*)\zs%(.*20\d{2}|TIMESTAMP)$|Created\s*:\s*\zsTIMESTAMP\ze$'
	let rep = strftime("%a %d %b %Y")

	if line('$') > 2 * &modelines
		call s:subst(1, &modelines, pat, rep)
		call s:subst(line('$')-&modelines, line('$'), pat, rep)
	else
		call s:subst(1, line('$'), pat, rep)
	endif

	call winrestview(l:winview)

endfunction

function! s:subst(start, end, pat, rep)
	let lineno = a:start
	while lineno <= a:end
		let curline = getline(lineno)
		if match(curline, a:pat) != -1
			let newline = substitute( curline, a:pat, a:rep, '' )
			if( newline != curline )
				" Only substitute if we made a change
				"silent! undojoin
				keepjumps call setline(lineno, newline)
			endif
		endif
		let lineno = lineno + 1
	endwhile
endfunction
