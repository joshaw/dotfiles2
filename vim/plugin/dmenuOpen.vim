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

	if !exists("g:git_folder")
		let g:git_folder = system('git rev-parse --git-dir > /dev/null 2>&1 && echo 1 || echo 0')
	endif

	if g:git_folder
		let command = "git ls-files"
	elseif $USERNAME == 'jaw097'
		let command = "git ls-files"
	else
		let command = "ag -g \"\""
	endif
	let fname = Chomp(system(command . " | dmenu -b -i -l 20 -p " . a:cmd))
	if empty(fname)
		return
	endif
	execute a:cmd . " " . fname
endfunction

" map <c-t> :call DmenuOpen("tabe")<cr>
noremap <c-f> :call DmenuOpen("e")<cr>
