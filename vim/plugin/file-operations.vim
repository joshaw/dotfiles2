" Created:  Mon 12 Jan 2015
" Modified: Wed 21 Jan 2015
" Author:   Josh Wainwright
" Filename: file-operations.vim

" DiffOrig {{{1
" View the difference between the buffer and the file the last time it was saved
command! DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis | wincmd p | diffthis

" RenameFile {{{1
command! -nargs=* -complete=customlist,SiblingFiles -bang RenameFile :call RenameFile("<args>", "<bang>")

function! SiblingFiles(A, L, P)
	return map(split(globpath(expand("%:h") . "/", a:A . "*"), "\n"), 'fnamemodify(v:val, ":t")')
endfunction

function! RenameFile(name, bang)
	if a:name == ""
		let a:name = input('New file name: ', expand('%:p'), 'file')
	endif
	let l:curfile = expand("%:p")
	let l:curpath = expand("%:h") . "/"
	let v:errmsg = ""
	silent! exe "saveas" . a:bang . " " . fnameescape(l:curpath . a:name)
	if v:errmsg =~# '^$\|^E329'
		let l:oldfile = l:curfile
		let l:curfile = expand("%:p")
		if l:curfile !=# l:oldfile && filewritable(l:curfile)
			silent exe "bwipe! " . fnameescape(l:oldfile)
			if delete(l:oldfile)
				echoerr "Could not delete " . l:oldfile
			endif
		endif
	else
		echoerr v:errmsg
	endif
endfunction

" Delete the current file from disk and remove its buffer {{{1
command! DeleteFile call delete(expand('%')) | bdelete!

" Set the grepprg depending on context {{{1
function! GrepString()
	if !exists("g:git_folder")
		let g:git_folder = system('git rev-parse --git-dir > /dev/null 2>&1 && echo 1 || echo 0')
		let g:has_ag = executable('ag')
		let g:has_ack = executable('ack')
	endif
	if g:git_folder
		set grepprg=git\ --no-pager\ grep\ -H\ -n\ --no-color
	elseif g:has_ag
		set grepprg=ag\ --vimgrep\ --smart-case
	elseif g:has_ack
		set grepprg=ack\ -H\ --nogroup\ --nocolor\ --smart-case
	else
		set grepprg=grep\ --dereference-recursive\ --ignore-case\ --line-number\ --with-filename\ $*
	endif
endfunction

" map <C-g> :grep<space><space>.<left><left>
nnoremap <C-g> :call GrepString()<cr>:grep<space><space>.<left><left>
