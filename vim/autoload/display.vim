" Created:  Sat 18 Oct 2014
" Modified: Sun 26 Apr 2015
" Author:   Josh Wainwright
" Filename: display.vim

" Vim Plugin which provides a "Display Mode", ie a mode that is more
" suitable for displaying code to others. The mode is toggled using a
" keybinding and the state is saved across restarts if &viminfo includes !.

" Define the settings that will be changed when entering display mode.
function! s:display_mode()
	let g:DMODE = 1
	colorscheme simplon
	if has("unix")
		set guifont=Droid\ Sans\ Mono\ 10
	else
		set guifont=Consolas:h13:cANSI
	endif
	set guioptions+=mbr
	set colorcolumn=0
	set nolist
	set norelativenumber
	let g:statusline_store=&statusline
	set statusline&
endfunction

" Switch back to normal mode by re-sourcing the vimrc file.
function! s:no_display_mode()
	unlet g:DMODE
	source $MYVIMRC
	let &statusline=g:statusline_store
endfunction

" Toggle display mode.
function! display#Switch_display_mode()
	if exists("g:DMODE")
		call s:no_display_mode()
	else
		call s:display_mode()
	endif
endfunction

" When starting, check to see if DMODE exists from a previous session.
function! display#Display_mode_start()
	if exists("g:DMODE")
		call s:display_mode()
	endif
endfunction
