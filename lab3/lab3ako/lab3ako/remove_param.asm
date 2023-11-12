.686
.model flat
extern _ExitProcess@4 : PROC
extern __write : PROC
public _main

.code

sum PROC
	push ebp
	mov ebp, esp	
	add ebp, 8 ;first param pointer

	xor eax, eax
	add eax, [ebp]
	add eax, [ebp + 4]

	pop ebp

	;deleting arguments and preserving register ebx
	push ebx
	mov ebx, [esp + 4] ;save ret adress
	mov dword ptr [esp+12], ebx
	pop ebx
	add esp, 8

	ret
sum ENDP

_main PROC

	push 1
	push 2
	call sum

	;changing to ascii and saving on stack
	add eax, 30h
	add esp, 2
	mov ebp, esp
	mov byte ptr [ebp], al

	push 1
	push ebp
	push 1
	call __write
	add esp, 14

	push dword PTR 0
	call _ExitProcess@4
_main ENDP
END