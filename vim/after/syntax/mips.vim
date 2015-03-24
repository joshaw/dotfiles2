" Vim syntax file
" Language: MIPS
" Maintainer:   Alex Brick <alex@alexrbrick.com>
" Last Change:  2007 Oct 18

if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

setlocal iskeyword+=-
syntax case match

syntax match mipsComment /#.*/
syntax match mipsNumber /\<[-]\?\d\+\>/ " Decimal numbers
syntax match mipsNumber /\<-\?0\(x\|X\)[0-9a-fA-F]\+\>/ " Hex numbers
syntax region mipsString start=/"/ skip=/\\"/ end=/"/
syntax match mipsLabelColon /:/ contained
syntax match mipsLabel /\w\+:/ contains=mipsLabelColon

" Registers
syntax match mipsRegister "\$zero"
syntax match mipsRegister "\$v0"
syntax match mipsRegister "\$v1"
syntax match mipsRegister "\$a0"
syntax match mipsRegister "\$a1"
syntax match mipsRegister "\$a2"
syntax match mipsRegister "\$a3"
syntax match mipsRegister "\$t0"
syntax match mipsRegister "\$t1"
syntax match mipsRegister "\$t2"
syntax match mipsRegister "\$t3"
syntax match mipsRegister "\$t4"
syntax match mipsRegister "\$t5"
syntax match mipsRegister "\$t6"
syntax match mipsRegister "\$t7"
syntax match mipsRegister "\$t8"
syntax match mipsRegister "\$t9"
syntax match mipsRegister "\$s0"
syntax match mipsRegister "\$s1"
syntax match mipsRegister "\$s2"
syntax match mipsRegister "\$s3"
syntax match mipsRegister "\$s4"
syntax match mipsRegister "\$s5"
syntax match mipsRegister "\$s6"
syntax match mipsRegister "\$s7"
syntax match mipsRegister "\$k0"
syntax match mipsRegister "\$k1"
syntax match mipsRegister "\$gp"
syntax match mipsRegister "\$sp"
syntax match mipsRegister "\$fp"
syntax match mipsRegister "\$ra"

let i = 0
while i < 32
    " This is for the regular registers
    execute 'syntax match mipsRegister "\$' . i . '\(\d\+\)\@!"'
    " And this is for the FP registers
    execute 'syntax match mipsRegister "\$f' . i . '\(\d\+\)\@!"'
    let i = i + 1
endwhile

" Directives
syntax match mipsDirective "\.2byte"
syntax match mipsDirective "\.4byte"
syntax match mipsDirective "\.8byte"
syntax match mipsDirective "\.aent"
syntax match mipsDirective "\.align"
syntax match mipsDirective "\.aascii"
syntax match mipsDirective "\.asciiz"
syntax match mipsDirective "\.byte"
syntax match mipsDirective "\.comm"
syntax match mipsDirective "\.cpadd"
syntax match mipsDirective "\.cpload"
syntax match mipsDirective "\.cplocal"
syntax match mipsDirective "\.cprestore"
syntax match mipsDirective "\.cpreturn"
syntax match mipsDirective "\.cpsetup"
syntax match mipsDirective "\.data"
syntax match mipsDirective "\.double"
syntax match mipsDirective "\.dword"
syntax match mipsDirective "\.dynsym"
syntax match mipsDirective "\.end"
syntax match mipsDirective "\.endr"
syntax match mipsDirective "\.ent"
syntax match mipsDirective "\.extern"
syntax match mipsDirective "\.file"
syntax match mipsDirective "\.float"
syntax match mipsDirective "\.fmask"
syntax match mipsDirective "\.frame"
syntax match mipsDirective "\.globl"
syntax match mipsDirective "\.gpvalue"
syntax match mipsDirective "\.gpword"
syntax match mipsDirective "\.half"
syntax match mipsDirective "\.kdata"
syntax match mipsDirective "\.ktext"
syntax match mipsDirective "\.lab"
syntax match mipsDirective "\.lcomm"
syntax match mipsDirective "\.loc"
syntax match mipsDirective "\.mask"
syntax match mipsDirective "\.nada"
syntax match mipsDirective "\.nop"
syntax match mipsDirective "\.option"
syntax match mipsDirective "\.origin"
syntax match mipsDirective "\.repeat"
syntax match mipsDirective "\.rdata"
syntax match mipsDirective "\.sdata"
syntax match mipsDirective "\.section"
syntax match mipsDirective "\.set"
syntax match mipsDirective "\.size"
syntax match mipsDirective "\.space"
syntax match mipsDirective "\.struct"
syntax match mipsDirective "\.text"
syntax match mipsDirective "\.type"
syntax match mipsDirective "\.verstamp"
syntax match mipsDirective "\.weakext"
syntax match mipsDirective "\.word"

" Arithmetic and Logical Instructions
syntax keyword mipsInstruction abs
syntax keyword mipsInstruction add addu addi addiu
syntax keyword mipsInstruction and andi
syntax keyword mipsInstruction clo clz
syntax keyword mipsInstruction div divu 
syntax keyword mipsInstruction mult multu mul mulo mulou madd maddu msub msubu
syntax keyword mipsInstruction neg negu
syntax keyword mipsInstruction nor
syntax keyword mipsInstruction not
syntax keyword mipsInstruction or ori
syntax keyword mipsInstruction rem remu
syntax keyword mipsInstruction sll sllv sra srav srl srlv
syntax keyword mipsInstruction rol ror
syntax keyword mipsInstruction sub subu
syntax keyword mipsInstruction xor xori

" Constant-Manipulating Instructions
syntax keyword mipsInstruction lui li
syntax keyword mipsInstruction slt sltu slti sltiu
syntax keyword mipsInstruction seq
syntax keyword mipsInstruction sge sgeu
syntax keyword mipsInstruction sgt sgtu
syntax keyword mipsInstruction sle sleu
syntax keyword mipsInstruction sne

" Branch Instructions
syntax keyword mipsInstruction b
syntax keyword mipsInstruction bc1f bc1t
syntax keyword mipsInstruction beq beqz
syntax keyword mipsInstruction bgez bgezal bgtz
syntax keyword mipsInstruction blez bltzal bltz
syntax keyword mipsInstruction bne bnez
syntax keyword mipsInstruction bge bgeu
syntax keyword mipsInstruction bgt bgtu
syntax keyword mipsInstruction ble bleu
syntax keyword mipsInstruction blt bltu

" Jump Instructions
syntax keyword mipsInstruction j jal jalr jr

" Trap Instructions
syntax keyword mipsInstruction teq teqi
syntax keyword mipsInstruction tne tnei
syntax keyword mipsInstruction tge tgeu tgei tgeiu
syntax keyword mipsInstruction tlt tltu tlti tltiu

" Load Instructions
syntax keyword mipsInstruction la
syntax keyword mipsInstruction lb lbu lh lhu
syntax keyword mipsInstruction lw lwc1 lwl lwr
syntax keyword mipsInstruction ld
syntax keyword mipsInstruction ulh ulhu ulw
syntax keyword mipsInstruction ll

" Store Instructions
syntax keyword mipsInstruction sb sh sw swc1 sdc1 swl swr sd ush usw sc

" Data Movement Instructions
syntax keyword mipsInstruction move
syntax keyword mipsInstruction mfhi mflo
syntax keyword mipsInstruction mthi mtlo
syntax keyword mipsInstruction mfc0 mfc1
syntax match mipsInstruction "mfc1\.d"
syntax keyword mipsInstruction mtc0 mtc1
syntax keyword mipsInstruction movn movz movf movt

" Floating-Point Instructions
syntax match mipsInstruction "abs\.d"
syntax match mipsInstruction "abs\.s"
syntax match mipsInstruction "add\.d"
syntax match mipsInstruction "add\.s"
syntax match mipsInstruction "ceil\.w\.d"
syntax match mipsInstruction "ceil\.w\.s"
syntax match mipsInstruction "c\.eq\.d"
syntax match mipsInstruction "c\.eq\.s"
syntax match mipsInstruction "c\.le\.d"
syntax match mipsInstruction "c\.le\.s"
syntax match mipsInstruction "c\.lt\.d"
syntax match mipsInstruction "c\.lt\.s"
syntax match mipsInstruction "cvt\.d\.s"
syntax match mipsInstruction "cvt\.d\.w"
syntax match mipsInstruction "cvt\.s\.d"
syntax match mipsInstruction "cvt\.s\.w"
syntax match mipsInstruction "cvt\.w\.d"
syntax match mipsInstruction "cvt\.w\.s"
syntax match mipsInstruction "div\.d"
syntax match mipsInstruction "div\.s"
syntax match mipsInstruction "floor\.w\.d"
syntax match mipsInstruction "floor\.w\.s"
syntax match mipsInstruction "l\.d"
syntax match mipsInstruction "l\.s"
syntax match mipsInstruction "mov\.d"
syntax match mipsInstruction "mov\.s"
syntax match mipsInstruction "movf\.d"
syntax match mipsInstruction "movf\.s"
syntax match mipsInstruction "movt\.d"
syntax match mipsInstruction "movt\.s"
syntax match mipsInstruction "movn\.d"
syntax match mipsInstruction "movn\.s"
syntax match mipsInstruction "movz\.d"
syntax match mipsInstruction "movz\.s"
syntax match mipsInstruction "mul\.d"
syntax match mipsInstruction "mul\.s"
syntax match mipsInstruction "neg\.d"
syntax match mipsInstruction "neg\.s"
syntax match mipsInstruction "round\.w\.d"
syntax match mipsInstruction "round\.w\.s"
syntax match mipsInstruction "sqrt\.d"
syntax match mipsInstruction "sqrt\.s"
syntax match mipsInstruction "s\.d"
syntax match mipsInstruction "s\.s"
syntax match mipsInstruction "sub\.d"
syntax match mipsInstruction "sub\.s"
syntax match mipsInstruction "trunc\.w\.d"
syntax match mipsInstruction "trunc\.w\.s"

" Exception and Interrupt Instructions
syntax keyword mipsInstruction eret
syntax keyword mipsInstruction syscall
syntax keyword mipsInstruction break
syntax keyword mipsInstruction nop

hi def link mipsComment        Comment
hi def link mipsNumber         Number
hi def link mipsString         String
hi def link mipsLabel          Label
hi def link mipsRegister       Identifier
hi def link mipsDirective      Type
hi def link mipsInstruction    Statement

let b:current_syntax = "mips"
