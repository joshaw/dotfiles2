" Created:  Wed 16 Apr 2014
" Modified: Mon 16 Feb 2015
" Author:   Josh Wainwright
" Filename: mail.vim

"Automatic formating of paragraphs whenever text is inserted set
"formatoptions+=a
"let b:noStripWhitespace=1
setlocal textwidth=71
exe 'setlocal dictionary+='.dictfile
setlocal spell

if executable('par')
	set formatprg=par\ -w71qie
endif

" Remove all empty lines at the end of the file, insert a single empty line and
" then insert the contents of the signature file.
nnoremap <buffer> <leader>- :%s#\($\n\s*\)\+\%$##e<cr>Go<esc>:r ~/.signature2<cr>

nnoremap <buffer> <leader>_ :r ~/.signature2<cr>

"Automatic formating of paragraphs whenever text is inserted
set formatoptions=tcqwan21

"Don't strip spaces and newlines when saving
let b:noStripWhitespace=1

" LDRA Specific
" Replace timestamps and append report file to end of message
if getline(1) =~ "JAW Weekly Report"
	%s/%dty%/\=strftime("%Y%m%d")/ge
	%s/%dts%/\=strftime("%d\/%m\/%Y")/ge
	if ! search("=============")
		call append(line('$'), ["",""])
		exec "$r ".EditReport(0,1)
		/-=-=-=/,$normal gwG
	endif
endif
