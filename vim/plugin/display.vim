" vim: ft=vim

function! Display_mode()
	let g:dmode = 1
	colorscheme github
	set guifont=Consolas:h15:cANSI
	set colorcolumn=0
	set norelativenumber
	set nowrap
endfunction

function! No_display_mode()
	unlet g:dmode
	source $MYVIMRC
endfunction

function! Switch_display_mode()
	if exists("g:dmode")
		call No_display_mode()
	else
		call Display_mode()
	endif
endfunction

function! Save_display_mode()
	echo "(NOT) Display mode saved."
	" if !shell("grep \"g:dmode\" $MYVIMRC")
	" 	shell("echo \"let g:dmode = 1\"")
endfunction

nnoremap <silent> <F5> :<C-u>call Switch_display_mode()<CR>
nnoremap <silent> <S-F5> :<C-u>call Save_display_mode()<CR>
