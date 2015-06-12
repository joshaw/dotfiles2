" Vim syntax file
" Language: Trace32 script
" Maintainer: Matthias Bilger <matthias@bilger.info>
" URL: http://github.com/m42e/trace32-practice.vim
" Credits: Based on the trace.vim syntax file by Stefan Liebl
" Last change: 2014 April 17

if version < 600
   syntax clear
elseif exists("b:current_syntax")
   finish
endif

" we define it here so that included files can test for it
if !exists("main_syntax")
   let main_syntax='practice'
endif

" ignore case
syn case ignore

" keyword definitions
syn keyword practiceConditional if then
syn keyword practiceRepeat repeat

" practice commands
syn match practiceCommand '\<\w\+\(\.\w\+\)*\>' transparent contains=practiceFlashCommand,practiceDataCommand,practiceGlobalCommand,practiceWinpageCommand,practiceAreaCommand,practicePrintCommand,practiceEntryCommand,practiceWaitCommand,practiceChdirCommand,practiceEnddoCommand,practiceOsCommand,practiceDoCommand,practiceStringCommand,practiceGotoCommand,practiceSystemCommand,practiceRegisterCommand

" practice commands
syn match practiceFlashCommand '\<\(flash\|f\)\>\.' contained nextgroup=practiceFlashResetCommand,practiceFlashCreateCommand,practiceFlashTargetCommand,practiceFlashEraseCommand,practiceFlashProgramCommand
hi link practiceFlashCommand practiceCommand
syn match practiceDataCommand '\<\(data\|d\)\>\.' contained nextgroup=practiceDataLoadCommand,practiceDataSetCommand
hi link practiceDataCommand practiceCommand
syn match practiceGlobalCommand '\<\(global\)\>' contained
hi link practiceGlobalCommand practiceCommand
syn match practiceWinpageCommand '\<\(winpage\)\>\.' contained nextgroup=practiceWinpageResetCommand,practiceWinpageCreateCommand,practiceWinpageSelectCommand
hi link practiceWinpageCommand practiceCommand
syn match practiceAreaCommand '\<\(area\)\>\.' contained nextgroup=practiceAreaResetCommand,practiceAreaCreateCommand,practiceAreaSelectCommand,practiceAreaViewCommand
hi link practiceAreaCommand practiceCommand
syn match practicePrintCommand '\<\(print\)\>' contained
hi link practicePrintCommand practiceCommand
syn match practiceEntryCommand '\<\(entry\)\>' contained
hi link practiceEntryCommand practiceCommand
syn match practiceWaitCommand '\<\(wait\)\>' contained
hi link practiceWaitCommand practiceCommand
syn match practiceChdirCommand '\<\(chdir\)\.\?\>' contained nextgroup=practiceChdirDoCommand
hi link practiceChdirCommand practiceCommand
syn match practiceEnddoCommand '\<\(enddo\)\>' contained
hi link practiceEnddoCommand practiceCommand
syn match practiceOsCommand '\<\(os\)\>\.' contained nextgroup=practiceOsPsdCommand,practiceOsPtdCommand,practiceOsEnvCommand,practiceOsFileCommand
hi link practiceOsCommand practiceCommand
syn match practiceDoCommand '\<\(do\)\>' contained
hi link practiceDoCommand practiceCommand
syn match practiceStringCommand '\<\(string\)\>\.' contained nextgroup=practiceStringCutCommand,practiceStringScanCommand
hi link practiceStringCommand practiceCommand
syn match practiceGotoCommand '\<\(goto\)\>' contained
hi link practiceGotoCommand practiceCommand
syn match practiceSystemCommand '\<\(system\|sys\)\>\.' contained nextgroup=practiceSystemCpuCommand,practiceSystemBdmclockCommand,practiceSystemUpCommand
hi link practiceSystemCommand practiceCommand
syn match practiceRegisterCommand '\<\(register\)\>\.' contained nextgroup=practiceRegisterSetCommand
hi link practiceRegisterCommand practiceCommand

" second commands
syn match practiceDataLoadCommand '\(load\.\?\)' contained nextgroup=practiceDataLoadBinaryCommand,practiceDataLoadElfCommand
hi link practiceDataLoadCommand practiceCommand
syn match practiceDataSetCommand '\(set\)' contained
hi link practiceDataSetCommand practiceCommand
syn match practiceFlashResetCommand '\(reset\)' contained
hi link practiceFlashResetCommand practiceCommand
syn match practiceFlashEraseCommand '\(erase\.\?\)' contained nextgroup=practiceFlashEraseAllCommand
hi link practiceFlashEraseCommand practiceCommand
syn match practiceFlashProgramCommand '\(program\.\?\)' contained nextgroup=practiceFlashProgramAllCommand,practiceFlashProgramOffCommand
hi link practiceFlashProgramCommand practiceCommand
syn match practiceFlashCreateCommand '\(create\)' contained
hi link practiceFlashCreateCommand practiceCommand
syn match practiceFlashTargetCommand '\(target\)' contained
hi link practiceFlashTargetCommand practiceCommand
syn match practiceChdirDoCommand '\(do\)' contained
hi link practiceChdirDoCommand practiceCommand
syn match practiceWinpageResetCommand '\(reset\)' contained
hi link practiceWinpageResetCommand practiceCommand
syn match practiceWinpageCreateCommand '\(create\)' contained
hi link practiceWinpageCreateCommand practiceCommand
syn match practiceWinpageSelectCommand '\(select\)' contained
hi link practiceWinpageSelectCommand practiceCommand
syn match practiceAreaResetCommand '\(reset\)' contained
hi link practiceAreaResetCommand practiceCommand
syn match practiceAreaCreateCommand '\(create\)' contained
hi link practiceAreaCreateCommand practiceCommand
syn match practiceAreaSelectCommand '\(select\)' contained
hi link practiceAreaSelectCommand practiceCommand
syn match practiceAreaViewCommand '\(view\)' contained
hi link practiceAreaViewCommand practiceCommand
syn match practiceOsPsdCommand '\(psd()\)' contained
hi link practiceOsPsdCommand practiceCommand
syn match practiceOsPtdCommand '\(ptd()\)' contained
hi link practiceOsPtdCommand practiceCommand
syn match practiceOsEnvCommand '\(env\)' contained
hi link practiceOsEnvCommand practiceCommand
syn match practiceOsFileCommand '\(file\)' contained
hi link practiceOsFileCommand practiceCommand
syn match practiceStringCutCommand '\(cut\)' contained
hi link practiceStringCutCommand practiceCommand
syn match practiceStringScanCommand '\(scan\)' contained
hi link practiceStringScanCommand practiceCommand
syn match practiceSystemCpuCommand '\(cpu\)' contained
hi link practiceSystemCpuCommand practiceCommand
syn match practiceSystemBdmclockCommand '\(bdmclock\)' contained
hi link practiceSystemBdmclockCommand practiceCommand
syn match practiceSystemUpCommand '\(up\)' contained
hi link practiceSystemUpCommand practiceCommand
syn match practiceRegisterSetCommand '\(set\)' contained
hi link practiceRegisterSetCommand practiceCommand

" third commands
syn match practiceDataLoadBinaryCommand '\(binary\|b\)' contained
hi link practiceDataLoadBinaryCommand practiceCommand
syn match practiceDataLoadElfCommand '\(elf\)' contained
hi link practiceDataLoadElfCommand practiceCommand
syn match practiceFlashEraseAllCommand '\(all\)' contained
hi link practiceFlashEraseAllCommand practiceCommand
syn match practiceFlashProgramAllCommand '\(all\)' contained
hi link practiceFlashProgramAllCommand practiceCommand
syn match practiceFlashProgramOffCommand '\(off\)' contained
hi link practiceFlashProgramOffCommand practiceCommand

syn match practiceFunction '\<cpufamily\s*(.*)'
"syn keyword practiceBranch goto call

syn match practiceOperator "\(:=\)\|\(=\)\|\(<-\)\|\(->\)\|\(>>\)\|[+-]"
"syn match practiceEOS "[.,;:]\(\s\|\n\)"
syn match practiceSeperator "[.,;:]"

" Comments
syn keyword practiceTodo contained TODO FIXME XXX
" string inside comments
syn region practiceCommentString contained start=+"+ end=+"+ end=+\*/+me=s-1,he=s-1 contains=practiceSpecial,practiceCommentStar,practiceSpecialChar
syn region practiceComment2String contained start=+"+ end=+$\|"+ contains=practiceSpecial,practiceSpecialChar
syn match practiceCommentCharacter contained "'\\[^']\{1,6\}'" contains=practiceSpecialChar
syn match practiceCommentCharacter contained "'\\''" contains=practiceSpecialChar
syn match practiceCommentCharacter contained "'[^\\]'"
"syn region practiceComment start="(\*" end="\*)" contains=practiceCommentString,practiceCommentCharacter,practiceNumber,practiceTodo
"syn match practiceCommentStar contained "^\s*\*[^/]"me=e-1
"syn match practiceCommentStar contained "^\s*\*$"
syn match practiceLineComment ";.*" contains=practiceComment2String,practiceCommentCharacter,practiceNumber,practiceTodo
hi link practiceLineComment practiceComment
hi link practiceCommentString practiceString
hi link practiceComment2String practiceString
"hi link practiceCommentCharacter practiceCharacter

" Strings and constants
syn region practiceString start=+"+ end=+"+ contains=ucSpecialChar,ucSpecialError
"syn match practiceNumber "#\?\<\(0[0-7]*\|0[xX]\x\+\|\d\+\)[lL]\=\>"
"syn match practiceNumber "#\?$\?\<\x\+\>"

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_practice_syntax_inits")
   if version < 508
      let did_practice_syntax_inits = 1
      command -nargs=+ HiLink hi link <args>
   else
      command -nargs=+ HiLink hi def link <args>
   endif

   HiLink practiceConditional Conditional
   HiLink practiceRepeat Repeat
   HiLink practiceNumber Number
   HiLink practiceComment Comment
   HiLink practiceString String
   HiLink practiceBranch Statement
   HiLink practiceOperator String
   HiLink practiceEOS String
   HiLink practiceSeperator String
   HiLink practiceLabel Label
   HiLink practiceCommand Statement
   HiLink practiceFunction Function

   delcommand HiLink
endif

let b:current_syntax = "practice"

if main_syntax == 'practice'
   unlet main_syntax
endif

" Only load this indent file when no other was loaded.
if exists("b:did_indent")
   finish
endif
let b:did_indent = 1

" TT is like indenting C
setlocal cindent

let b:undo_indent = "setl cin<"
