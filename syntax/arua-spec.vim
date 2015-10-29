" Vim syntax file
" Language:		Arua specification syntax
" Maintainer:	Josh Junon
" URL:			https://github.com/arua-lang/proposal.git
" Status:		Proposal"

if !exists("main_syntax")
	if version < 600
		syntax clear
	elseif exists("b:current_syntax")
		finish
	endif

	let main_syntax="arua-spec"
endif

if version < 508
	command! -nargs=+ AruaSpecHiLink hi link <args>
else
	command! -nargs=+ AruaSpecHiLink hi def link <args>
endif

syn match aruaSpecComment				"\v\#.*$" contains=aruaSpecTodo,aruaSpecSubRef
syn keyword aruaSpecTodo				TODO FIXME RFC XXX HELP contained
syn match aruaSpecSubRef				"\v§[0-9]+(\.[0-9]+)*" contained

syn keyword aruaSpecStability			FROZEN UNCONFIRMED DEPRECATED RFC PROPOSED

syn region aruaSpecRegex				start="\v\/" skip="\v(\\\\|\\\/)" end="\v\/"

syn match aruaSpecIdentifier			"\v^[a-zA-Z_][a-zA-Z0-9_]*:"
syn match aruaSpecIdentifierRef			"\v\<[a-zA-Z_][a-zA-Z0-9_]*\>"

syn region aruaSpecString				start="\v\"" skip="\v(\\\\|\\\")" end="\v\""

syn match aruaSpecOperator				"\v[\(\)]"
syn match aruaSpecOperator				"\v[\*\?\+]"
syn match aruaSpecOperator				"\v\{[0-9]*,[0-9]*\}"

AruaSpecHiLink aruaSpecComment			Comment
AruaSpecHiLink aruaSpecTodo				Todo
AruaSpecHiLink aruaSpecStability		Underlined
AruaSpecHiLink aruaSpecRegex			PreProc
AruaSpecHiLink aruaSpecIdentifier		Identifier
AruaSpecHiLink aruaSpecIdentifierRef	Special
AruaSpecHiLink aruaSpecOperator			Operator
AruaSpecHiLink aruaSpecString			String
AruaSpecHiLink aruaSpecSubRef			Type
