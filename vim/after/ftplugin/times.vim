" Created:  Sat 24 Jan 2015
" Modified: Tue 16 Jun 2015
" Author:   Josh Wainwright
" Filename: times.vim

function! Log_work_times()
	let l:today = strftime("%Y%m%d")
	let l:yesterday = strftime('%Y%m%d', localtime()-86400)
	let l:last = split(getline('$'), ",")[0]
	if l:today == l:last
		let l:newline = getline('$') . ", " . strftime("%H%M%S")
		call setline('$', l:newline)
	else
		while l:yesterday != l:last
			let l:last = l:last + 1
			let l:newline = l:last . ", w     , w     , w     , w     , 1"
			call append(line('$'), l:newline)
		endwhile

		let l:newline = strftime("%Y%m%d") . ", " . strftime("%H%M%S")
		echo l:newline
		call append(line('$'), l:newline)
	endif
	call cursor('$', 1)
endfunction

nnoremap <buffer> <cr> :<c-u>call Log_work_times()<cr>

augroup log_work_times
	au!
	au BufReadPost,BufEnter times.txt call Log_work_times()
augroup END
