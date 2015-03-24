if exists("did_load_filetypes")
  finish
endif
augroup filetypedetect
  " au! commands to set the filetype go here
autocmd! BufNewFile,BufRead *.dat,*.txt
    \ if search("^SERVER ", "n") > 0 && search("^VENDOR ", "n") > 0 |
    \     setfiletype flexlm |
    \ endif

augroup END
