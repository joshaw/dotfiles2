" Created:  Thu 09 Jul 2015
" Modified: Fri 17 Jul 2015
" Author:   Josh Wainwright
" Filename: python.vim

setlocal expandtab
setlocal keywordprg=pydoc

Snip def # start function<esc>odef<esc>o# end function<esc>ka
Snip im import
Snip pri print()<esc>i
Snip print print('')<esc>hi
Snip ifmain if __name__ == '__main__':<esc>omain(sys.argv[1:])<esc>o
