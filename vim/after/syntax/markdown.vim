" Created:  Fri 12 Jun 2015
" Modified: Thu 09 Jul 2015
" Author:   Josh Wainwright
" Filename: markdown.vim

" Adds highlighting of text inside quotation marks

syntax sync fromstart
syn region markdownQuoted start="\S\@<=\"\|\"\S\@=" end="\S\@<=\"\|\"\S\@=" keepend contains=markdownLineStart
hi def link markdownQuoted String
