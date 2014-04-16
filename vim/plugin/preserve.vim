" Allows an arbitrary command to be run on the file without changing the view
" on the file, or the position of the cursor.
function! Preserve(command)
  " Preparation: save last search, and cursor position.
  " let _s=@/
  " let l = line(".")
  " let c = col(".")
  let w = winsaveview()
  " Do the business:
  execute a:command
  " Clean up: restore previous search history, and cursor position
  " let @/=_s
  " call cursor(l, c)
  call winrestview(w)
endfunction
