" Created:  Thu 09 Jul 2015
" Modified: Thu 20 Aug 2015
" Author:   Josh Wainwright
" Filename: incremental.vim

" Allows using <c-a> and <c-x> on user defined lists, as well as normal digits

let s:mods =
		\ [
			\ ['true', 'false'],
			\ ['yes', 'no'],
			\ ['on', 'off'],
			\ ['in', 'out'],
			\ ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'],
			\ ['monday', 'tuesday', 'wednesday', 'thursday',
				\'friday', 'saturday', 'sunday'],
			\ ['zero', 'one', 'two', 'three', 'four', 'five', 'six', 'seven',
				\ 'eight', 'nine'],
			\ ['jan', 'feb', 'mar', 'apr', 'may', 'jun', 'jul',
				\'aug', 'sep', 'oct', 'nov', 'dec'],
			\ ['january', 'february', 'march', 'april', 'may', 'june', 'july',
				\ 'august', 'september', 'october', 'november', 'december'],
		\ ]

function! incremental#incremental(arg, direction)
	let retval = ''
	let w = tolower(a:arg)

	for lst in s:mods
		let idx = index(lst, w)
		if idx >= 0
			let retval = lst[(idx + v:count1*a:direction) % len(lst)]
			if a:arg =~# '^\l*$'
				let reptype = 0
			elseif a:arg =~# '^\u*$'
				let reptype = 1
				let retval = toupper(retval)
			elseif a:arg =~# '^\u\l*$'
				let reptype = 2
				let retval = toupper(retval[0]) . retval[1:]
			else
				let reptype = 3
				let retval = ''
			endif
			break
		endif
	endfor

	if retval == ''
		if a:direction == 1
			silent execute "normal! ".v:count1."\<C-a>"
		else
			silent execute "normal! ".v:count1."\<C-x>"
		endif
	else
		let idx = match(getline('.'), a:arg, col('.')-len(a:arg), 1)
		let line = getline('.')
		let after = line[idx + len(a:arg):]
		if idx == 0
			call setline('.', retval . after)
		else
			let before = line[:idx-1]
			call setline('.', before . retval . after)
		endif
	endif
endfunction
