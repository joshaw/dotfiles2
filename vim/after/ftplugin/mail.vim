" Created:  Wed 16 Apr 2014
" Modified: Wed 01 Jul 2015
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
inoremap <buffer> <leader>s <esc>:%s#\($\n\s*\)\+\%$##e<cr>Go<esc>:r ~/.signature2<cr>``a

nnoremap <buffer> <leader>S :r ~/.signature2<cr>

function! MailFixFormating()
  silent! %s/\([^]> :]\)\ze\n>[> ]*[^> ]/\1 /g
  TrimEndLines
endfunction

" LDRA Specific
" Replace timestamps and append report file to end of message
if search('ldra', 'cn') > 0
	silent! %s/%dty%/\=strftime("%Y%m%d")/ge
	silent! %s/%dtyd%/\=strftime("%Y-%m-%d")/ge

	if search('weekly report', 'cn')
		if ! search('=============', 'cn')
			call append(line('$'), [""])
			exec "$r ".weeklyr#EditReport(0,1)
			/Weekly Report/,$normal gwG
		endif
	endif
endif

" On Start
Tab2Space
" call MailFixFormating()
