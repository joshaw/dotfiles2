" Created:  Tue 25 Aug 2015
" Modified: Tue 25 Aug 2015
" Author:   Josh Wainwright
" Filename: navd.vim

let s:sep = has("win32") ? '\' : '/'
let g:navd = {}

function! s:sort_paths(p1, p2)
  let isdir1 = (a:p1[-1:] ==# s:sep) "3x faster than isdirectory().
  let isdir2 = (a:p2[-1:] ==# s:sep)
  if isdir1 && !isdir2
	return -1
  elseif !isdir1 && isdir2
	return 1
  endif
  return a:p1 ==# a:p2 ? 0 : a:p1 ># a:p2 ? 1 : -1
endfunction

function! s:get_paths(path, inc_hidden)
	let l:paths = glob(a:path.'/*', 1, 1)
	if a:inc_hidden == 1
		let l:hidden = glob(a:path.'/.*', 1, 1)
		if len(l:hidden) > 2
			let l:hidden = remove(l:hidden, 2, -1)
		else
			let l:hidden = []
		endif
		let l:paths = extend(l:paths, l:hidden)
	endif
	return sort(map(l:paths, "fnamemodify(v:val, ':p')"), '<sid>sort_paths')
endfunction

function! s:norm_path(path)
	let sep = escape(s:sep, '/\')
	let ret = substitute(a:path, sep.'\{2,}', s:sep, 'g')
	let ret = ret[-1:] ==# s:sep ? ret : ret.s:sep
	return ret
endfunction

function! s:new_obj()
	let new_name = input('Name: ')
	redraw
	if new_name[-1:] =~# '[/\\]'
		if !isdirectory(g:navd.cur.'/'.new_name)
			if !mkdir(g:navd.cur.'/'.new_name)
				echoerr "Failed to create file: ".new_name
				return
			endif
			let paths = s:get_paths(g:navd.cur, 1)
			call s:setup_navd_buf(paths)
		else
			echo "Directory already exists: ".new_name
		endif
	else
		exe 'edit '.g:navd.cur.new_name
	endif
	call cursor(1,1)
	call search(new_name, 'cW')
endfunction

function! s:toggle_hidden()
	let hid = !g:navd.hidden
	call s:display_paths(g:navd.cur, hid)
endfunction

function! s:setup_navd_buf(paths)
	if &filetype !=# 'navd'
		silent! edit __Navd__
		setlocal concealcursor=nc conceallevel=3
		setlocal filetype=navd
		setlocal bufhidden=hide undolevels=-1 nobuflisted
		setlocal buftype=nofile noswapfile nowrap nolist cursorline
		nnoremap <silent> <buffer> - :Navd <parent><cr>
		nnoremap <silent> <buffer> <cr> :call <SID>enter_handle()<cr>
		nnoremap <silent> <buffer> R :call <SID>display_paths(g:navd.cur, g:navd.hidden)<cr>
		nnoremap <silent> <buffer> gh :call <SID>toggle_hidden()<cr>
		nnoremap <silent> <buffer> <c-o> :keepjumps Navd <parent><cr>
		nnoremap <silent> <buffer> + :call <SID>new_obj()<cr>
		let sep = escape(s:sep, '/\')
		exe 'syntax match NavdPathHead ''\v.*'.sep.'\ze[^'.sep.']+'.sep.'?$'' conceal'
		exe 'syntax match NavdPathTail ''\v[^'.sep.']+'.sep.'$'''
		highlight! link NavdPathTail Directory
	endif

	setlocal modifiable
	silent %delete _
	call append(0, a:paths)
	$delete _
	silent! %s/\([/\\]\)\{2,}/\1/g
	setlocal nomodifiable
endfunction

function! s:enter_handle()
	let cur_line = getline('.')
	if isdirectory(cur_line)
		exe 'Navd' cur_line
	elseif filereadable(cur_line)
		exe 'edit' fnameescape(cur_line)
	endif
endfunction

function! s:display_paths(path, hidden)
	let g:navd.prev = has_key(g:navd, 'cur') ? g:navd.cur : ''
	let g:navd.hidden = a:hidden

	if a:path ==# ''
		let target_fname = expand('%:t')
		let target_path = expand('%:p:h')
	elseif a:path ==# '<parent>'
		let target_fname = g:navd.prev
		let target_path = fnamemodify(g:navd.cur, ':p:h:h')
	else
		let target_fname = g:navd.prev
		let target_path = a:path
	endif
	let target_path = s:norm_path(target_path)
	let g:navd.cur = target_path

	let paths = s:get_paths(target_path, a:hidden)
	call s:setup_navd_buf(paths)

	call cursor(1,1)
	if target_fname !=# ''
		if search(target_fname, 'cW') <= 0
			call search(target_path, 'cW')
		endif
	elseif has_key(g:navd, 'prev') && g:navd.prev !=# ''
		call search(g:navd.prev, 'cW')
	endif
endfunction

function! navd#navd(path, hidden)
	call s:display_paths(a:path, a:hidden)
endfunction
