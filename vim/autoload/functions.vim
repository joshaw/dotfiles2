" Created:  Mon 12 Jan 2015
" Modified: Fri 01 May 2015
" Author:   Josh Wainwright
" Filename: functions.vim

" GrepString {{{1
" Set the grepprg depending on context
function! functions#GrepString()
	if exists("b:git_dir") && b:git_dir != ''
		setlocal grepprg=git\ --no-pager\ grep\ -H\ -n\ --no-color\ --ignore-case
	elseif executable('ag')
		setlocal grepprg=ag\ --vimgrep\ --smart-case
	elseif executable('ack')
		setlocal grepprg=ack\ -H\ --nogroup\ --nocolor\ --smart-case
	else
		setlocal grepprg=grep\ --dereference-recursive\ --ignore-case\ --line-number\ --with-filename\ $*
	endif
endfunction

" BufGrep {{{1
" Search and Replace through all buffers
function! functions#BufGrep(search)
	echo a:search
	cclose
	call setqflist([])
	silent! exe "bufdo vimgrepadd " . a:search . " %"
	copen
endfunction

" Sum {{{1
" Sum a visual selection of numbers
function! functions#Sum() range
	let s:reg_save = getreg('"')
	let s:regtype_save = getregtype('"')
	let s:cb_save = &clipboard
	set clipboard&
	silent! normal! ""gvy
	let s:selection = getreg('"')
	call setreg('"', s:reg_save, s:regtype_save)
	let &clipboard = s:cb_save

	let s:sum = 0
	for s:n in split(s:selection)
		let s:n = substitute(s:n, '\v[^0-9]*\ze([0-9]|$)', '', "")
		if s:n == ''
			continue
		endif
		echo '[ ' . s:n . ' ]'
		let s:sum = s:sum + str2float(s:n)
	endfor
	echo "sum: " . string(s:sum)
	call append(line("'>"), string(s:sum))
endfunction

" BlockIncr {{{1
" Increment a blockwise selection
function! functions#BlockIncr(num) range
	let l:old = @/
	try
		'<,'>s/\v%V-?\d+/\=(submatch(0) + a:num)/
		call histdel('/', -1)
	catch /E486/
	endtry

	let @/ = l:old
endfunction

" Verbose {{{1
function! functions#Verbose(level, excmd)
  let temp = tempname()
  let verbosefile = &verbosefile
  call writefile([':'.a:level.'Verbose '.a:excmd], temp, 'b')
  return
        \ 'try|' .
        \ 'let &verbosefile = '.string(temp).'|' .
        \ 'silent '.a:level.'verbose exe '.string(a:excmd).'|' .
        \ 'finally|' .
        \ 'let &verbosefile = '.string(verbosefile).'|' .
        \ 'endtry|' .
        \ 'pedit '.temp.'|wincmd P|nnoremap <buffer> q :bd<CR>'
endfunction

" Oldfiles {{{1
function! functions#Oldfiles()
	Verbose oldfiles
	0delete _
	silent %s/\v\d+: //
	setlocal nobuflisted
	setlocal buftype=nofile
	setlocal bufhidden=delete
	setlocal noswapfile
	setlocal nomodifiable
	normal gg
	nnoremap <buffer> <cr> :let f=expand('<cfile>') \| pclose \| exe 'e 'f<cr>
endfunction

" iptables {{{1
function! functions#Iptables()
	silent setlocal filetype=sh
	silent! %s/\v(.*: )(.* times?)/\2  \1/
	silent! %s/: \?$//
	silent! %s/ (.*$//
	silent! %s/times\? *//
	silent! %sort! n
	while line('$') > 1
		let s:lastnum = substitute(getline('$'), " .*$", "", "")
		if s:lastnum < 15
			$delete _
		else
			break
		endif
	endwhile
	silent! %s/\v^(\d+) (.*)$/\2 #\1/
	silent! %s#^#/sbin/iptables -I INPUT [] -s #
	silent! %s/\v (#\d+)$/ -j DROP \1/
endfunction
