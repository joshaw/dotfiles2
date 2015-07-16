" eunuch.vim - Helpers for UNIX
" Maintainer:   Tim Pope <http://tpo.pe/>
" Version:      1.1

if exists('g:loaded_eunuch') || &cp || v:version < 700
  finish
endif
let g:loaded_eunuch = 1

command! -bar -bang RemoveFile :call eunuch#RemoveFile(<q-bang>, <q-args>)
command! -bar -nargs=? -bang -complete=file MoveFile :call eunuch#MoveFile(<q-bang>, <q-args>)
command! -bar -bang -complete=file -nargs=+ Find   :call eunuch#Grep(<q-bang>, <q-args>, 'find')
command! -bar -bang -complete=file -nargs=+ Locate :call eunuch#Grep(<q-bang>, <q-args>, 'locate')
command! -bar -bang -complete=file -nargs=+ GGrep :call eunuch#Grep(<q-bang>, <q-args>, 'git grep')
command! -bar -bang -nargs=? -complete=dir Mkdir :call eunuch#Mkdir(<q-bang>, <q-args>)
command! MaxLine call eunuch#MaxLine()

augroup shebang_chmod
  autocmd!
  autocmd BufNewFile  * let b:brand_new_file = 1
  autocmd BufWritePost * unlet! b:brand_new_file
  autocmd BufWritePre *
        \ if exists('b:brand_new_file') |
        \   if getline(1) =~ '^#!' |
        \     let b:chmod_post = '+x' |
        \   endif |
        \ endif
  autocmd BufWritePost,FileWritePost * nested
        \ if exists('b:chmod_post') && executable('chmod') |
        \   silent! execute '!chmod '.b:chmod_post.' "<afile>"' |
        \   edit |
        \   unlet b:chmod_post |
        \ endif
augroup END

" vim:set sw=2 sts=2:
