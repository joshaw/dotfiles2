" Created:  Thu 17 Apr 2014
" Modified: Wed 08 Jul 2015
" Author:   Josh Wainwright
" Filename: timestamp.vim
"

" Update timestamp if found in the first few lines of a file.
" Triggered on file read but not set as modified.
function! timestamp#Timestamp()
	if &readonly
		return
	endif
	let l:winview = winsaveview()

	let pat = '\v\C%(Modified\s*:\s*)\zs%(.*20\d{2}|TIMESTAMP)\ze|Created\s*:\s*\zsTIMESTAMP\ze$'
	let rep = strftime("%a %d %b %Y")

	if line('$') > 2 * &modelines
		call s:subst(1, &modelines, pat, rep)
		call s:subst(line('$')-&modelines, line('$'), pat, rep)
	else
		call s:subst(1, line('$'), pat, rep)
	endif

	setlocal nomodified
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
				keepjumps call setline(lineno, newline)
			endif
		endif
		let lineno = lineno + 1
	endwhile
endfunction
