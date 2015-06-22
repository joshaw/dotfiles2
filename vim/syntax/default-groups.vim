"  Script:  highlight-default-highlight-groups.vim
" Version:  0.02
"  Author:  Magnus Woldrich <m@japh.se>
"  Update:  2011-11-10 06:29:09 
"
" This script highlights all the default highlighting groups in Vim by matching
" the groups literal name and placing it in its group.

if(exists("g:loaded_hdhg"))
  finish
endif

let g:loaded_hdhg = 1

syn case ignore
syn match hdhgNormal          '\<Normal\>'
syn match hdhgBoolean         '\<Boolean\>'
syn match hdhgCharacter       '\<Character\>'
syn match hdhgComment         '\<Comment\>'
syn match hdhgConditional     '\<Conditional\>'
syn match hdhgConstant        '\<Constant\>'
syn match hdhgCursor          '\<Cursor\>'
syn match hdhgCursorLine      '\<CursorLine\>'
syn match hdhgCursorColumn    '\<CursorColumn\>'
syn match hdhgDebug           '\<Debug\>'
syn match hdhgDefine          '\<Define\>'
syn match hdhgDelimiter       '\<Delimiter\>'
syn match hdhgDiffAdd         '\<DiffAdd\>'
syn match hdhgDiffChange      '\<DiffChange\>'
syn match hdhgDiffDelete      '\<DiffDelete\>'
syn match hdhgDiffText        '\<DiffText\>'
syn match hdhgDirectory       '\<Directory\>'
syn match hdhgErrorMsg        '\<ErrorMsg\>'
syn match hdhgError           '\<Error\>'
syn match hdhgException       '\<Exception\>'
syn match hdhgFloat           '\<Float\>'
syn match hdhgFoldColumn      '\<FoldColumn\>'
syn match hdhgFolded          '\<Folded\>'
syn match hdhgFunction        '\<Function\>'
syn match hdhgIdentifier      '\<Identifier\>'
syn match hdhgIncSearch       '\<IncSearch\>'
syn match hdhgKeyword         '\<Keyword\>'
syn match hdhgLabel           '\<Label\>'
syn match hdhgLineNr          '\<LineNr\>'
syn match hdhgMacro           '\<Macro\>'
syn match hdhgModeMsg         '\<ModeMsg\>'
syn match hdhgMoreMsg         '\<MoreMsg\>'
syn match hdhgNonText         '\<NonText\>'
syn match hdhgNumber          '\<Number\>'
syn match hdhgOperator        '\<Operator\>'
syn match hdhgPreCondit       '\<PreCondit\>'
syn match hdhgPreProc         '\<PreProc\>'
syn match hdhgQuestion        '\<Question\>'
syn match hdhgRepeat          '\<Repeat\>'
syn match hdhgSearch          '\<Search\>'
syn match hdhgSpecialChar     '\<SpecialChar\>'
syn match hdhgSpecialComment  '\<SpecialComment\>'
syn match hdhgSpecial         '\<Special\>'
syn match hdhgSpecialKey      '\<SpecialKey\>'
syn match hdhgStatement       '\<Statement\>'
syn match hdhgStatusLine      '\<StatusLine\>'
syn match hdhgStatusLineNC    '\<StatusLineNC\>'
syn match hdhgStorageClass    '\<StorageClass\>'
syn match hdhgString          '\<String\>'
syn match hdhgStructure       '\<Structure\>'
syn match hdhgTag             '\<Tag\>'
syn match hdhgTitle           '\<Title\>'
syn match hdhgTodo            '\<Todo\>'
syn match hdhgTypedef         '\<Typedef\>'
syn match hdhgType            '\<Type\>'
syn match hdhgUnderlined      '\<Underlined\>'
syn match hdhgVertSplit       '\<VertSplit\>'
syn match hdhgVisualNOS       '\<VisualNOS\>'
syn match hdhgWarningMsg      '\<WarningMsg\>'
syn match hdhgWildMenu        '\<WildMenu\>'

hi link   hdhgNormal          Normal
hi link   hdhgBoolean         Boolean
hi link   hdhgCharacter       Character
hi link   hdhgComment         Comment
hi link   hdhgConditional     Conditional
hi link   hdhgConstant        Constant
hi link   hdhgCursor          Cursor
hi link   hdhgCursorLine      CursorLine
hi link   hdhgCursorColumn    CursorColumn
hi link   hdhgDebug           Debug
hi link   hdhgDefine          Define
hi link   hdhgDelimiter       Delimiter
hi link   hdhgDiffAdd         DiffAdd
hi link   hdhgDiffChange      DiffChange
hi link   hdhgDiffDelete      DiffDelete
hi link   hdhgDiffText        DiffText
hi link   hdhgDirectory       Directory
hi link   hdhgErrorMsg        ErrorMsg
hi link   hdhgError           Error
hi link   hdhgException       Exception
hi link   hdhgFloat           Float
hi link   hdhgFoldColumn      FoldColumn
hi link   hdhgFolded          Folded
hi link   hdhgFunction        Function
hi link   hdhgIdentifier      Identifier
hi link   hdhgIncSearch       IncSearch
hi link   hdhgKeyword         Keyword
hi link   hdhgLabel           Label
hi link   hdhgLineNr          LineNr
hi link   hdhgMacro           Macro
hi link   hdhgModeMsg         ModeMsg
hi link   hdhgMoreMsg         MoreMsg
hi link   hdhgNonText         NonText
hi link   hdhgNumber          Number
hi link   hdhgOperator        Operator
hi link   hdhgPreCondit       PreCondit
hi link   hdhgPreProc         PreProc
hi link   hdhgQuestion        Question
hi link   hdhgRepeat          Repeat
hi link   hdhgSearch          Search
hi link   hdhgSpecialChar     SpecialChar
hi link   hdhgSpecialComment  SpecialComment
hi link   hdhgSpecial         Special
hi link   hdhgSpecialKey      SpecialKey
hi link   hdhgStatement       Statement
hi link   hdhgStatusLine      StatusLine
hi link   hdhgStatusLineNC    StatusLineNC
hi link   hdhgStorageClass    StorageClass
hi link   hdhgString          String
hi link   hdhgStructure       Structure
hi link   hdhgTag             Tag
hi link   hdhgTitle           Title
hi link   hdhgTodo            Todo
hi link   hdhgTypedef         Typedef
hi link   hdhgType            Type
hi link   hdhgUnderlined      Underlined
hi link   hdhgVertSplit       VertSplit
hi link   hdhgVisualNOS       VisualNOS
hi link   hdhgWarningMsg      WarningMsg
hi link   hdhgWildMenu        WildMenu
