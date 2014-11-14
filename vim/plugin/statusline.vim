set ls=2 " Always show status line
let g:last_mode=""

let g:cfg=synIDattr(hlID("StatusLine"), 'bg#')
let g:cbg=synIDattr(hlID("StatusLine"), 'fg#')

" Black on Green
let g:status_normal   = 'guifg=#000000 guibg=#7dcc7d ctermfg=0 ctermbg=2'
" White on Red
let g:status_insert   = 'guifg=#ffffff guibg=#ff0000 ctermfg=15 ctermbg=9'
" Yellow on Blue
let g:status_replace  = 'guifg=#ffff00 guibg=#5b7fbb ctermfg=190 ctermbg=67'
" White on Purple
let g:status_visual   = 'guifg=#ffffff guibg=#810085 ctermfg=15 ctermbg=53'
" White on Pink
let g:status_modified = 'guifg=#ffffff guibg=#ff00ff ctermfg=15 ctermbg=5'
" White on Black
let g:status_position = 'guifg=#cc6633 ctermfg=15'
" Pink on Black
let g:status_line     = 'guifg=#ff00ff guibg=#383830 ctermfg=207'
" Black on Cyan
let g:status_lines    = 'guifg=#cc6633 guibg=#383830 ctermfg=15'

let g:status_separator = '|'
" 383830 Dark Grey
" a59f85 Light Grey
" cc6633 Orange
" f92672
" fd971f
" 383830
" Set up the colors for the status bar
function! SetNeatstatusColorscheme()

    " Basic color presets
    exec 'hi User1 '.g:status_normal
    exec 'hi User2 '.g:status_replace
    exec 'hi User3 '.g:status_insert
    exec 'hi User4 '.g:status_visual
    exec 'hi User5 '.g:status_position
    exec 'hi User6 '.g:status_modified
    exec 'hi User7 '.g:status_line
    exec 'hi User8 '.g:status_lines

endfunc

" pretty mode display - converts the one letter status notifiers to words
function! Mode()
    redraw
    let l:mode = mode()

    if     mode ==# "n"  | exec 'hi User1 '.g:status_normal  | return "NORMAL"
    elseif mode ==# "i"  | exec 'hi User1 '.g:status_insert  | return "INSERT"
    elseif mode ==# "R"  | exec 'hi User1 '.g:status_replace | return "REPLACE"
    elseif mode ==# "v"  | exec 'hi User1 '.g:status_visual  | return "VISUAL"
    elseif mode ==# "V"  | exec 'hi User1 '.g:status_visual  | return "V-LINE"
    elseif mode ==# "" | exec 'hi User1 '.g:status_visual  | return "V-BLOCK"
    else                 | return l:mode
    endif
endfunc

if has('statusline')
    call SetNeatstatusColorscheme()

    " Status line detail:
    " -------------------
    "
    " %f    file name
    " %F    file path
    " %y    file type between braces (if defined)
    " %{v:servername}   server/session name (gvim only)
    " %<    collapse to the left if window is to small
    " %( %) display contents only if not empty
    " %1*   use color preset User1 from this point on (use %0* to reset)
    " %([%R%M]%)   read-only, modified and modifiable flags between braces
    " %{'!'[&ff=='default_file_format']}
    "        shows a '!' if the file format is not the platform default
    " %{'$'[!&list]}  shows a '*' if in list mode
    " %{'~'[&pm=='']} shows a '~' if in patchmode
    " %=     right-align following items
    " %{&fileencoding}  displays encoding (like utf8)
    " %{&fileformat}    displays file format (unix, dos, etc..)
    " %{&filetype}      displays file type (vim, python, etc..)
    " #%n   buffer number
    " %l/%L line number, total number of lines
    " %p%   percentage of file
    " %c%V  column number, absolute column number
    " &modified         whether or not file was modified
    " %-5.x - syntax to add 5 chars of padding to some element x
    "
    function! SetStatusLineStyle()

        let &stl=""
        " buffer number
        let &stl.="%1*%n%0*"
        " mode (changes color)
        let &stl.="%1*\ %{Mode()} %0*"
        " file path
        let &stl.=" %<%F "
        " read only, modified, modifiable flags in brackets
        let &stl.="%([%R%M]%) "

        " right-aligh everything past this point
        let &stl.="%= "

        " modified / unmodified
        let &stl.="%(%6* %{&modified ? 'modified':''} %)%0*"
        " spell check flag
        let &stl.="%(%{(&spell!=0?'[s]':'')} %)"
        " binary flag
        let &stl.="%(%{(&bin!=0?'[b]':'')} %)"
        " readonly flag
        let &stl.="%(%{(&ro!=0?'[ro]':'')} ".g:status_separator."%)"
        " file type
        let &stl.="%( %{&filetype} ".g:status_separator." %)"
        " file format
        let &stl.="%{&fileformat}, "
        " file encoding
        let &stl.="%(%{(&fenc!=''?&fenc:&enc)} ".g:status_separator."%)"
        " column number
        let &stl.="%3.c : "
        "line number / total lines
        let &stl.="%4.l/%-4.L\ "
        " percentage done
        let &stl.="%-3.p%% "

    endfunc

    " whenever the color scheme changes re-apply the colors
    au ColorScheme * call SetNeatstatusColorscheme()

    " Make sure the statusbar is reloaded late to pick up servername
    au ColorScheme,VimEnter * call SetStatusLineStyle()

endif

augroup Mode
    au!
    au InsertEnter * :call SetStatusLineStyle()
    au InsertLeave * :call SetStatusLineStyle()
augroup END
