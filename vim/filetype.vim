" Created:  Thu 07 Aug 2014
" Modified: Tue 02 Jun 2015
" Author:   Josh Wainwright
" Filename: filetype.vim

if exists("did_load_filetypes")
	finish
endif
augroup filetypedetect
	autocmd!
	autocmd! BufNewFile,BufRead *.dat,*.txt
				\ if search("^SERVER ", "n") > 0 && search("^VENDOR ", "n") > 0 |
				\     setfiletype flexlm |
				\ endif
	autocmd BufEnter,BufNew *.tex setf tex
	autocmd BufEnter,BufNew *.rout,*.Rout setf r
	autocmd BufEnter,BufNew *.md setf markdown
	autocmd BufEnter,BufNew README setf markdown
	autocmd BufEnter,BufNew *.book setf book
	autocmd BufEnter,BufNew *.bible setf book
	autocmd BufEnter,BufNew three-year.txt setf biblereading
	autocmd BufEnter,BufNew times.txt setf times.conf
	" Remove spaces at the end of header lines when starting new mail in mutt.
	autocmd BufEnter,BufNew /tmp/*/mutt* :1,/^$/s/\s\+$//
	autocmd BufEnter,BufNew *.mail setf mail
	autocmd BufEnter,BufNew *.tcf setf conf
	autocmd BufEnter,BufNew *.tct setf conf
	autocmd BufEnter,BufNew *.gnu setf gnuplot
augroup END

augroup filetypesettings
	autocmd!
	autocmd Filetype python setlocal expandtab
	"au FileType * exe 'setlocal dict+='.fnameescape($VIMRUNTIME).'/syntax/'.&filetype.'.vim'
	autocmd Filetype * exe 'setlocal dict+=$VIMHOME/spell/dicts/'.&filetype.'.dict'
	autocmd Filetype markdown syn match markdownOrderedListMarker "\%(\t\| \{0,4}\)\<\%(\d\+\|\a\)\.\%(\s\+\S\)\@=" contained
	autocmd Filetype netrw setlocal bufhidden=wipe
augroup END

augroup vimp
	autocmd!
	autocmd BufEnter pass.gpg setf mypass.conf
				\ | setlocal conceallevel=2
				\ | syntax region hideup Conceal start='|' end='$'
				\ | setlocal colorcolumn=0
augroup END
