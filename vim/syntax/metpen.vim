" Created:  Sat 01 Aug 2015
" Modified: Sat 01 Aug 2015
" Author:   Josh Wainwright
" Filename: metpen.vim

if version < 600
   syntax clear
elseif exists("b:current_syntax")
   finish
endif

" we define it here so that included files can test for it
if !exists("main_syntax")
   let main_syntax='metpen'
endif

syn region MetpenDesc start=+"+ end=+"+ end="$"
syn match MetpenMax   "\s\+[0-9c.]\+" nextgroup=MetpenMin,MetpenDesc
syn match MetpenMin   "\s\+[0-9c.]\+" nextgroup=MetpenMax
syn match MetpenType  "\s\+[ri]" nextgroup=MetpenMin
syn match MetpenScope "\s\+[SFPC]" nextgroup=MetpenScope
syn match MetpenID    "\s\+[0-9-]\+" nextgroup=MetpenScope
syn match MetpenOnOff "^\s\+[01]" nextgroup=MetpenID
syn match MetpenComment "^#.*"

hi def link MetpenOnOff Number
hi def link MetpenID Function
hi def link MetpenScope Question
hi def link MetpenType Identifier
hi def link MetpenMin Number
hi def link MetpenMax Title
hi def link MetpenDesc String
hi def link MetpenComment Comment
