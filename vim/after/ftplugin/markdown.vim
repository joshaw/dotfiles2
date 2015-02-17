" Created:  Wed 16 Apr 2014
" Modified: Tue 17 Feb 2015
" Author:   Josh Wainwright
" Filename: markdown.vim

exe 'setlocal dict+='.dictfile

"Automatic formating of paragraphs whenever text is inserted
setlocal formatoptions=tcqwan21

"Don't strip spaces and newlines when saving
let b:noStripWhitespace=1

setlocal makeprg=md.sh\ %

