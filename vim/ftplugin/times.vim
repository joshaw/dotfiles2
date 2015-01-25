" Created:  Sat 24 Jan 2015
" Modified: Sat 24 Jan 2015
" Author:   Josh Wainwright
" Filename: times.vim

function! Log_work_times()
	let l:openday = strftime("%Y%m%d")
	let l:lastloggedday = split(getline('$'), ",")[0]
	if l:openday == l:lastloggedday
		let l:newline = getline('$') . ", " . strftime("%H%M%S")
		call setline('$', l:newline)
	else
		let l:newline = strftime("%Y%m%d") . ", " . strftime("%H%M%S")
		call append(line('$'), l:newline)
	endif
	write
endfunction

nnoremap <buffer> <cr> :<c-u>call Log_work_times()<cr>

augroup log_work_times
	au!
	au BufReadPost times.txt call Log_work_times()
augroup END
