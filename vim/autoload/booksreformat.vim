function! booksreformat#BookReformatCmd()
	setlocal textwidth=0
	setlocal fo=
	let tmp   = input("Calibre export: ", "C:/tmp/jaw/Books.csv", "file")
	exe "e! ".tmp
	setlocal textwidth=0
	setlocal fo=

	" Remove calibre line
	silent! /^"calibre","","/d

	" Remove series_index column and join to series with #
	silent! 1s/series,series_index/series/
	silent! 2,$s/^.\{-}",".\{-}\zs","/, #/g

	" Replace commas outside quotes with bar, just commas in header
	silent! 1s/,/ | /g
	silent! 2,$s/","/" | "/g

	" Remove all remaining quotes
	silent! %s/"//g

	" Remove empty timestamps
	silent! %s/0101-01-01T00:00:00+00:00//
	silent! %s/\d\zsT\d\d:\d\d:\d\d+\d\d:\d\d//g
	
	" Zero pad series index for sorting, sort, remove zero padding and remove 
	" numbers with no series
	silent! 2,$s/#\(\d\.\d\)/#0\1/
	2,$sort
	silent! 2,$s/#0\(\d\)/#\1/
	silent! 2,$s/| , #1.0/| /

	" Align all lines by pipe
	1,$Tabularize /|

	" Make header separator and title case header
	1yank y
	1put y
	s/[^|]/-/g
	1s/\<\(\w\)\(\w*\)\>/\u\1\L\2/g

	StripTrailing
	1,$yank y
	e!

	" Insert into books file
	let books = "~/Documents/Details/books/books-all.md"
	exe "e ".books

	" Starting from the top, delete everything between the next two empty 
	" lines, then paste the contents of the file.
	1 | /^$/+1;/^$/-1d _
	-1put y
	1
	let @/ = ""
endfunction
