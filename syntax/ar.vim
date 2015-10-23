" Vim syntax file
" Language:		Arua
" Maintainer:	Josh Junon
" URL:			https://github.com/arua-lang/proposal.git
" Status:		Proposal

if !exists("main_syntax")
	if version < 600
		syntax clear
	elseif exists("b:current_syntax")
		finish
	endif

	let main_syntax="arua"
endif

if version < 508
	command! -nargs=+ AruaHiLink hi link <args>
else
	command! -nargs=+ AruaHiLink hi def link <args>
endif

syn match aruaError			"\v;"

syn match aruaError			"\v^ +\t+"

syn keyword aruaKeyword		fn trait ret this on struct if then else elseif
syn keyword aruaKeyword		use as try catch finally throw switch case next
syn keyword aruaKeyword		default

syn match aruaDecl			"\v^[ \t]*\!?(if|ret|switch|case|fn|trait|ret)@![a-zA-Z][a-zA-Z0-9]*[ \t]+" contains=aruaOperatorMut,arua nextgroup=@aruaTypes

syn match aruaOperatorMut	"\v\!" contained
syn match aruaType			"\v[a-zA-Z][a-zA-Z0-9]*" contained contains=@aruaTypes
syn region aruaTypeArray	matchgroup=aruaOperator start="\v\[" end="\]" contained contains=@aruaAnyType

syn cluster aruaAnyType		contains=aruaType,aruaTypeArray

syn keyword aruaStringType	str
syn match aruaPrimitive		"\v[iuf][1-9][0-9]*>" display

syn match aruaOperator		"\v\[" display
syn match aruaOperator		"\v\]" display
syn match aruaOperator		"\v\!\=?" display
syn match aruaOperator		"\v\+[\+\=]?" display
syn match aruaOperator		"\v\-[\-\=]?" display
syn match aruaOperator		"\v\*\=?" display
syn match aruaOperator		"\v\/\=?" display
syn match aruaOperator		"\v\%\=?" display
syn match aruaOperator		"\v\&\&?\=?" display
syn match aruaOperator		"\v\|\|?\=?" display
syn match aruaOperator		"\v\<\<?\=?" display
syn match aruaOperator		"\v\>\>?\=?" display
syn match aruaOperator		"\v\=\=?" display

syn match aruaComment		"\v#.*$" display

syn keyword aruaBoolean		true false

syn region aruaString		start="\v\"" skip="\v(\\\\|\\\")" end="\v\""
syn match aruaStringEscape	"\v\\[\\rnfvb0]" contained containedin=aruaString
syn match aruaStringEscape	"\v\\x[0-9A-F]{2}" contained containedin=aruaString
syn match aruaError			"\v\\x([0-9A-F]{2})@![^\"\\]{,2}" contained containedin=aruaString
syn match aruaStringEscape	"\v\\u[0-9A-F]{4}" contained containedin=aruaString
syn match aruaError			"\v\\u([0-9A-F]{4})@![^\"\\]{,4}" contained containedin=aruaString
syn match aruaStringDelim	"\v\{(0|[1-9][0-9]*)\}" contained containedin=aruaString
syn region aruaStringInterp	matchgroup=aruaStringInterpDelim start="\v#\{" end="\v\}" contained containedin=aruaString contains=@aruaAll

syn region aruaComplexMath	start="\v\`" end="\v\`"
" not at all an exhaustive list. complex numbers are still under extreme
" consideration.
syn match aruaComplexSpec	"\v<[ie√πτεφθ∞λμξΣσςΩω]>" contained containedin=aruaComplexMath transparent

syn match aruaNumber		"\v<(0|[1-9][0-9]*)>"
syn match aruaNumber		"\v<\.[0-9]+>"
syn match aruaNumber		"\v<(0|[1-9][0-9]*)\.[0-9]+>"

" we only allow uppercase letters here in order to allow for type suffixes.
" otherwise, the suffix i32 would be acceptible for base 19 and above, for
" example.
"
" yes, we support base 1; a tally system, comprising of 0's.
" please avoid using this in the wild. this is here for completeness.
syn match aruaNumber		"\v<1x0+>"
syn match aruaNumericError	"\v<1x(0*([1-9A-Z]+0*)+)>"
syn match aruaNumber		"\v<2x[01]+>"
syn match aruaNumericError	"\v<2x([01]*([2-9A-Z]+[01]*)+)>"
syn match aruaNumber		"\v<3x[0-2]+>"
syn match aruaNumericError	"\v<3x([0-2]*([3-9A-Z]+[0-2]*)+)>"
syn match aruaNumber		"\v<4x[0-3]+>"
syn match aruaNumericError	"\v<4x([0-3]*([4-9A-Z]+[0-3]*)+)>"
syn match aruaNumber		"\v<5x[0-4]+>"
syn match aruaNumericError	"\v<5x([0-4]*([5-9A-Z]+[0-4]*)+)>"
syn match aruaNumber		"\v<6x[0-5]+>"
syn match aruaNumericError	"\v<6x([0-5]*([6-9A-Z]+[0-5]*)+)>"
syn match aruaNumber		"\v<7x[0-6]+>"
syn match aruaNumericError	"\v<7x([0-6]*([7-9A-Z]+[0-6]*)+)>"
syn match aruaNumber		"\v<8x[0-7]+>"
syn match aruaNumericError	"\v<8x([0-7]*([89A-Z]+[0-7]*)+)>"
syn match aruaNumber		"\v<9x[0-8]+>"
syn match aruaNumericError	"\v<9x([0-8]*([9A-Z]+[0-8]*)+)>"
syn match aruaNumber		"\v<10x[0-9]+>"
syn match aruaNumericError	"\v<10x([0-9]*([A-Z]+[0-9]*)+)>"
syn match aruaNumber		"\v<11x[0-9A]+>"
syn match aruaNumericError	"\v<11x([0-9A]*([B-Z]+[0-9A]*)+)>"
syn match aruaNumber		"\v<12x[0-9AB]+>"
syn match aruaNumericError	"\v<12x([0-9AB]*([C-Z]+[0-9AB]*)+)>"
syn match aruaNumber		"\v<13x[0-9A-C]+>"
syn match aruaNumericError	"\v<13x([0-9A-C]*([D-Z]+[0-9A-C]*)+)>"
syn match aruaNumber		"\v<14x[0-9A-D]+>"
syn match aruaNumericError	"\v<14x([0-9A-D]*([E-Z]+[0-9A-D]*)+)>"
syn match aruaNumber		"\v<15x[0-9A-E]+>"
syn match aruaNumericError	"\v<15x([0-9A-E]*([F-Z]+[0-9A-E]*)+)>"
syn match aruaNumber		"\v<(0|16)x[0-9A-F]+>"
syn match aruaNumericError	"\v<(0|16)x([0-9A-F]*([G-Z]+[0-9A-F]*)+)>"
syn match aruaNumber		"\v<17x[0-9A-G]+>"
syn match aruaNumericError	"\v<17x([0-9A-G]*([H-Z]+[0-9A-G]*)+)>"
syn match aruaNumber		"\v<18x[0-9A-H]+>"
syn match aruaNumericError	"\v<18x([0-9A-H]*([I-Z]+[0-9A-H]*)+)>"
syn match aruaNumber		"\v<19x[0-9A-I]+>"
syn match aruaNumericError	"\v<19x([0-9A-I]*([J-Z]+[0-9A-I]*)+)>"
syn match aruaNumber		"\v<20x[0-9A-J]+>"
syn match aruaNumericError	"\v<20x([0-9A-J]*([K-Z]+[0-9A-J]*)+)>"
syn match aruaNumber		"\v<21x[0-9A-K]+>"
syn match aruaNumericError	"\v<21x([0-9A-K]*([L-Z]+[0-9A-K]*)+)>"
syn match aruaNumber		"\v<22x[0-9A-L]+>"
syn match aruaNumericError	"\v<22x([0-9A-L]*([M-Z]+[0-9A-L]*)+)>"
syn match aruaNumber		"\v<23x[0-9A-M]+>"
syn match aruaNumericError	"\v<23x([0-9A-M]*([N-Z]+[0-9A-M]*)+)>"
syn match aruaNumber		"\v<24x[0-9A-N]+>"
syn match aruaNumericError	"\v<24x([0-9A-N]*([O-Z]+[0-9A-N]*)+)>"
syn match aruaNumber		"\v<25x[0-9A-O]+>"
syn match aruaNumericError	"\v<25x([0-9A-O]*([P-Z]+[0-9A-O]*)+)>"
syn match aruaNumber		"\v<26x[0-9A-P]+>"
syn match aruaNumericError	"\v<26x([0-9A-P]*([Q-Z]+[0-9A-P]*)+)>"
syn match aruaNumber		"\v<27x[0-9A-Q]+>"
syn match aruaNumericError	"\v<27x([0-9A-Q]*([R-Z]+[0-9A-Q]*)+)>"
syn match aruaNumber		"\v<28x[0-9A-R]+>"
syn match aruaNumericError	"\v<28x([0-9A-R]*([S-Z]+[0-9A-R]*)+)>"
syn match aruaNumber		"\v<29x[0-9A-S]+>"
syn match aruaNumericError	"\v<29x([0-9A-S]*([T-Z]+[0-9A-S]*)+)>"
syn match aruaNumber		"\v<30x[0-9A-T]+>"
syn match aruaNumericError	"\v<30x([0-9A-T]*([U-Z]+[0-9A-T]*)+)>"
syn match aruaNumber		"\v<31x[0-9A-U]+>"
syn match aruaNumericError	"\v<31x([0-9A-U]*([V-Z]+[0-9A-U]*)+)>"
syn match aruaNumber		"\v<32x[0-9A-V]+>"
syn match aruaNumericError	"\v<32x([0-9A-V]*([W-Z]+[0-9A-V]*)+)>"
syn match aruaNumber		"\v<33x[0-9A-W]+>"
syn match aruaNumericError	"\v<33x([0-9A-W]*([X-Z]+[0-9A-W]*)+)>"
syn match aruaNumber		"\v<34x[0-9A-X]+>"
syn match aruaNumericError	"\v<34x([0-9A-X]*([YZ]+[0-9A-X]*)+)>"
syn match aruaNumber		"\v<35x[0-9A-Y]+>"
syn match aruaNumericError	"\v<35x([0-9A-Y]*([Z]+[0-9A-Y]*)+)>"
syn match aruaNumber		"\v<36x[0-9A-Z]+>"

AruaHiLink aruaKeyword				Keyword
AruaHiLink aruaNumber				Number
AruaHiLink aruaError				Error
AruaHiLink aruaNumericError			Error
AruaHiLink aruaPrimitive			Type
AruaHiLink aruaComment				Comment
AruaHiLink aruaOperator				Operator
AruaHiLink aruaBoolean				Boolean
AruaHiLink aruaString				String
AruaHiLink aruaStringEscape			SpecialChar
AruaHiLink aruaStringDelim			Delimiter
AruaHiLink aruaStringInterpDelim	PreProc
AruaHiLink aruaStringType			Typedef
AruaHiLink aruaOperatorMut			Underlined
AruaHiLink aruaComplexMath			Underlined
"AruaHiLink aruaComplexSpec			Special

syn cluster aruaTypes contains=aruaStringType,aruaPrimitive

syn cluster aruaAll contains=aruaKeyword,aruaNumber,aruaError,aruaNumericError,
\                            aruaOperator,aruaBoolean,aruaString,@aruaTypes

" vi: tabstop=4
"
