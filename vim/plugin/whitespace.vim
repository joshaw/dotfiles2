" Remove trailing spaces

function! StripTrailingWhitespaces()
	echo "Stripping"
	if exists('g:noStripWhitespace')
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
function! TrimEndLines()
	if exists('g:noStripWhitespace')
        return
    endif

	let save_cursor = getpos(".")
	:silent! %s#\($\n\s*\)\+\%$##
	call setpos('.', save_cursor)
endfunction

command StripTrailingWhitespaces :call StripTrailingWhitespaces()
command TrimEndLines :call TrimEndLines()

" Auto remove when saving
augroup Clean
	autocmd!
	autocmd BufWritePre * :call StripTrailingWhitespaces()
	autocmd BufWritePre * :call TrimEndLines()
augroup END

augroup Whitespace
	autocmd FileType *vmail*,mail,markdown let b:noStripWhitespace=1
augroup END
