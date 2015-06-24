" Created:  Fri 12 Jun 2015
" Modified: Wed 24 Jun 2015
" Author:   Josh Wainwright
" Filename: markdown.vim

syntax sync fromstart
syn region markdownQuoted start="\S\@<=\"\|\"\S\@=" end="\S\@<=\"\|\"\S\@=" keepend contains=markdownLineStart
hi def link markdownQuoted String
