.686
.model flat

.data
L1 dq 4080000080000000h
L2 dq 4080000080000000h
L3 dd 0

.code
_iteracja PROC

	fld L1
	fadd L2
	fst L3


 mov al, 100b;
	
	add ebx, 98h

	db 83h, 0c3h, 88h
	mov [ebp + 4*ebp], dl
	
	db 74h, 09h
	db 83h, 0e0h, 0fh
	db 88h, 14h, 1ah
	db 42h
	db 0e2h, 0f7h


	mov al, 100b;
	sal al, 1

	xor eax, eax
	push ebp
	mov ebp, esp
	mov al, [ebp + 8]
	sal al, 1
	jc zakoncz
	inc al
	push eax
	call _iteracja
	add esp, 4
	pop ebp
	ret

zakoncz:
	rcr al, 1
	pop ebp
	ret
_iteracja ENDP
END