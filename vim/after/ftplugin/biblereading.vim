" Created:  Fri 06 Feb 2015
" Modified: Fri 13 Mar 2015
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
nnoremap <buffer> <space> ^lrxn

" Open the reading on the current line
nnoremap <buffer> <CR> :call BR_GotoReading()<cr>

function! BR_GotoReading()
	let lineref = getline('.')
	let booknum = substitute(lineref, '\v^\[( |x)\] +\d+\. ', '', '')
	let parts = split(booknum)
	let [book; numbers] = parts

	" For cases like 2Tim, make the regex match 2.*Tim
	if book =~ '\v^\d.+'
		let book = book[:0].".*".book[1:]
	endif

	" Turn multiple chapters into OR pattern
	let nums = join(numbers, "|")
	let nums = substitute(nums, ",", "", "g")

	" Is the passage a range of chapters, like 23-25
	let rangestr = matchstr(nums, '\v\d+-\d+')
	if rangestr == ""
		let rangestr = nums
	else
		let range = split(rangestr, "-")
		let range = range(range[0], range[1])
		let rangestr = join(range, "|")
	endif

	let bibfile = "~/Documents/Church/NIV.bible"
	let bufnum=bufnr(expand(bibfile))
	let winnum=bufwinnr(bufnum)
	if winnum == -1
		" Make new split as usual
		exe "vsplit " . bibfile
	else
		" Jump to existing split
		exe winnum . "wincmd w"
	endif

	let booksearch = "\\v^# ".book
	exe "silent! /".booksearch

	call clearmatches()
	let numsearch = "\\v^\\[ *(".rangestr.")\\]"
	call matchadd("User1", numsearch)
	exe "silent! /".numsearch

endfunction

" Goto next unchecked line when opening file
"normal n
