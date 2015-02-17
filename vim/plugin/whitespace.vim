" Created:  Wed 16 Apr 2014
" Modified: Tue 17 Feb 2015
" Author:   Josh Wainwright
" Filename: whitespace.vim
"
" Remove trailing spaces
function! s:stripTrailing(firstl, lastl) range
	" Preparation: save last search, and cursor position.
	let _s=@/
	let w = winsaveview()
	" Do the business:
	exe a:firstl.",".a:lastl."s/\\s\\+$//e"
	exe a:firstl.",".(a:lastl-1)."s/\\n\\{3,}/\\r\\r/e"
	TrimEndLines
	" Clean up: restore previous search history, and cursor position
	let @/=_s
	call winrestview(w)
endfunction

" Remove empty line at the end of file
function! TrimEndLines()
	let w = winsaveview()
	silent! %s#\($\n\s*\)\+\%$##
	call winrestview(w)
endfunction

command! -range=% -nargs=0 StripTrailing :call s:stripTrailing(<line1>,<line2>)
command! TrimEndLines :call TrimEndLines()

" Auto remove when saving
if $USERNAME != "JoshWainwright"
	augroup Clean
		autocmd!
		autocmd BufWritePre * StripTrailing
		autocmd BufWritePre * TrimEndLines
	augroup END
endif
