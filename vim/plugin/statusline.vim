" Created:  Tue 29 Jul 2014 03:05 PM
" Modified: Fri 03 Oct 2014 12:39 PM

"StatusLine {{{
function! s:insertStatusLine()
	setlocal statusline=
	setlocal statusline+=%1*\ %<%f\                      "full path
	setlocal statusline+=%9*%h                           "help file flag
	setlocal statusline+=%r                              "read only flag
	setlocal statusline+=%w                              "preview flag
	setlocal statusline+=%q                              "quicklist/locationlist flag
	setlocal statusline+=%1*%m%*                         "modified flag
	setlocal statusline+=%=%3*                           "left/right separator
	setlocal statusline+=%{&spell?'[s]':''}              "spelling
	setlocal statusline+=%{&binary?'[b]':''}             "binary mode
	setlocal statusline+={%{&ft}}                        "filetype
	setlocal statusline+=[%{strlen(&fenc)?&fenc:'none'}, "file encoding
	setlocal statusline+=\ %{&ff}]\                      "file format
	setlocal statusline+=%8*%c,\                         "cursor column
	setlocal statusline+=%l%6*/%L                        "cursor line/total lines
	setlocal statusline+=\ %p%%                          "percent through file
endfunction

function! s:normalStatusLine()
	setlocal statusline=
	setlocal statusline+=%4*%n
	setlocal statusline+=%3*\ %<%F\                      "full path
	setlocal statusline+=%9*%h                           "help file flag
	setlocal statusline+=%r                              "read only flag
	setlocal statusline+=%w                              "preview flag
	setlocal statusline+=%q                              "quicklist/locationlist flag
	setlocal statusline+=%1*%m%*                         "modified flag
	setlocal statusline+=%=%3*                           "left/right separator
	setlocal statusline+=%{&spell?'[s]':''}              "spelling
	setlocal statusline+=%{&binary?'[b]':''}             "binary mode
	setlocal statusline+={%{&ft}}                        "filetype
	setlocal statusline+=[%{strlen(&fenc)?&fenc:'none'}, "file encoding
	setlocal statusline+=\ %{&ff}]\                      "file format
	setlocal statusline+=%8*%c,\                         "cursor column
	setlocal statusline+=%l%6*/%L                        "cursor line/total lines
	setlocal statusline+=\ %p%%                          "percent through file
endfunction

function! s:inactiveStatusLine()
	setlocal statusline=%F
endfunction

call s:normalStatusLine()
augroup statuslines
	au!
	au InsertEnter * call s:insertStatusLine()
	au BufEnter,InsertLeave * call s:normalStatusLine()
	au BufLeave * call s:inactiveStatusLine()
augroup END
"}}}
