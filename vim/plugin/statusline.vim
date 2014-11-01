" Created:  Tue 29 Jul 2014 03:05 PM
" Modified: Wed 29 Oct 2014 12:38 PM

"StatusLine {{{
function! StatusLineInsert()
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

function! StatusLineNormal()
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

function! StatusLineInactive()
	setlocal statusline=%F
endfunction

call StatusLineNormal()
augroup statuslines
	au!
	au InsertEnter * call StatusLineInsert()
	au BufEnter,InsertLeave * call StatusLineNormal()
	au BufLeave * call StatusLineInactive()
augroup END
"}}}
