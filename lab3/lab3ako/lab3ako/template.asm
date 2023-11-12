.686
.model flat
extern __write : PROC
extern __read : PROC
extern _ExitProcess@4 : PROC
public _main

.data
dekoder db '0123456789ABCDEFGHIJ'

.code

_main PROC

	push 0
	call _ExitProcess@4
_main ENDP
END
