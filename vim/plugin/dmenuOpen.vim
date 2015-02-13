" Created:  Wed 16 Apr 2014
" Modified: Thu 12 Feb 2015
" Author:   Josh Wainwright
" Filename: dmenuOpen.vim

if ! executable('dmenu')
	finish
endif

" Strip the newline from the end of a string
function! s:clean_string(str)
	let str = substitute(a:str, ' ', '\\ ', 'g')
	let str = substitute(str, '\n$', '', '')
	return substitute(str, '\r$', '', '')
endfunction

" Find a file and pass it to cmd
function! DmenuOpen(cmd, ...)

	if !executable('dmenu')
		echoerr "Cannot find dmenu."
		finish
	endif

	let l:global = a:0 > 0 ? a:1 : 0
	let l:amhome = getcwd() == $HOME
	if (l:global || l:amhome) && filereadable(glob("~/.files"))
		let fname = system("dmenu -b -l 20 -p ". a:cmd . "< ~/.files")
	else
		if exists("b:git_dir") && b:git_dir != ''
			let command = "cd ". fnamemodify(b:git_dir, ":h") ."; git ls-files"
		elseif executable('lsall')
			let command = "lsall"
		elseif executable('ag')
			let command = "ag --hidden -g \"\""
		else
			finish
		endif
		let fname = system(command . " | dmenu -b -i -l 20 -p " . a:cmd)
	endif
	let fname = s:clean_string(fname)
	if empty(fname)
		return
	endif
	execute a:cmd . " " . fname
	call histadd("cmd", a:cmd . " " . fname)
endfunction

" map <c-t> :call DmenuOpen("tabe")<cr>
noremap <c-f> :call DmenuOpen("e")<cr>
noremap <c-b> :call DmenuOpen("e", 1)<cr>
