.686
.model flat
extern __write : PROC
extern _ExitProcess@4 : PROC

public _main

.data
.code
sum PROC
	;esp -> ret	
	;summing
	xor eax, eax
	mov ebx, [esp]
	add eax, [ebx]
	add eax, [ebx + 4]

	;shifiting esp to next instruction
	add ebx, 8
	mov dword ptr [esp], ebx
	ret
sum ENDP

_main PROC

	call sum
	dd 5
	dd 4
	
	add eax, 30h
	add esp, 2
	mov ebp, esp
	mov byte ptr [ebp], al

	push 1
	push ebp
	push 1
	call __write
	add esp, 14

	push 0
	call _ExitProcess@4

_main ENDP
END
