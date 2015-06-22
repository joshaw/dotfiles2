" Created:  Mon 27 Apr 2015
" Modified: Mon 22 Jun 2015
" Author:   Josh Wainwright
" Filename: keybindings.vim

" Function Keys {{{1

map <F1> :<C-U>e ~/.dotfiles/bookmarks.md<cr>
map <F2> :<C-U>e ~/Documents/Details/times/times.txt<cr>

" Switch to display mode
nnoremap <silent> <F5> :<C-u>call display#Switch_display_mode()<CR>

" Save the current file and run the make program
map <F9>   :w <bar> make<cr><cr>
map <S-F9> :w <bar> silent make<cr>

" Edit weekly reports
nnoremap <F12> :EditReport<cr>
nnoremap <S-F12> :EditReport!<cr>

" Smart completion on tab {{{
function! Smart_TabComplete()
	if pumvisible()
		return "\<c-n>"
	endif
	let line = getline('.')
	let substr = strpart(line, -1, col('.'))
	let substr = matchstr(substr, "[^ \t]*$")
	if (strlen(substr)==0)
		return "\<tab>"
	endif
	let has_slash = match(substr, '\/\|\\') != -1
	if (has_slash)
		return "\<c-x>\<c-f>"
	else
		return "\<c-n>"
	endif
endfunction " }}}
inoremap <expr> <tab> Smart_TabComplete()
inoremap <s-tab> <c-p>

" Jump to file under cursor with cr, leader cr edits a non existing file
" Ensure quickfix and cmd windows still behave
nnoremap <cr> gf
nnoremap <leader><cr> :e <cfile><cr>
augroup vimrc_cr
	autocmd!
	autocmd CmdwinEnter * nnoremap <CR> <CR>
	autocmd BufReadPost quickfix nnoremap <CR> <CR>
augroup END

" Jump to start/end of file
nnoremap <s-home> gg
nnoremap <s-end> G

" Letters {{{1

" Change some options (Taken from unimpaired.vim - TPope)
nnoremap cow :set wrap!<CR>
nnoremap col :set list!<CR>
nnoremap coc :set cursorcolumn!<CR>
nnoremap cou :set cursorline!<CR>
nnoremap [<space> :-1 put _<cr>j
nnoremap ]<space> :put _<cr>k
nnoremap ]b :bnext<CR>
nnoremap [b :bprevious<CR>

" Re-indent whole file
nnoremap g+ :call Preserve("normal! gg=G")<CR>

" Align with easy align
xnoremap gl :Tabularize /

" Try using jk and kj as Escape in insert mode.
inoremap jk <Esc>
inoremap kj <Esc>

" Center search result
nnoremap n nzz
nnoremap N Nzz

xnoremap u <nop>
xnoremap gu u

" Jump to end of pasted text
xnoremap <silent> y y`]
xnoremap <silent> p p`]
nnoremap <silent> p p`]

" Auto_highlight
nnoremap z/ :if autohighlight#AutoHighlightToggle()<Bar>set hls<Bar>endif<CR>

" D and Y behave like C
nnoremap D dg_
nnoremap Y yg_

nnoremap Q :normal! n.<CR>

" Split lines, oposite of join, J
nnoremap S i<cr><esc>^mwgk:silent! s/\v +$//<cr>:noh<cr>`w

" Don't change case when meaning to undo in visual mode
" Symbols {{{1

nnoremap - :Dirvish %:p:h<cr>
nnoremap ; :
nnoremap , ;

" Search for selected text, forwards or backwards.
xnoremap <silent> * :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy/<C-R><C-R>=substitute(
  \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>N
xnoremap <silent> # :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy?<C-R><C-R>=substitute(
  \escape(@", '?\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>N

nnoremap * *N
nnoremap # #N

" Control Keys {{{1

nnoremap <silent> <C-Up>   :move-2<CR>
nnoremap <silent> <C-Down> :move+<CR>
xnoremap <silent> <C-Up>   :move-2<CR>gv
xnoremap <silent> <C-Down> :move'>+<CR>gv

" Replace selected text
xnoremap <C-r> "hy:%s/<C-r>h//g<left><left>

" Dmenu Open
if ! executable('dmenu')
	" map <c-t> :call DmenuOpen("tabe")<cr>
	noremap <c-f> :call dmenuOpen#DmenuOpen("e")<cr>
	noremap <c-b> :call dmenuOpen#DmenuOpen("e", 1)<cr>
endif

" Visual increment numbers
xnoremap <c-a> :call functions#BlockIncr(1)<cr>gv
xnoremap <c-x> :call functions#BlockIncr(-1)<cr>gv

" GrepString
nnoremap <c-g> :call functions#GrepString()<cr>:grep<space><space>.<left><left>

" Jump to start and end of line in insert mode
inoremap <C-a> <esc>I
inoremap <C-e> <esc>A
cnoremap <c-a> <home>
cnoremap <c-e> <end>

" Switch to other splits faster
nnoremap <c-l> <c-w>l
nnoremap <c-h> <c-w>h
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k

" Quick save and exit
inoremap <c-s> <c-O>:update<cr>
nnoremap <c-s> :update<cr>
nnoremap <c-Q> :q<cr>

"
" Leaders {{{1

" Insert current filename
inoremap <leader>fn <C-R>=expand("%:t")<CR>

" List all buffers and quickly switch to selected
nnoremap <leader>b :ls<CR>:buffer<Space>

nnoremap <leader>rc :e! $MYVIMRC<CR>:setlocal autochdir<cr>
nnoremap <leader>rd :e! $VIMHOME/plugin/display.vim<CR>
augroup vimrc_reload
	autocmd!
	autocmd BufWritePost $MYVIMRC source $MYVIMRC
				\ | echo "vimrc is sourced"
				\ | doautocmd colourscheme VimEnter %
augroup END

" Fast saving
nnoremap <leader>w :w!<cr>

" System clipboard copy and paste
nmap <leader>v "+gp
imap <leader>v <esc>"+gpa
nmap <leader>ay mhggVG"+y`hzz

" Unset highlighting of a search
nmap <silent> <leader>q :nohlsearch<CR><Plug>(clever-f-reset)

" Shift-leftmouse searches for the word clicked on without moving
nnoremap <S-LeftMouse> <LeftMouse>:<C-U>let @/='\<'.expand("<cword>").'\>'<CR>:set hlsearch<CR>

"           Scroll Wheel = Up/Down 4 lines
"   Shift + Scroll Wheel = Up/Down 1 page
" Control + Scroll Wheel = Up/Down 1/2 page
noremap  <ScrollWheelUp>    6<C-Y>
noremap  <ScrollWheelDown>  6<C-E>
noremap  <S-ScrollWheelUp>   <C-Y>
noremap  <S-ScrollWheelDown> <C-E>
noremap  <C-ScrollWheelUp>   <C-U>
noremap  <C-ScrollWheelDown> <C-D>
inoremap <ScrollWheelUp>     <C-O>4<C-Y>
inoremap <ScrollWheelDown>   <C-O>4<C-E>
inoremap <S-ScrollWheelUp>   <C-O><C-Y>
inoremap <S-ScrollWheelDown> <C-O><C-E>
inoremap <C-ScrollWheelUp>   <C-O><C-U>
inoremap <C-ScrollWheelDown> <C-O><C-D>
map      <MiddleMouse>       <LeftMouse>
imap     <MiddleMouse>       <LeftMouse>
map      <2-MiddleMouse>     <LeftMouse>
imap     <2-MiddleMouse>     <LeftMouse>
map      <3-MiddleMouse>     <LeftMouse>
imap     <3-MiddleMouse>     <LeftMouse>
map      <4-MiddleMouse>     <LeftMouse>
imap     <4-MiddleMouse>     <LeftMouse>

" Alt Keys {{{1

if has('nvim')
	tnoremap <A-h> <C-\><C-n><C-w>h
	tnoremap <A-j> <C-\><C-n><C-w>j
	tnoremap <A-k> <C-\><C-n><C-w>k
	tnoremap <A-l> <C-\><C-n><C-w>l
	nnoremap <A-h> <C-w>h
	nnoremap <A-j> <C-w>j
	nnoremap <A-k> <C-w>k
	nnoremap <A-l> <C-w>l
endif

" Increase and decrease font size in gui using Alt-Up and Alt-Down
nnoremap <A-Up> :silent! let &guifont = substitute(
 \ &guifont,
 \ ':h\zs\d\+',
 \ '\=eval(submatch(0)+1)',
 \ '')<CR><CR>
nnoremap <A-Down> :silent! let &guifont = substitute(
 \ &guifont,
 \ ':h\zs\d\+',
 \ '\=eval(submatch(0)-1)',
 \ '')<CR><CR>
