" Created:  Mon 12 Jan 2015
" Modified: Mon 12 Jan 2015
" Author:   Josh Wainwright
" Filename: file-operations.vim

" View the difference between the buffer and the file the last time it was saved
command! DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis | wincmd p | diffthis

" Rename the current file and open it in a new buffer
function! RenameFile(...)
    let old_name = expand('%')
    if a:1 == ""
        let new_name = input('New file name: ', expand('%'), 'file')
    else
        let new_name = a:1
    endif
    if new_name != '' && new_name != old_name
        exec ':saveas ' . new_name
        " exec ':silent !rm ' . old_name
        call delete(old_name)
        redraw!
    endif
endfunction
command! -nargs=? RenameFile :call RenameFile(<q-args>)

" Delete the current file from disk and remove its buffer
command! DeleteFile call delete(expand('%')) | bdelete!

" Set the grepprg depending on context
function! GrepString()
	if !exists("g:git_folder")
		let g:git_folder = system('git rev-parse --git-dir > /dev/null 2>&1 && echo 1 || echo 0')
		let s:has_ag = executable('ag')
		let s:has_ack = executable('ack')
	endif
	if g:git_folder
		set grepprg=git\ --no-pager\ grep\ -H\ -n\ --no-color
	elseif s:has_ag
		set grepprg=ag\ --vimgrep\ --smart-case
	elseif s:has_ack
		set grepprg=ack\ -H\ --nogroup\ --nocolor\ --smart-case
	else
		set grepprg=grep\ --dereference-recursive\ --ignore-case\ --line-number\ --with-filename\ $*
	endif
endfunction

" map <C-g> :grep<space><space>.<left><left>
nnoremap <C-g> :call GrepString()<cr>:grep<space><space>.<left><left>
