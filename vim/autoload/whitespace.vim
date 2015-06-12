" Created:  Wed 16 Apr 2014
" Modified: Wed 10 Jun 2015
" Author:   Josh Wainwright
" Filename: whitespace.vim
"
" Remove trailing spaces
function! whitespace#StripTrailing(firstl, lastl) range
	if &ft == 'markdown' || &ft == 'dat'
		return
	endif
	let save_cursor = getpos(".")
	let old_query = getreg("/")
	execute printf('%d,%ds/\s\+$//e', a:firstl, a:lastl)
	execute printf('%d,%ds/\n\{3,}/\r\r/e', a:firstl, a:lastl-1)
	call whitespace#TrimEndLines()
	call setpos('.', save_cursor)
	call setreg('/', old_query)
endfunction

" Remove empty line at the end of file
function! whitespace#TrimEndLines()
	let w = winsaveview()
	silent! %s#\($\n\s*\)\+\%$##
	call winrestview(w)
endfunction
