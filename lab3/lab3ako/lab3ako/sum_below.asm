.686
.model flat
extern __write : PROC
extern _ExitProcess@4 : PROC

public _main

.data
dekoder db '0123456789ABCDEFGHIJ'

.code
sum PROC
	;esp -> ret	
	;summing
	xor eax, eax
	mov ebx, [esp]
	add eax, [ebx]
	add eax, [ebx + 4]

	;shifiting esp to next instruction
	;add ebx, 8
	;mov dword ptr [esp], ebx
	add dword ptr [esp], 8
	ret
sum ENDP

wyswietl_EAX_10 PROC
	pushad
	sub esp, 12
	mov edi, esp

	mov byte ptr [edi], 0
	mov byte ptr [edi + 11], 0Ah

	mov ebx, 10
	xor ecx, ecx
	mov esi, 10

	zamiana_10_wys:
		xor edx, edx
		div ebx
		mov cl, [dekoder + edx]
		mov [edi + esi], cl
		dec esi

		or esi, esi
		jz wypisz_10
		or eax, eax
		jnz zamiana_10_wys

	dopeln_10:
		or esi, esi
		jz wypisz_10
		mov byte ptr [edi + esi], 0
		dec esi
	jmp dopeln_10

	wypisz_10:
	push 12
	push edi
	push 1
	call __write
	add esp, 24

	popad
	ret
wyswietl_EAX_10 ENDP

_main PROC

	call sum
	dd 123
	dd 124343
	
	jmp wyswietl_EAX_10

	push 0
	call _ExitProcess@4

_main ENDP
END
