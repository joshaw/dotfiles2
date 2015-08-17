" Created:  Wed 16 Apr 2014
" Modified: Mon 03 Aug 2015
" Author:   Josh Wainwright
" Filename: dmenuOpen.vim

" Strip the newline from the end of a string
function! s:clean_string(str)
	let str = substitute(a:str, ' ', '\\ ', 'g')
	let str = substitute(str, '\n$', '', '')
	return substitute(str, '\r$', '', '')
endfunction

" Find a file and pass it to cmd
function! dmenuOpen#DmenuOpen(cmd, ...)

	let l:global = a:0 > 0 ? a:1 : 0
	let l:amhome = getcwd() == $HOME
	let l:filesfile = "~/.files"
	if (l:global || l:amhome) && filereadable(glob(l:filesfile))
		let fname = system("dmenu -b -l 20 -p ". a:cmd . "< ". l:filesfile)
	else
		if exists("b:git_dir") && b:git_dir != ''
			let command = "cd ". fnamemodify(b:git_dir, ":h") ."; git ls-files"
		elseif executable('lsall')
			let command = "lsall -n"
		elseif executable('ag')
			let command = "ag --hidden -g \\\"\\\""
		else
			finish
		endif
		let fname = system(command . " | dmenu -b -i -l 20 -p " . a:cmd)
	endif
	let fname = s:clean_string(fname)
	if empty(fname) || !filereadable(glob(fname))
		echo "No file selected"
		return
	endif
	execute a:cmd . " " . fname
	call histadd("cmd", a:cmd . " " . fname)
endfunction
