" Created:  Wed 30 Jul 2014 03:31 PM
" Modified: Mon 27 Apr 2015 08:57 AM

" Highlight all instances of word under cursor, when idle.
" Useful when studying strange source code.
" Type z/ to toggle highlighting on/off.
function! autohighlight#AutoHighlightToggle()
  let @/ = ''
  if exists('#auto_highlight')
    au! auto_highlight
    augroup! auto_highlight
    setl updatetime=4000
    match IncSearch //
    echo 'Highlight current word: OFF'
    return 0
  else
    augroup auto_highlight
      au!
      " au CursorHold * let @/ = '\V\<'.escape(expand('<cword>'), '\').'\>'
      au CursorHold * exe printf('match Search /\V\<%s\>/', escape(expand('<cword>'), '/\'))
    augroup end
    setl updatetime=500
    echo 'Highlight current word: ON'
    return 1
  endif
endfunction
