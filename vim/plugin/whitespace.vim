" Created:  Wed 16 Apr 2014
" Modified: Wed 18 Feb 2015
" Author:   Josh Wainwright
" Filename: whitespace.vim
"
" Remove trailing spaces
function! s:stripTrailing(firstl, lastl) range
	let save_cursor = getpos(".")
	let old_query = getreg("/")
	execute printf('%d,%ds/\s\+$//e', a:firstl, a:lastl)
	execute printf('%d,%ds/\n\{3,}/\r\r/e', a:firstl, a:lastl-1)
	call s:trimEndLines()
	call setpos('.', save_cursor)
	call setreg('/', old_query)
endfunction

" Remove empty line at the end of file
function! s:trimEndLines()
	let w = winsaveview()
	silent! %s#\($\n\s*\)\+\%$##
	call winrestview(w)
endfunction

command! -range=% -nargs=0 StripTrailing :call s:stripTrailing(<line1>,<line2>)
command! -nargs=0 TrimEndLines :call s:trimEndLines()

" Auto remove when saving
if $USERNAME != "JoshWainwright"
	augroup Clean
		autocmd!
		autocmd BufWritePre * StripTrailing
		autocmd BufWritePre * TrimEndLines
	augroup END
endif
