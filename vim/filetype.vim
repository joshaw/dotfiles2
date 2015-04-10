if exists("did_load_filetypes")
	finish
endif
augroup filetypedetect
	" au! commands to set the filetype go here
	autocmd!

	autocmd! BufNewFile,BufRead *.dat,*.txt
				\ if search("^SERVER ", "n") > 0 && search("^VENDOR ", "n") > 0 |
				\     setfiletype flexlm |
				\ endif

	"au FileType * exe 'setlocal dict+='.fnameescape($VIMRUNTIME).'/syntax/'.&filetype.'.vim'
	au Filetype * exe 'setlocal dict+=$VIMHOME/spell/dicts/'.&filetype.'.dict'
	autocmd BufEnter,BufNew *.tex setlocal ft=tex
	autocmd BufEnter,BufNew *.rout,*.Rout setlocal ft=r
	autocmd BufEnter,BufNew *.md setlocal ft=markdown
	autocmd BufEnter,BufNew README setlocal ft=markdown
	autocmd Filetype markdown syn match markdownOrderedListMarker "\%(\t\| \{0,4}\)\<\%(\d\+\|\a\)\.\%(\s\+\S\)\@=" contained
	autocmd BufEnter,BufNew *.book setlocal ft=book
	autocmd BufEnter,BufNew *.bible setlocal ft=book
	autocmd BufEnter,BufNew three-year.txt setlocal ft=biblereading
	autocmd BufEnter,BufNew times.txt setlocal ft=times.conf
	" Remove spaces at the end of header lines when starting new mail in mutt.
	autocmd BufReadPost /tmp/*/mutt* :1,/^$/s/\s\+$//
	autocmd BufNewFile,BufRead *.mail setlocal filetype=mail
	autocmd Filetype netrw setlocal bufhidden=wipe

augroup END
