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

" Search and Replace through all buffers
function! BufGrep(search)
	echo a:search
	cclose
	call setqflist([])
	silent! exe "bufdo vimgrepadd " . a:search . " %"
	copen
endfunction

command! -nargs=1 BufGrep :call BufGrep(<f-args>)
