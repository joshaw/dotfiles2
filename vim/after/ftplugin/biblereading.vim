" Created:  Fri 06 Feb 2015
" Modified: Tue 07 Jul 2015
" Author:   Josh Wainwright
" Filename: biblereading.vim

" Goto next unchecked line
nmap <buffer> n :call BR_NextReading()<cr>

function! BR_NextReading()
	1
	call search("^\[ ", 'W')
endfunction

" Check line and move to next
nnoremap <buffer> dd ^lrx
nnoremap <buffer> <space> ^lrx:call BR_NextReading()<cr>

" Open the reading on the current line
nnoremap <buffer> <CR> :call BR_GotoReading()<cr>

function! BR_GotoReading()
	let lineref = getline('.')
	let booknum = substitute(lineref, '\v^\[( |x)\] +\d+\. ', '', '')
	let parts = split(booknum)
	let [book; numbers] = parts

	" For cases like 2Tim, make the regex match 2.*Tim
	if book =~ '\v^\d.+'
		let book = book[:0] . "*" . book[1:]
	endif
	let book = "*" . book . "*"

	" Turn multiple chapters into OR pattern, eg 4,6,8
	let nums = join(numbers, "|")
	let nums = substitute(nums, ",", "", "g")

	" Turn range of chapters into OR pattern, eg 23-25
	let rangestr = matchstr(nums, '\v\d+-\d+')
	if rangestr == ""
		let rangestr = nums
	else
		let range = split(rangestr, "-")
		let range = range(range[0], range[1])
		let rangestr = join(range, "|")
	endif

	" let bibfile = "~/Documents/Church/NIV.bible"
	let bibfile = glob('~/Documents/Church/niv/' . book ,0,0)
	" let bufnum = bufnr(expand(bibfile))
	" let winnum = bufwinnr(bufnum)
	let winnum = -1
	windo if &ft == "bible" | let winnum = bufwinnr("%") | endif
	if winnum == -1
		" Make new split as usual with the right width
		exe winwidth(0)-40."vsplit " . bibfile
	else
		" Jump to existing split
		exe winnum . "wincmd w"
		if !expand('%') == bibfile
			exe "edit " bibfile
		endif
	endif

	" let booksearch = "\\v^### ".book
	" call search(booksearch, "cw")

	call clearmatches()
	let numsearch = "\\v^\\[ *(".rangestr.")\\]"
	call matchadd("User1", numsearch)
	call search(numsearch, "cw")

endfunction

" Goto next unchecked line when opening file
"normal n
