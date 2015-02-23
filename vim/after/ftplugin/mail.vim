" Created:  Wed 16 Apr 2014
" Modified: Mon 23 Feb 2015
" Author:   Josh Wainwright
" Filename: mail.vim

setlocal noautoindent
setlocal comments+=mb:*
setlocal comments+=n:\|
setlocal comments+=n:)
setlocal formatoptions=tcqwan21
setlocal textwidth=71
exe 'setlocal dictionary+='.dictfile
setlocal spell

if executable('par')
	setlocal formatprg=par\ -w71qie
endif

" Remove all empty lines at the end of the file, insert a single empty line and
" then insert the contents of the signature file.
nnoremap <buffer> <leader>s :%s#\($\n\s*\)\+\%$##e<cr>Go<esc>:r ~/.signature2<cr>

nnoremap <buffer> <leader>S :r ~/.signature2<cr>

function! MailFixFormating()
  silent! %s/\v^\>[ %|#>]*$//e
  silent! %s/\([^]> :]\)\ze\n>[> ]*[^> ]/\1 /g
  TrimEndLines
endfunction

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

" On Start
call MailFixFormating()
