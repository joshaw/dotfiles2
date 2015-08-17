" Created:  Sat 18 Oct 2014
" Modified: Tue 04 Aug 2015
" Author:   Josh Wainwright
" Filename: display.vim

" Vim Plugin which provides a "Display Mode", ie a mode that is more
" suitable for displaying code to others. The mode is toggled using a
" keybinding and the state is saved across restarts if &viminfo includes !.

let s:reading_mode_def = {
			\ 'Name': 'Reading',
			\ 'number': 0,
			\ 'relativenumber': 0,
			\ 'cursorline': 0,
			\ 'laststatus': 0,
			\ 'ruler': 1,
			\ 'rulerformat': '%6(%=%M%P%)',
			\ 'showtabline': 0,
			\ 'list': 0,
			\ 'colorcolumn': 0,
			\ 'scrolloff': 999,
			\ }

let s:display_mode_def = {
			\ 'Name': 'Display',
			\ 'guioptions': &guioptions.'mbr',
			\ 'colorcolumn': 0,
			\ 'list': 0,
			\ 'relativenumber': 0,
			\ 'statusline': '',
			\ 'Colorscheme': 'simplon',
			\ }

function! display#Reading_mode_toggle()
	call s:mode_toggle(s:reading_mode_def)
endfunction
function! display#Display_mode_toggle()
	call s:mode_toggle(s:display_mode_def)
endfunction

" Reading mode turns off a number of distractions
function! s:mode_toggle(mode_def)
	let modename = a:mode_def['Name']
	if exists("b:opts_save{modename}")
		echo modename.' mode off'
		for [optname, optval] in items(b:opts_save{modename})
			if optname == 'Name'
				continue

			elseif optname == 'Colorscheme'
				exe 'colorscheme '.optval

			else
				exe 'let &l:'.optname.'="'.optval.'"'
			endif
		endfor
		unlet b:opts_save{modename}
		silent! unlet g:DMODE
	else
		let b:opts_save{modename} = {}
		let g:DMODE = a:mode_def['Name']
		echo modename.' mode on'
		for [optname, optval] in items(a:mode_def)
			if optname == 'Name'
				let b:opts_save{modename}["Name"] = optval
				continue

			elseif optname == 'Colorscheme'
				let b:opts_save{modename}["Colorscheme"] = g:colors_name
				exe 'colorscheme '.optval

			else
				exe 'let b:opts_save{modename}["'.optname.'"] = &'.optname
				exe 'let &l:'.optname.'="'.optval.'"'
			endif
		endfor
	endif
endfunction

" When starting, check to see if DMODE exists from a previous session.
function! display#Display_mode_start()
	if exists("g:DMODE")
		if g:DMODE == 'Display'
			unlet g:DMODE
			call display#Display_mode_toggle()
		else
			unlet g:DMODE
		endif
	endif
endfunction
