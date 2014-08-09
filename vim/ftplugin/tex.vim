" Created:  Thu 24 Jul 2014 12:41 PM
" Modified: Wed 06 Aug 2014 10:25 am

" set iskeyword+=:,-,_
let g:tex_isk="48-57,a-z,A-Z,192-255,:,-,_"
set makeprg=make

" Standard error message formats
" Note: We consider statements that starts with "!" as errors
set efm=%E!\ LaTeX\ %trror:\ %m
set efm+=%E%f:%l:\ %m
set efm+=%E!\ %m

" More info for undefined control sequences
set efm+=%Z<argument>\ %m

" More info for some errors
set efm+=%Cl.%l\ %m

" Parse biblatex warnings
set efm+=%-C(biblatex)%.%#in\ t%.%#
set efm+=%-C(biblatex)%.%#Please\ v%.%#
set efm+=%-C(biblatex)%.%#LaTeX\ a%.%#
set efm+=%-Z(biblatex)%m

" Parse hyperref warnings
set efm+=%-C(hyperref)%.%#on\ input\ line\ %l.

" set efm+=%+WLaTeX\ %.%#Warning:\ %.%#line\ %l%.%#
" set efm+=%+W%.%#\ at\ lines\ %l--%*\\d
" set efm+=%+WLaTeX\ %.%#Warning:\ %m
" set efm+=%+W%.%#Warning:\ %m

" set efm+=%-WLaTeX\ %.%#Warning:\ %.%#line\ %l%.%#
set efm+=%-W%.%#\ at\ lines\ %l--%*\\d
set efm+=%-WLaTeX\ %.%#Warning:\ %m
set efm+=%-W%.%#Warning:\ %m

" Push file to file stack
set efm+=%+P**%f
set efm+=%+P**\"%f\"

" Ignore unmatched lines
set efm+=%-G%.%#
