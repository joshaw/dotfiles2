if ! executable("ranger")
	finish
endif

function! RangerChooser()
	let temp = tempname()
	exec 'silent !ranger --choosefiles=' . shellescape(temp)
	if !filereadable(temp)
		redraw!
		" Nothing to read.
		return
	endif
	let names = readfile(temp)
	if empty(names)
		redraw!
		" Nothing to open.
		return
	endif
	" Edit the first item.
	exec 'edit ' . fnameescape(names[0])
	" Add any remaning items to the arg list/buffer list.
	for name in names[1:]
		exec 'argadd ' . fnameescape(name)
	endfor
	redraw!
endfunction

command! RangerChooser :call RangerChooser()
nnoremap <leader>r :<C-U>RangerChooser<CR>
