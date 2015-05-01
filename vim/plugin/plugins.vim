" Created:  Sun 26 Apr 2015
" Modified: Mon 27 Apr 2015
" Author:   Josh Wainwright
" Filename: plugins.vim

"
" BookReformatCmd
command! BookReformatCmd call booksreformat#BookReformatCmd()

"
" Timestamp
autocmd! BufWritePre * :call timestamp#Timestamp()

"
"Whitespace
command! -range=% -nargs=0 StripTrailing :call whitespace#StripTrailing(<line1>,<line2>)
command! -nargs=0 TrimEndLines :call whitespace#TrimEndLines()

" Auto remove when saving
if $USERNAME != "JoshWainwright"
	augroup Clean
		autocmd!
		autocmd BufWritePre * StripTrailing
		autocmd BufWritePre * TrimEndLines
	augroup END
endif

"
" DisplayMode
augroup DisplayMode
	autocmd VimEnter * call display#Display_mode_start()
augroup END

nnoremap <silent> <F5> :<C-u>call display#Switch_display_mode()<CR>

"
" Super Retab
command! -nargs=? -range=% Space2Tab call super_retab#IndentConvert(<line1>,<line2>,0,<q-args>)
command! -nargs=? -range=% Tab2Space call super_retab#IndentConvert(<line1>,<line2>,1,<q-args>)
command! -nargs=? -range=% RetabIndent call super_retab#IndentConvert(<line1>,<line2>,&et,<q-args>)

"
" Dmenu Open
if ! executable('dmenu')
	" map <c-t> :call DmenuOpen("tabe")<cr>
	noremap <c-f> :call dmenuOpen#DmenuOpen("e")<cr>
	noremap <c-b> :call dmenuOpen#DmenuOpen("e", 1)<cr>
endif

"
" Weekly Report
command! -nargs=* -bang EditReport :call weeklyr#EditReport('<bang>' == '!', 0, <f-args>)
nnoremap <F12> :EditReport<cr>
nnoremap <S-F12> :EditReport!<cr>

"
" Auto_highlight
nnoremap z/ :if autohighlight#AutoHighlightToggle()<Bar>set hls<Bar>endif<CR>

"
" DiffOrig
" View the difference between the buffer and the file the last time it was saved
command! DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis | wincmd p | diffthis

"
" BufGrep
command! -nargs=1 BufGrep :call functions#BufGrep(<f-args>)

"
" Sum
command! -range -nargs=0 -bar Sum call function#Sum()

"
" Verbose
command! -range=999998 -nargs=1 -complete=command Verbose
      \ :exe functions#Verbose(<count> == 999998 ? '' : <count>, <q-args>)

"
" Oldfiles
command! -nargs=0 Oldfiles :call functions#Oldfiles()
