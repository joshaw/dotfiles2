" Created:  Thu 04 Jun 2015
" Modified: Mon 15 Jun 2015
" Author:   Josh Wainwright
" Filename: keycount.vim

let g:KeyCountFile = expand('~/Documents/Details/keys/keys.md')
let g:KeyCountFileTypes = {}
let g:KeyCount = 0
let g:KeyCountLetters = {
			\ 'a':0, 'b':0, 'c':0, 'd':0, 'e':0, 'f':0, 'g':0, 'h':0,
			\ 'i':0, 'j':0, 'k':0, 'l':0, 'm':0, 'n':0, 'o':0, 'p':0,
			\ 'q':0, 'r':0, 's':0, 't':0, 'u':0, 'v':0, 'w':0, 'x':0,
			\ 'y':0, 'z':0,
			\ '1':0, '2':0, '3':0, '4':0, '5':0, '6':0, '7':0, '8':0,
			\ '9':0, '0':0, '~tab':0, '~space':0, '~punc':0 }

augroup keycount
	au!
	au InsertCharPre * call s:keycountincrement(v:char)
	au Filetype * call s:keycountinit()
	au VimLeave * call s:keycountwrite()
augroup END

function! s:keycountinit()
	if &ft != '' && !has_key(g:KeyCountFileTypes, &ft)
		let g:KeyCountFileTypes[&ft] = { 'total': 0,
					\ 'a':0, 'b':0, 'c':0, 'd':0, 'e':0, 'f':0, 'g':0,
					\ 'h':0, 'i':0, 'j':0, 'k':0, 'l':0, 'm':0, 'n':0,
					\ 'o':0, 'p':0, 'q':0, 'r':0, 's':0, 't':0, 'u':0,
					\ 'v':0, 'w':0, 'x':0, 'y':0, 'z':0,
					\ '1':0, '2':0, '3':0, '4':0, '5':0, '6':0, '7':0,
					\ '8':0, '9':0, '0':0, '~tab':0, '~space':0, '~punc':0 }
	endif
endfunction

function! s:keycountwrite()
	if !exists('g:KeyCountLetters') || g:KeyCount == 0
		return
	endif

	let kccontents = KeycountwriteFT()
	
	let l:today = strftime('%Y%m%d')
	let l:last = split(kccontents[-1], '|')
	let l:i = 1
	if l:today == l:last[0]
		let l:newnum = l:last[1] + g:KeyCount
		let l:newline = l:today . '|' . l:newnum
		for p in sort(items(g:KeyCountLetters))
			let l:i += 1
			let l:cnt = l:last[l:i] + p[1]
			let l:newline = l:newline . '|' . l:cnt
		endfor
		let kccontents = kccontents[:-2] + [l:newline]
	else
		let l:newline = l:today . '|' . g:KeyCount
		for p in sort(items(g:KeyCountLetters))
			let l:i += 1
			let l:letcnt = p[1]
			let l:newline = l:newline . '|' . l:letcnt
		endfor
		let kccontents += [l:newline]
	endif
	call writefile(kccontents, g:KeyCountFile)
endfunction

function! KeycountwriteFT()
	let ftline = readfile(g:KeyCountFile)
	if &ft == '' || !has_key(g:KeyCountFileTypes, &ft)
		return ftline
	endif
	for ftype in keys(g:KeyCountFileTypes)
		let index = 10
		while index < len(ftline)
			let line = ftline[index]
			if line =~ ftype . '.*'
				let l:last = split(line, '|')
				let l:newnum = l:last[1] + g:KeyCountFileTypes[&ft]['total']
				call remove(g:KeyCountFileTypes[&ft],  'total')
				let l:newline = ftype . '|' . l:newnum
				" Element 0=ft, 1=total, 2..=letter
				let l:i = 2
				for p in sort(items(g:KeyCountFileTypes[&ft]))
					let l:cnt = l:last[l:i] + p[1]
					let l:newline .= '|' . l:cnt
					let l:i += 1
				endfor
				let ftline[index] = l:newline
				break
			endif

			if line =~# 'Date.*'
				let l:i = 10
				while l:i < len(ftline)
					if ftline[l:i][0:8] ==# 'Filetype '
						let newft = ftype . ' ' . repeat('|0', 40)
						let ftline = insert(ftline, newft, l:i+2)
						let index = l:i
						break
					endif
					let l:i += 1
				endwhile
			endif
			let index += 1
		endwhile
	endfor
	return ftline
endfunction

function! s:keycountincrement(char)
	let g:KeyCount += 1
	silent! let g:KeyCountFileTypes[&ft]['total'] += 1
	let l:low = tolower(a:char)
	if l:low =~? '\a\|\d'
		let g:KeyCountLetters[l:low] += 1
		silent! let g:KeyCountFileTypes[&ft][l:low] += 1
	elseif a:char == ' '
		let g:KeyCountLetters['~space'] += 1
		silent! let g:KeyCountFileTypes[&ft]['~space'] += 1
	elseif a:char =~? '\t'
		let g:KeyCountLetters['~tab'] += 1
		silent! let g:KeyCountFileTypes[&ft]['~tab'] += 1
	else
		let g:KeyCountLetters['~punc'] += 1
		silent! let g:KeyCountFileTypes[&ft]['~punc'] += 1
	endif
endfunction

function! s:keycountedit()
	exe 'edit ' . g:KeyCountFile
endfunction

function! s:keycountprint()
	let l:lsplit = split(readfile(g:KeyCountFile)[-1], '|')
	let l:totaltmp = l:lsplit[1] + g:KeyCount

	let l:width = max([strlen(l:totaltmp), 3])
	let l:keys = printf('%' . l:width . 'S', 'tot')
	let l:values = l:totaltmp
	let l:alphkeys = ''
	let l:alphvalues = ''

	let l:n = 1
	for i in sort(items(g:KeyCountLetters))
		let l:n += 1
		let l:letcnt = i[1] + l:lsplit[n]
		let l:width = max([strlen(i[0]), strlen(l:letcnt)])
		if l:n > 22
			echo l:keys
			let l:keys = ''
			echo l:values
			let l:values = ''
			let l:n = 0
		endif
		let l:keys .= '|' . printf('%'.l:width.'S', i[0])
		let l:values .= '|' . printf('%'.l:width.'S', l:letcnt)
	endfor

	echo l:keys
	echo l:values
endfunction

command! KeyCountPrint :call s:keycountprint()
command! KeyCountEdit :call s:keycountedit()
