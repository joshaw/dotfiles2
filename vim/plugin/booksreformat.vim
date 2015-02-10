function! BookReformatCmd()
	let tmp   = input("Calibre export: ", "C:/tmp/jaw/Books.csv", "file")
	exe "e! ".tmp

	" Remove calibre line
	/^"calibre","","/d

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
	
	" Zero pad series index for sorting
	silent! 2,$s/#\(\d\.\d\)/#0\1/
	3,$sort
	silent! 2,$s/| , #01.0\(\s\+\)|/|        \1|/

	" Align all lines by pipe
	exe "normal ggVG10gl|"

	" Make header separator and title case header
	normal ggyyp
	s/[^|]/-/g
	1s/\<\(\w\)\(\w*\)\>/\u\1\L\2/g

	StripTrailing!
	normal ggyG
	e!

	" Insert into books file
	let books = "~/Documents/Details/books.md"
	exe "e ".books
	1
	/^$/;/^$/-1d _
	.t.
	normal Pgg
	nohlsearch
endfunction
