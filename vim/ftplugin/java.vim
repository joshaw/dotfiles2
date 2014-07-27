if filereadable("build.xml")
	set makeprg=ant\ imagej
elseif filereadable("../build.xml")
	set makeprg=ant\ imagej\ -f\ ../build.xml
endif
" set errorformat=%A%f:%l:\ %m,%-Z%p^,%-C%.%#
set errorformat=%A\ %#[javac]\ %f:%l:\ %m,%-Z\ %#[javac]\ %p^,%-C%.%#

let java_highlight_functions="style"
let java_highlight_java_lang_ids=1

set noautochdir

source $HOME/.vim/custom/jcomment.vim
