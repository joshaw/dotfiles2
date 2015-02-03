" Created:  Mon 12 Jan 2015
" Modified: Tue 03 Feb 2015
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
	let l:name = a:name
	if l:name == ""
		let l:name = input('New file name: ', expand('%:p'), 'file')
	endif
	let l:curfile = expand("%:p")
	let l:curpath = expand("%:h") . "/"
	let v:errmsg = ""
	silent! exe "saveas" . a:bang . " " . fnameescape(l:curpath . l:name)
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
	if exists("b:git_dir") && b:git_dir != ''
		setlocal grepprg=git\ --no-pager\ grep\ -H\ -n\ --no-color
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
