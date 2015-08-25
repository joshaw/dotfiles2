" Created:  Wed 16 Apr 2014
" Modified: Thu 20 Aug 2015
" Author:   Josh Wainwright
" Filename: statusline.vim

set ls=2 " Always show status line

function! s:statuslineconvert(n, orig)
	if has("gui_running")
		let p = 'gui'
	else
		let p = 'cterm'
	endif
		exec 'hi User'.a:n p.'fg='.synIDattr(synIDtrans(hlID(a:orig)), 'fg')
					\ p.'bg='.synIDattr(synIDtrans(hlID('ColorColumn')), 'bg')
endfunction

" Set up the colors for the status bar
function! statusline#colour()
	" Basic color presets
	call s:statuslineconvert(5, 'Comment')
	call s:statuslineconvert(7, 'Operator')
	call s:statuslineconvert(8, 'Identifier')
	call s:statuslineconvert(9, 'Normal')
endfunc

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

function! statusline#optflags()
	let flags = ''
	let flags.=(&paste != 0 ? 'p' : '')
	let flags.=(&spell != 0 ? 's' : '')
" 	let flags.=(&wrap != 0 ? 'w' : '')
	let flags.=(&bin != 0 ? 'b' : '')
	let flags.=(&ro != 0 ? ' ro' : '')
	if flags ==# ' ro'
		let flags = 'ro'
	endif
	if len(flags) > 0
		let flags= '['.flags.']'
	endif
	return flags
endfunction

let s:stl= ""
let s:stl.="%5*%<%{statusline#filepath()}"      " file path
let s:stl.="%9*%t "                              " file name
let s:stl.="%7*%([%M]%) "                        " modified flag

let s:stl.="%="                                  " right-align

let s:stl.="%7*%{(exists('g:status_var') ? g:status_var : '')} "
let s:stl.="%9*%{statusline#optflags()} "        " option flags
let s:stl.="%8*%{&filetype} "                    " file type
let s:stl.="%9*%{(&ff=='unix'?'u':&ff)}"         " file format
let s:stl.="%(%{(&fenc=='utf-8'?'8':&fenc)} |%)" " file encoding
let s:stl.="%3.c:"                               " column number
let s:stl.="%7*%3.l%8*/%-2.L\ "                  " line number / total lines
let s:stl.="%3.p%% "                             " percentage done

let g:stl = s:stl

augroup statusline
	" whenever the color scheme changes re-apply the colors
	au ColorScheme,VimEnter * call statusline#colour()
	au BufEnter,Filetype * call setwinvar(0, "&statusline", s:stl)
" 	au WinEnter,BufEnter * call setwinvar(0, "&statusline", s:stl)
	au WinLeave *  exec "hi StatusLineNC guifg=#BBBBBB guibg=#111111" |
				\ call setwinvar(0, "&statusline", "")
augroup END
