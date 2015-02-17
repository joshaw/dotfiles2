" Created:  Wed 16 Apr 2014
" Modified: Mon 16 Feb 2015
" Author:   Josh Wainwright
" Filename: whitespace.vim
"
" Remove trailing spaces
function! s:stripTrailing() range
	" Preparation: save last search, and cursor position.
	let _s=@/
	let w = winsaveview()
	" Do the business:
	exe a:firstline.",".a:lastline."s/\\s\\+$//e"
	exe a:firstline.",".(a:lastline-1)."s/\\n\\{3,}/\\r\\r/e"
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

command! -range=% -nargs=0 StripTrailing :<line1>,<line2>call s:stripTrailing()
command! TrimEndLines :call TrimEndLines()

" Auto remove when saving
if $HOSTNAME != "Newbury11"
	augroup Clean
		autocmd!
		autocmd BufWritePre * StripTrailing
		autocmd BufWritePre * TrimEndLines
	augroup END
endif
