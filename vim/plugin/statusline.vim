set ls=2 " Always show status line
let g:last_mode=""

" hi StatusLine guibg=#3b3a32 guifg=#F8F8F2 guisp=#F8F8F2 gui=NONE ctermfg=230 ctermbg=237 cterm=NONE
hi StatusLine guifg=#F8F8F2 guibg=#383830 guisp=#F8F8F2 gui=NONE ctermfg=230 ctermbg=237 cterm=NONE

let g:status_normal   = 'guifg=#000000 guibg=#7dcc7d ctermfg=0   ctermbg=2'
let g:status_insert   = 'guifg=#ffffff guibg=#ff0000 ctermfg=15  ctermbg=9'
let g:status_replace  = 'guifg=#ffff00 guibg=#5b7fbb ctermfg=190 ctermbg=67'
let g:status_visual   = 'guifg=#ffffff guibg=#810085 ctermfg=15  ctermbg=53'
let g:status_modified = 'guifg=#ffffff guibg=#ff00ff ctermfg=15  ctermbg=5'
let g:status_fname    = 'guifg=#75715E guibg=#383830 ctermfg=59  ctermbg=237'
let g:status_line     = 'guifg=#ff00ff guibg=#383830 ctermfg=207 ctermbg=237'
let g:status_lines    = 'guifg=#cc6633 guibg=#383830 ctermfg=208 ctermbg=237'
let g:status_default  = 'guifg=#f8f8f2 guibg=#383830 ctermfg=230 ctermbg=237'

" Set up the colors for the status bar
function! statusline#colour()
	" Basic color presets
	exec 'hi User1 '.g:status_normal
	exec 'hi User2 '.g:status_replace
	exec 'hi User3 '.g:status_insert
	exec 'hi User4 '.g:status_visual
	exec 'hi User5 '.g:status_fname
	exec 'hi User6 '.g:status_modified
	exec 'hi User7 '.g:status_line
	exec 'hi User8 '.g:status_lines
	exec 'hi User9 '.g:status_default
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
	else                 | return l:mode
	endif
endfunc

call statusline#colour()

let s:stl= ""
let s:stl.="%1*%n"                               " buffer number
let s:stl.="%1*\ %{statusline#mode()} %9* "      " mode (changes color)
let s:stl.="%5*%<%{(expand('%')==''?'':expand('%:p:h'))}" " file path
let s:stl.="\\%9*%t "                            " file name
let s:stl.="%(%7*[%M] %)%9*"                     " modified flag

let s:stl.="%="                                  " right-align

let s:stl.="%(%{(&spell!=0?'[s]':'')}%)"         " spell check flag
let s:stl.="%(%{(&ro!=0?'[ro]':'')}%)"           " readonly flag
let s:stl.="%(%{(&bin!=0?'[b]':'')}%) "          " binary flag
let s:stl.="%(%8*%{&filetype} %9*%)"             " file type
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
