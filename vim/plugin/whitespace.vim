" Remove trailing spaces
function! <SID>StripTrailingWhitespaces()
	if exists('b:noStripWhitespace')
        return
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

" Remove empty line at the end of page
function! <SID>TrimEndLines()
	let save_cursor = getpos(".")
	:silent! %s#\($\n\s*\)\+\%$##
	call setpos('.', save_cursor)
endfunction

" Auto remove when saving
augroup Clean
	autocmd!
	autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()
	autocmd BufWritePre * :call <SID>TrimEndLines()
augroup END

augroup Whitespace
	autocmd FileType mail,markdown let b:noStripWhitespace=1
augroup END
