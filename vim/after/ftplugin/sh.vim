" Created:  Wed 21 Jan 2015
" Modified: Mon 16 Feb 2015
" Author:   Josh Wainwright
" Filename: sh.vim

iabbrev <buffer> <expr> #! GetShebang()
let g:is_bash=1

function! GetShebang()
	let s:shebang = ["\#!/bin/bash",
					\ substitute(CreatedHeader(),"^","# ","g"),
					\ "",
					\ "set -o nounset",
					\ "function echoerr() {\<esc>lx",
					\ "\t>&2 echo \"$@\"",
					\ "}",
					\ ""]
	return join(s:shebang, "\<esc>o")
endfunction
