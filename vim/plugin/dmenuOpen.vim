" Created:  Wed 16 Apr 2014
" Modified: Wed 04 Feb 2015
" Author:   Josh Wainwright
" Filename: dmenuOpen.vim

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
	elseif executable('lsall')
		let command = "lsall"
	elseif executable('ag')
		let command = "ag --hidden -g \"\""
	else
		finish
	endif
	let tmpfile = tempname()
	execute "silent !".command." | ".dmenu." -b -i -l 20 -p ".a:cmd . " > " . tmpfile
	let fname = join(readfile(tmpfile), "\n")
	if empty(fname)
		return
	endif
	execute a:cmd . " " . fname
endfunction

" map <c-t> :call DmenuOpen("tabe")<cr>
noremap <c-f> :call DmenuOpen("e")<cr>:redraw!<cr>
