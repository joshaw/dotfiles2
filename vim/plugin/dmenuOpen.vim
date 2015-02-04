" Created:  Wed 16 Apr 2014
" Modified: Mon 12 Jan 2015
" Author:   Josh Wainwright
" Filename: dmenuOpen.vim

if ! executable('dmenu')
	finish
endif

" Strip the newline from the end of a string
function! Chomp(str)
	let str = substitute(a:str, ' ', '\\ ', 'g')
	return substitute(str, '\n$', '', '')
endfunction

" Find a file and pass it to cmd
function! DmenuOpen(cmd)

	if executable('dmenu')
		let dmenu='dmenu'
	elseif executable('slmenu')
		let dmenu='slmenu'
	else
		echoerr "Something went wrong, can't find dmenu or slmenu."
		finish
	endif
	if exists("b:git_dir") && b:git_dir != ''
		let command = "git ls-files"
	else
		let command = "ag -g \"\""
	endif
	let tmpfile = tempname()
	execute "silent !".command." | ".dmenu." -b -i -l 20 -p ".a:cmd . " > " . tmpfile
	let fname = join(readfile(tmpfile), "\n")
	let fname = Chomp(system(command . " | dmenu -b -i -l 20 -p " . a:cmd))
	if empty(fname)
		return
	endif
	execute a:cmd . " " . fname
endfunction

" map <c-t> :call DmenuOpen("tabe")<cr>
noremap <c-f> :call DmenuOpen("e")<cr>
