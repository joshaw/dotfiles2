" Created:  Wed 16 Apr 2014
" Modified: Tue 17 Feb 2015
" Author:   Josh Wainwright
" Filename: markdown.vim

exe 'setlocal dict+='.dictfile

"Automatic formating of paragraphs whenever text is inserted
setlocal formatoptions=tcqwan21

"Don't strip spaces and newlines when saving
let b:noStripWhitespace=1

setlocal makeprg=md.sh\ %

function! FormatTable()
	let w = winsaveview()

	let tabstart = search("^$", "bW") +1
	let tabhead = tabstart + 1
	let tabend = search("^$", "nW") -1
	exe tabhead."d _"
	if tabstart < tabend
		exe tabstart.",".tabend."EasyAlign *|"
	else
		exe tabend.",".tabstart."EasyAlign *|"
	endif
	call append(tabstart, getline(tabstart))
	exe tabhead."s/[^|]/-/g"

	call winrestview(w)
endfunction
