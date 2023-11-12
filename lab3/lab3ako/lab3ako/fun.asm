.686
.model flat
extern _ExitProcess@4 : PROC
extern __write : PROC
public _main

.data

tekst db 'N'

.code

_main PROC
	mov al, 9
	mov byte ptr [tekst], al
	push 1
	push dword PTR OFFSET tekst
	push 1
	call __write
	add esp, 12

	push dword PTR 0
	call _ExitProcess@4
_main ENDP
END
