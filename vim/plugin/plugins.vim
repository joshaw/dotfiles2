" Created:  Sun 26 Apr 2015
" Modified: Tue 04 Aug 2015
" Author:   Josh Wainwright
" Filename: plugins.vim

"
" BookReformatCmd
command! BookReformatCmd call booksreformat#BookReformatCmd()

"
" Timestamp
autocmd! BufRead * :call timestamp#Timestamp()

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
command! -nargs=0 ReadingMode call display#Reading_mode_toggle()
command! -nargs=0 DisplayMode call display#Display_mode_toggle()
augroup DisplayMode
	autocmd VimEnter * call display#Display_mode_start()
augroup END

"
" Super Retab
command! -nargs=? -range=% Space2Tab call super_retab#IndentConvert(<line1>,<line2>,0,<q-args>)
command! -nargs=? -range=% Tab2Space call super_retab#IndentConvert(<line1>,<line2>,1,<q-args>)
command! -nargs=? -range=% RetabIndent call super_retab#IndentConvert(<line1>,<line2>,&et,<q-args>)

"
" Weekly Report
command! -nargs=* -bang EditReport :call weeklyr#EditReport('<bang>' == '!', 0, <f-args>)

"
" DiffOrig
" View the difference between the buffer and the file the last time it was saved
command! DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis | wincmd p | diffthis

"
" BufGrep
command! -nargs=1 BufGrep :call functions#BufGrep(<f-args>)

"
" Sum
command! -range -nargs=0 -bar Sum call functions#Sum()

"
" Verbose
command! -range=999998 -nargs=1 -complete=command Verbose
      \ :exe functions#Verbose(<count> == 999998 ? '' : <count>, <q-args>)

"
" Oldfiles
command! -nargs=0 Oldfiles :call functions#Oldfiles()

"
" IPtables
command! IPtablesSort :call functions#IPtablesSort()

"
" FirstTimeRun
command! FirstTimeRun :call functions#FirstTimeRun()

"
" Surroundings
nnoremap <silent> ys :call surroundings#surroundings(0)<cr>
xnoremap <silent> S :call surroundings#surroundings(visualmode() ==# 'v'? 1: 2)<cr>

"
" Nroff formatting of html files
command! -nargs=? Html2Nroff :call functions#html2nroff(<args>)
