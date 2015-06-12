" Created:  Thu 04 Jun 2015
" Modified: Fri 05 Jun 2015
" Author:   Josh Wainwright
" Filename: keycount.vim

let g:KeyCountFile = expand('~/Documents/Details/keys/keys.md')

augroup keycount
	au!
	au VimEnter * call s:keycountinit()
	au InsertCharPre * call s:keycountincrement(v:char)
	au VimLeave * call s:keycountwrite()
augroup END

function! s:keycountinit()
	let g:VimKeyCount = 0
	let g:VimKeyCountLetters = {
	            \ 'a':0, 'b':0, 'c':0, 'd':0, 'e':0, 'f':0, 'g':0, 'h':0,
	            \ 'i':0, 'j':0, 'k':0, 'l':0, 'm':0, 'n':0, 'o':0, 'p':0,
	            \ 'q':0, 'r':0, 's':0, 't':0, 'u':0, 'v':0, 'w':0, 'x':0,
	            \ 'y':0, 'z':0,
	            \ '1':0, '2':0, '3':0, '4':0, '5':0, '6':0, '7':0, '8':0,
	            \ '9':0, '0':0, '~tab':0, '~space':0, '~punc':0
	            \ }
endfunction

function! s:keycountwrite()
	if !exists('g:VimKeyCountLetters') || g:VimKeyCount == 0
		return
	endif
	
	let l:today = strftime('%Y%m%d')
	let l:lastline = readfile(g:KeyCountFile)[-1]
	let l:last = split(l:lastline, '|')
	let l:i = 1
	if l:today == l:last[0]
		let l:newnum = l:last[1] + g:VimKeyCount
		let l:newline = l:today . '|' . l:newnum
		for p in sort(items(g:VimKeyCountLetters))
			let l:i += 1
			let l:cnt = l:last[l:i] + p[1]
			let l:newline = l:newline . '|' . l:cnt
		endfor
		call writefile(readfile(g:KeyCountFile)[:-2] + [l:newline], g:KeyCountFile)
	else
		let l:newline = l:today . '|' . g:VimKeyCount
		for p in sort(items(g:VimKeyCountLetters))
			let l:i += 1
			let l:letcnt = p[1]
			let l:newline = l:newline . '|' . l:letcnt
		endfor
		call writefile(readfile(g:KeyCountFile) + [l:newline], g:KeyCountFile)
	endif
	call s:keycountinit()
endfunction

function! s:keycountincrement(char)
	silent! let g:VimKeyCount += 1
	let l:low = tolower(a:char)
	if l:low =~? '\a\|\d'
		silent! let g:VimKeyCountLetters[l:low] += 1
	elseif a:char == ' '
		silent! let g:VimKeyCountLetters['~space'] += 1
	elseif a:char =~? '\t'
		silent! let g:VimKeyCountLetters['~tab'] += 1
	else
		silent! let g:VimKeyCountLetters['~punc'] += 1
	endif
endfunction

function! s:keycountedit()
	exe 'edit ' . g:KeyCountFile
endfunction

function! s:keycountprint()
	let l:totaltmp = split(readfile(g:KeyCountFile)[-1], '|')[1] + g:VimKeyCount

	let l:width = max([strlen(l:totaltmp), 3])
	let l:newline = printf('%' . l:width . 'S', 'tot')
	let l:newline1 = l:totaltmp

	for i in sort(items(g:VimKeyCountLetters))
		let l:width = max([strlen(i[0]), strlen(i[1])])
		let l:newline = l:newline . '|' . printf('%'.l:width.'S', i[0])
		let l:newline1 = l:newline1 . '|' . printf('%'.l:width.'S', i[1])
	endfor

	echo l:newline
	echo l:newline1
endfunction

command! KeyCountPrint :call s:keycountprint()
command! KeyCountEdit :call s:keycountedit()
command! KeyCountWrite :call s:keycountwrite()
