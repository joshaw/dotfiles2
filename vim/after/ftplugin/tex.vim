" Created:  Thu 24 Jul 2014
" Modified: Sat 24 Jan 2015
" Author:   Josh Wainwright
" Filename: tex.vim

" setlocal iskeyword+=:,-,_
let g:tex_isk="48-57,a-z,A-Z,192-255,:,-,_"
setlocal makeprg=make

" Standard error message formats
" Note: We consider statements that starts with "!" as errors
setlocal efm=%E!\ LaTeX\ %trror:\ %m
setlocal efm+=%E%f:%l:\ %m
setlocal efm+=%E!\ %m

" More info for undefined control sequences
setlocal efm+=%Z<argument>\ %m

" More info for some errors
setlocal efm+=%Cl.%l\ %m

" Parse biblatex warnings
setlocal efm+=%-C(biblatex)%.%#in\ t%.%#
setlocal efm+=%-C(biblatex)%.%#Please\ v%.%#
setlocal efm+=%-C(biblatex)%.%#LaTeX\ a%.%#
setlocal efm+=%-Z(biblatex)%m

" Parse hyperref warnings
setlocal efm+=%-C(hyperref)%.%#on\ input\ line\ %l.

" setlocal efm+=%+WLaTeX\ %.%#Warning:\ %.%#line\ %l%.%#
" setlocal efm+=%+W%.%#\ at\ lines\ %l--%*\\d
" setlocal efm+=%+WLaTeX\ %.%#Warning:\ %m
" setlocal efm+=%+W%.%#Warning:\ %m

" setlocal efm+=%-WLaTeX\ %.%#Warning:\ %.%#line\ %l%.%#
setlocal efm+=%-W%.%#\ at\ lines\ %l--%*\\d
setlocal efm+=%-WLaTeX\ %.%#Warning:\ %m
setlocal efm+=%-W%.%#Warning:\ %m

" Push file to file stack
setlocal efm+=%+P**%f
setlocal efm+=%+P**\"%f\"

" Ignore unmatched lines
setlocal efm+=%-G%.%#
