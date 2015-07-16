" Created:  Thu 09 Jul 2015
" Modified: Thu 09 Jul 2015
" Author:   Josh Wainwright
" Filename: python.vim

autocmd Filetype python setlocal expandtab
autocmd Filetype python setlocal keywordprg=pydoc

iab def # start function<esc>odef<esc>o# end function<esc>ka
iab im import
iab pri print()<esc>i
iab print print('')<esc>hi
