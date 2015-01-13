" Created:  Wed 16 Apr 2014
" Modified: Mon 12 Jan 2015
" Author:   Josh Wainwright
" Filename: mail.vim

"Automatic formating of paragraphs whenever text is inserted set
"formatoptions+=a
"let b:noStripWhitespace=1
setlocal textwidth=71
exe 'setlocal dictionary+='.dictfile
set spell

if getline(1) =~ "JAW Weekly Report"
	%s/%dty%/\=strftime("%Y%m%d")/ge
	%s/%dts%/\=strftime("%d\/%m\/%Y")/ge
endif

" Remove all empty lines at the end of the file, insert a single empty line and 
" then insert the contents of the signature file.
nnoremap <leader>- :%s#\($\n\s*\)\+\%$##e<cr>Go<esc>:r ~/.signature2<cr>

nnoremap <leader>_ :r ~/.signature2<cr>
