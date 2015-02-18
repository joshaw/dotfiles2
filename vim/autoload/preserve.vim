" Created:  Wed 18 Feb 2015
" Modified: Wed 18 Feb 2015
" Author:   Josh Wainwright
" Filename: preserve.vim

" Allows an arbitrary command to be run on the file without changing the view
" on the file, or the position of the cursor.
function! preserve#Preserve(command)
  " Preparation: save last search, and cursor position.
  let _s=@/
  let w = winsaveview()
  " Do the business:
  execute a:command
  " Clean up: restore previous search history, and cursor position
  let @/=_s
  call winrestview(w)
endfunction
