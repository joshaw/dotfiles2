" Created:  Sat 18 Oct 2014
" Modified: Fri 16 Jan 2015
" Author:   Josh Wainwright
" Filename: display.vim

" Vim Plugin which provides a "Display Mode", ie a mode that is more
" suitable for displaying code to others. The mode is toggled using a
" keybinding and the state is saved across restarts if &viminfo includes !.

" Define the settings that will be changed when entering display mode.
function! Display_mode()
	let g:DMODE = 1
	colorscheme github
	set guioptions+=mbr
	if has("unix")
		set guifont=Droid\ Sans\ Mono\ 10
	else
		set guifont=Consolas:h13:cANSI
	endif
	set colorcolumn=0
	set nolist
	set norelativenumber
	set statusline&
endfunction

" Switch back to normal mode by re-sourcing the vimrc file.
function! No_display_mode()
	unlet g:DMODE
	source $MYVIMRC
endfunction

" Toggle display mode.
function! Switch_display_mode()
	if exists("g:DMODE")
		call No_display_mode()
	else
		call Display_mode()
	endif
endfunction

" When starting, check to see if DMODE exists from a previous session.
function! Display_mode_start()
	if exists("g:DMODE")
		call Display_mode()
	endif
endfunction

augroup DisplayMode
	autocmd VimEnter,BufEnter * call Display_mode_start()
augroup END

nnoremap <silent> <F5> :<C-u>call Switch_display_mode()<CR>
