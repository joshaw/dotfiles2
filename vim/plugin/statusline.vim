" Created:  Wed 16 Apr 2014
" Modified: Thu 09 Apr 2015
" Author:   Josh Wainwright
" Filename: statusline.vim

set ls=2 " Always show status line
let g:last_mode=""

let g:status_normal   = 'guifg=#000000 guibg=#7dcc7d ctermfg=0   ctermbg=2'
let g:status_insert   = 'guifg=#ffffff guibg=#ff0000 ctermfg=15  ctermbg=9'
let g:status_replace  = 'guifg=#ffff00 guibg=#5b7fbb ctermfg=190 ctermbg=67'
let g:status_visual   = 'guifg=#ffffff guibg=#810085 ctermfg=15  ctermbg=53'

" Set up the colors for the status bar
function! statusline#colour()
	" Basic color presets
	hi link User5 Comment
	hi link User6 Operator
	hi link User7 Operator
	hi link User8 Identifier
	hi link User9 Normal
endfunc

function! statusline#mode()
	redraw
	let l:mode = mode()

	if     mode ==# "n"  | exec 'hi User1 '.g:status_normal  | return "NORMAL"
	elseif mode ==# "i"  | exec 'hi User1 '.g:status_insert  | return "INSERT"
	elseif mode ==# "R"  | exec 'hi User1 '.g:status_replace | return "REPLACE"
	elseif mode ==# "v"  | exec 'hi User1 '.g:status_visual  | return "VISUAL"
	elseif mode ==# "V"  | exec 'hi User1 '.g:status_visual  | return "V-LINE"
	elseif mode ==# "" | exec 'hi User1 '.g:status_visual  | return "V-BLOCK"
	elseif mode ==# "t"  | exec 'hi User1 '.g:status_replace | return "TERM"
	else                 | return l:mode
	endif
endfunc

call statusline#colour()

function! statusline#filepath()
	if expand('%') == ''
		return ''
	else
		let l:home = escape($HOME, '\')
		let l:curfile = expand('%:p:h')
		let l:curfile = substitute(l:curfile, l:home, '~', '')
		let l:curfile = substitute(l:curfile, '\\', '/', 'g')
		return l:curfile . '/'
	endif
endfunction

let s:stl= ""
let s:stl.="%1* %{statusline#mode()} %9* "       " mode (changes color)
let s:stl.="%5*%<%{statusline#filepath()}"       " file path
let s:stl.="%9*%t "                              " file name
let s:stl.="%(%7*[%M] %)%9*"                     " modified flag

let s:stl.="%="                                  " right-align

let s:stl.="%(%{(&spell!=0?'[s]':'')}%)"         " spell check flag
let s:stl.="%(%{(&ro!=0?'[ro]':'')}%)"           " readonly flag
let s:stl.="%(%{(&bin!=0?'[b]':'')}%) "          " binary flag
let s:stl.="%(%8*%{&filetype} %)%9*"             " file type
let s:stl.="%(%{(&ff=='unix'?'u':'d')}%)"        " file format
let s:stl.="%(%{(&fenc=='utf-8'?'8':&fenc)} |%)" " file encoding
let s:stl.="%3.c:"                               " column number
let s:stl.="%7*%3.l%8*/%-2.L\ "                  " line number / total lines
let s:stl.="%3.p%% "                             " percentage done

augroup statusline
	" whenever the color scheme changes re-apply the colors
	au ColorScheme * call statusline#colour()

	au WinEnter,BufEnter *
				\ call setwinvar(0, "&statusline", s:stl)
	au WinLeave *
				\ exec "hi StatusLineNC guifg=#BBBBBB guibg=#111111" |
				\ call setwinvar(0, "&statusline", "")
augroup END
