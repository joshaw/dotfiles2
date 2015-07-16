" Created:  Thu 07 Aug 2014
" Modified: Tue 14 Jul 2015
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
	autocmd BufRead,BufNewFile *.tex setf tex
	autocmd BufRead,BufNewFile *.rout,*.Rout setf r
	autocmd BufRead,BufNewFile *.md setf markdown
	autocmd BufRead,BufNewFile README setf markdown
	autocmd BufRead,BufNewFile *.bible setf bible
	autocmd BufRead,BufNewFile three-year.txt setf biblereading
	autocmd BufRead,BufNewFile times.txt setf times.conf
	" Remove spaces at the end of header lines when starting new mail in mutt.
	autocmd BufRead,BufNewFile /tmp/*/mutt* :1,/^$/s/\s\+$//
	autocmd BufRead,BufNewFile *.mail setf mail
	autocmd BufRead,BufNewFile *.tcf setf conf
	autocmd BufRead,BufNewFile *.tct setf conf
	autocmd BufRead,BufNewFile *.gnu setf gnuplot
	autocmd BufRead,BufNewFile *.cmm set filetype=practice
augroup END

augroup filetypesettings
	autocmd!
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
