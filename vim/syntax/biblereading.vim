" Created:  Thu 15 Jan 2015
" Modified: Wed 28 Jan 2015
" Author:   Josh Wainwright
" Filename: biblereading.vim

if exists("b:current_syntax")
	finish
endif

let b:current_syntax = "biblereading"

syn match emptycheckbox "\v\[ \]"
syn match fullcheckbox  "\v\[x\].*$"
syn match other         "\v^[A-Z]+$"
syn match dayofmonth    "\v(^\[ \] +)@<=\d+\."
syn match yearnum       "\v^YEAR [A-Z]+"

hi def link emptycheckbox Number
hi def link fullcheckbox  Comment
hi def link other         Identifier
hi def link dayofmonth    Type
hi def link yearnum       PreProc

" Goto next unchecked line
nnoremap <buffer> n gg/\[ \]<cr>:set nohls<cr>

" Check line and move to next
nnoremap <buffer> dd ^lrx
nnoremap <buffer> <space> ^lrxn

" Open the reading on the current line
nnoremap <buffer> <CR> :call GotoReading()<cr>

function! GotoReading()
	let lineref = getline('.')
	let booknum = substitute(lineref, '\v^\[( |x)\] +\d+\. ', '', '')
	let parts = split(booknum)
	let [book; numbers] = parts

	" For cases like 2Tim, make the regex match 2.*Tim
	if book =~ '\v^\d.+'
		let book = book[:0].".*".book[1:]
	endif

	let nums = join(numbers, "|")
	let nums = substitute(nums, ",", "", "g")
	let rangestr = matchstr(nums, '\v\d+-\d+')
	if rangestr != ""
		let range = split(rangestr, "-")
		let range = range(range[0], range[1])
		let rangestr = join(range, "|")
	else
		let rangestr = nums
	endif

	let bibfile = "~/Documents/Church/NIV.bible"
	let bufnum=bufnr(expand(bibfile))
	let winnum=bufwinnr(bufnum)
	if winnum != -1
		" Jump to existing split
		exe winnum . "wincmd w"
	else
		" Make new split as usual
		exe "vsplit " . bibfile
	endif

	let booksearch = "\\v^# ".book
	exe "silent! /".booksearch

	call clearmatches()
	let numsearch = "\\v^\\[ *(".rangestr.")\\]"
	call matchadd("Error", numsearch)
	exe "silent! /".numsearch

endfunction

" Goto next unchecked line when opening file
"normal n
