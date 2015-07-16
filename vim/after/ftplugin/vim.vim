" Created:  Tue 14 Jul 2015
" Modified: Tue 14 Jul 2015
" Author:   Josh Wainwright
" Filename: vim.vim

nnoremap <F10> :w<bar>source %<cr>

Snip function function! <esc>oendfunction<esc>kA
Snip if if <esc>oendif<esc>kA
Snip ife if <esc>oelse <esc>oendif<esc>2kA
Snip while while <esc>oendwhile<esc>kA
Snip for for <esc>oendfor<esc>kA
Snip augroup augroup <esc>o	au!<esc>o<c-u>augroup END<esc>2kA
