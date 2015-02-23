" Created:  Mon 12 Jan 2015
" Modified: Mon 23 Feb 2015
" Author:   Josh Wainwright
" Filename: functions.vim

" DiffOrig
" View the difference between the buffer and the file the last time it was saved
command! DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis | wincmd p | diffthis

" Set the grepprg depending on context
function! GrepString()
	if exists("b:git_dir") && b:git_dir != ''
		setlocal grepprg=git\ --no-pager\ grep\ -H\ -n\ --no-color\ --ignore-case
	elseif has('win32') && executable('pt')
		setlocal grepprg=pt
	elseif executable('ag')
		setlocal grepprg=ag\ --vimgrep\ --smart-case
	elseif executable('ack')
		setlocal grepprg=ack\ -H\ --nogroup\ --nocolor\ --smart-case
	else
		setlocal grepprg=grep\ --dereference-recursive\ --ignore-case\ --line-number\ --with-filename\ $*
	endif
endfunction

" map <C-g> :grep<space><space>.<left><left>
nnoremap <C-g> :call GrepString()<cr>:grep<space><space>.<left><left>

function! Sum() range
	let s:reg_save = getreg('"')
	let s:regtype_save = getregtype('"')
	let s:cb_save = &clipboard
	set clipboard&
	silent! normal! ""gvy
	let s:selection = getreg('"')
	call setreg('"', s:reg_save, s:regtype_save)
	let &clipboard = s:cb_save

	let s:sum = 0
	for s:n in split(s:selection)
		let s:n = substitute(s:n, '\v[^0-9]*\ze([0-9]|$)', '', "")
		if s:n == ''
			continue
		endif
		echo '[ ' . s:n . ' ]'
		let s:sum = s:sum + str2float(s:n)
	endfor
	echo "sum: " . string(s:sum)
	call append(line("'>"), string(s:sum))
endfunction
command! -range -nargs=0 -bar Sum call Sum()
