"if !filereadable("makefile")
"	autocmd Filetype java set makeprg=javac\ %
"endif
set errorformat=%A%f:%l:\ %m,%-Z%p^,%-C%.%#

let java_highlight_functions="style"
let java_highlight_java_lang_ids=1

source $HOME/.vim/custom/jcomment.vim
