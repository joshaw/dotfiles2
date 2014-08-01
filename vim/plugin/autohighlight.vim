" Created:  Wed 30 Jul 2014 03:31 PM
" Modified: Thu 31 Jul 2014 11:24 AM

" Highlight all instances of word under cursor, when idle.
" Useful when studying strange source code.
" Type z/ to toggle highlighting on/off.
nnoremap z/ :if AutoHighlightToggle()<Bar>set hls<Bar>endif<CR>
function! AutoHighlightToggle()
  let @/ = ''
  if exists('#auto_highlight')
    au! auto_highlight
    augroup! auto_highlight
    setl updatetime=4000
    " match IncSearch //
    echo 'Highlight current word: off'
    return 0
  else
    augroup auto_highlight
      au!
      " au CursorHold * let @/ = '\V\<'.escape(expand('<cword>'), '\').'\>'
      au CursorHold * exe printf('match IncSearch /\V\<%s\>/', escape(expand('<cword>'), '/\'))
    augroup end
    setl updatetime=500
    echo 'Highlight current word: ON'
    return 1
  endif
endfunction
