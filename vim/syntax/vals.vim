" Created:  Sat 01 Aug 2015
" Modified: Mon 17 Aug 2015
" Author:   Josh Wainwright
" Filename: vals.vim

if version < 600
   syntax clear
elseif exists("b:current_syntax")
   finish
endif

if !exists("main_syntax")
   let main_syntax='vals'
endif

syn case ignore
syn sync fromstart

syn region ValsFlags start="\%^" matchgroup=ValsSect end="^999$" contains=Valscol1,Valscol2,ValscolN
syn region Valscol1 start="\%1c" end="\(\%4c\|$\)" contained oneline
syn region Valscol2 start="\%4c" end="\(\%15c\|$\)" contained oneline
syn region ValscolN start="\%15c" end="$" contained oneline

syn match ValsSect "^\d\+\*\+.*$"

syn region ValsKeywordsSect matchgroup=ValsSect start="^9\*\+.*$" end="^12\*\+.*" contains=ValsSect1,ValsKeywords1,ValsKeywords2,ValsKeywords3,ValsKeywords4
syn region ValsKeywords1 start="\%1c" end="\(\%7c\|$\)" contained oneline
syn region ValsKeywords2 start="\%7c" end="\(\%11c\|$\)" contained oneline
syn region ValsKeywords3 start="\%11c" end="\(\%15c\|$\)" contained oneline
syn match ValsKeywords4 "\%16c.\{-}\( \|$\)" contained
syn match ValsSect1 "^\d\+\*\+.*$" contained

syn match ValsTerminator "<<<< TERMINATOR >>>>" containedin=ALL

hi def link Valscol1 Number
hi def link Valscol2 Identifier
hi def link ValscolN Normal

hi def link ValsSect Delimiter
hi def link ValsSect1 Delimiter

hi def link ValsKeywords1 Macro
hi def link ValsKeywords2 Function
hi def link ValsKeywords3 Number
hi def link ValsKeywords4 Operator

hi def link ValsTerminator Delimiter
