function! EnableImprovedCommandLine()
  nnoremap <silent> ; :let g:improved_command_line = 1<cr>q:i
endfunction

function! DisableImprovedCommandLine()
  nunmap :
endfunction

function! SetupImprovedCommandLine()
  if exists('g:improved_command_line')
    set laststatus=0
    inoremap <buffer> <silent> <esc> <esc>:q<cr>
  else
    call DisableImprovedCommandLine()
  endif
endfunction

function! TeardownImprovedCommandLine()
  if exists('g:improved_command_line')
    set laststatus=2
    iunmap <buffer> <esc>
    unlet g:improved_command_line
  else
    call EnableImprovedCommandLine()
  endif
endfunction

au CmdwinEnter * call SetupImprovedCommandLine()
au CmdwinLeave * call TeardownImprovedCommandLine()
call EnableImprovedCommandLine()
