" Created:  Wed 16 Apr 2014
" Modified: Mon 12 Jan 2015
" Author:   Josh Wainwright
" Filename: whitespace.vim
"
" Remove trailing spaces

function! s:stripTrailing(force)
	if !a:force
		if exists('g:noStripWhitespace')
			return
		endif
	endif

	" Preparation: save last search, and cursor position.
	let _s=@/
	let l = line(".")
	let c = col(".")
	" Do the business:
	%s/\s\+$//e
	%s/\n\{3,}/\r\r/e
	" Clean up: restore previous search history, and cursor position
	let @/=_s
	call cursor(l, c)
endfunction

" Remove empty line at the end of file
function! TrimEndLines()
	if exists('g:noStripWhitespace')
		return
	endif

	let save_cursor = getpos(".")
	:silent! %s#\($\n\s*\)\+\%$##
	call setpos('.', save_cursor)
endfunction

command! -nargs=0 -bang StripTrailing :call s:stripTrailing('<bang>' == '!')
command! TrimEndLines :call TrimEndLines()

" Auto remove when saving
augroup Clean
	autocmd!
	autocmd BufWritePre * StripTrailing
	autocmd BufWritePre * TrimEndLines
augroup END

augroup Whitespace
	autocmd FileType *vmail*,mail,markdown let b:noStripWhitespace=1
augroup END
