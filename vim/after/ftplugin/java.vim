" Created:  Wed 16 Apr 2014
" Modified: Mon 02 Feb 2015
" Author:   Josh Wainwright
" Filename: java.vim

if filereadable("build.xml")
	setlocal makeprg=ant\ imagej
elseif filereadable("../build.xml")
	setlocal makeprg=ant\ imagej\ -f\ ../build.xml
endif
" set errorformat=%A%f:%l:\ %m,%-Z%p^,%-C%.%#
setlocal errorformat=%A\ %#[javac]\ %f:%l:\ %m,%-Z\ %#[javac]\ %p^,%-C%.%#

let java_highlight_functions="style"
let java_highlight_java_lang_ids=1

setlocal noautochdir
