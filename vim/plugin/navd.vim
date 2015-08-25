" Created:  Tue 25 Aug 2015
" Modified: Tue 25 Aug 2015
" Author:   Josh Wainwright
" Filename: navd.vim

command! -nargs=? -bang Navd :call navd#navd(<q-args>, <bang>0)

augroup navd_bufevents
  au!
  autocmd BufEnter * if isdirectory(expand('<amatch>'))
        \ | call navd#navd(expand('<amatch>'), 0)
        \ | endif
augroup END
