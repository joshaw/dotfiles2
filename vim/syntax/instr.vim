" Created:  TIMESTAMP
" Modified: TIMESTAMP
" Author:   Josh Wainwright
" Filename: instr.vim

if version < 600
   syntax clear
elseif exists("b:current_syntax")
   finish
endif

" we define it here so that included files can test for it
if !exists("main_syntax")
   let main_syntax='instr'
endif

syn sync fromstart

syn include @C syntax/c.vim

syn region InstrSec0 start="\%^" matchgroup=InstrSecDiv end="^\*\+1.*$"he=s-1,re=s-1 contains=Valscol1,Valscol2,ValscolN
syn region Valscol1 start="\%1c" end="\(\%4c\|$\)" contained oneline
syn region Valscol2 start="\%4c" end="\(\%9c\|$\)" contained oneline
syn region ValscolN start="\%9c" end="$" contained oneline

syn region InstrSec1 matchgroup=InstrSecDiv start="^\*\+1.*$" end="^\*\+2.*$"he=s-1,re=s-1
syn region InstrSec2 matchgroup=InstrSecDiv start="^\*\+2.*$" end="^\*\+3.*$"he=s-1,re=s-1
syn region InstrSec3 matchgroup=InstrSecDiv start="^\*\+3.*$" end="^\*\+4.*$"he=s-1,re=s-1

syn region InstrSec4 matchgroup=InstrSecDiv start="^\*\+4.*$" end="^\*\+5.*$"he=s-1,re=s-1 contains=@C
syn region InstrSec5 matchgroup=InstrSecDiv start="^\*\+5.*$" end="^\*\+6.*$"he=s-1,re=s-1 contains=@C
syn region InstrSec6 matchgroup=InstrSecDiv start="^\*\+6.*$" end="^\*\+7.*$"he=s-1,re=s-1 contains=@C
syn region InstrSec7 matchgroup=InstrSecDiv start="^\*\+7.*$" end="^\*\+8.*$" contains=@C

hi def link InstrSecDiv StatusLine
hi def link Valscol1 Number
hi def link Valscol2 Identifier
hi def link ValscolN Normal

hi def link InstrSec1 Number
hi def link InstrSec2 Identifier
hi def link InstrSec3 Label
