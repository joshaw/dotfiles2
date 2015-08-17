" Created:  Sat 01 Aug 2015
" Modified: Sat 01 Aug 2015
" Author:   Josh Wainwright
" Filename: tbend.vim

if version < 600
   syntax clear
elseif exists("b:current_syntax")
   finish
endif

" we define it here so that included files can test for it
if !exists("main_syntax")
   let main_syntax='tbend'
endif

syn sync fromstart

syn match TbendFlagDesc "^[0-9TF]\s\+\S.*$" contains=TbendDesc,TbendFlag
syn match TbendDesc "\s\+\S.*$" contained
syn match TbendFlag "^[0-9TF]\s" contained nextgroup=TbendDesc

syn match TbendValDesc "^\s\+[0-9-]\+\s\+\S.*$" contains=TbendVal
syn match TbendVal "^\s\+[0-9-]\+" contained

syn region TbendLexVal matchgroup=TbendTerminator start="^\s\+LEX\s\+VAL.*" end="^\s\+0\s\+0" contains=TbendLLex,TbendLVal,TbendLOp
syn match TbendLNorm "\s\+.*$" contained
syn match TbendLOp  "\s\+\S\+" contained nextgroup=TbendLNorm
syn match TbendLVal "\s\+\d" contained nextgroup=TbendLOp
syn match TbendLLex "^\s\+\d\+" contained nextgroup=TbendLVal

syn match TbendTerminator "^.*TERMINATOR.*"
syn match TbendTerminator "^.*<.*>"
syn match TbendComment "^[CA]\s\+.*"

syn region TbendLibProc matchgroup=TbendComment start="^A.*PRCTRE.*$" matchgroup=TbendTerminator end="^.*TERMINATOR.*" contains=TbendLP1,TbendLP2,TbendLP3
syn region TbendLP1 start="^" end="\%7c" contained
syn region TbendLP2 start="\%7c" end="\%21c" contained
syn region TbendLP3 start="\%21c" end="$" contained

hi def link TbendFlag Boolean
hi def link TbendDesc String

hi def link TbendVal Identifier

hi def link TbendLLex Identifier
hi def link TbendLVal Number
hi def link TbendLOp  Operator
hi def link TbendLNorm Normal

hi def link TbendLP1 Identifier
hi def link TbendLP2 Typedef
hi def link TbendLP3 Function

hi def link TbendTerminator Delimiter
hi def link TbendComment Comment
