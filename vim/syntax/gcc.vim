" Created:  Mon 22 Jun 2015
" Modified: Mon 22 Jun 2015
" Author:   Josh Wainwright
" Filename: gcc.vim
" syntax coloring for make output

syn match cMLogConfig "^[^/\\]\{-}: "

syn match cMLogMissing  "[\./a-zA-Z0-9_]\+\.[a-zA-Z_]\+: No such .*$"
syn match cMLogMissing  "undefined reference to .*$"
syn match cMLogSource   "[\./a-zA-Z0-9_]\+\.[hHcCiIsS][pPxXnN]\?[lp]\?\(:\d\+\)\+:"
syn match cMLogCurDir   "Entering directory .*$"

syn match cMLogWarn "\<[wW]arning:.*$"
syn match cMLogErr  "error:.*$"
syn match cMLogErr  "No such .*$"

hi link cMLogConfig  Title
hi link cMLogWarn    Label
hi link cMLogErr     ErrorMsg
hi link cMLogSource  Special
hi link cMLogCurDir  SpecialComment
hi link cMLogMissing ErrorMsg
