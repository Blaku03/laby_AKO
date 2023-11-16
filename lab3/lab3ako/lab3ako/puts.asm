.686
.model flat
extern _puts : PROC
extern __read : PROC
extern _ExitProcess@4 : PROC
extern _putchar : PROC
public _main

.data
dekoder db '0123456789ABCDEFGHIJ'

.code
wyswietl132_nowy PROC

	mov eax, [esp] ;value to display
	mov eax, [eax]
	call wyswietl_EAX_10

	add dword ptr [esp], 4 ;next instruciton
	ret
wyswietl132_nowy ENDP

wyswietl_EAX_10 PROC
	pushad
	sub esp, 12
	mov edi, esp

	mov byte ptr [edi], ' '
	mov byte ptr [edi + 11], 0

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
		mov byte ptr [edi + esi], ' ' 
		dec esi
	jmp dopeln_10

	wypisz_10:

	
	;push edi
	;call _puts
	;add esp, 4 

	mov ecx, 0
	xor esi, esi

	petla_wypisanie_10:
	mov dl, [edi + esi]		
	push ecx

	push edx
	call _putchar
	add esp, 4

	pop ecx
	inc esi
	cmp esi, 12
	jb petla_wypisanie_10



	koniec_10:
	add esp, 12
	popad
	ret
wyswietl_EAX_10 ENDP

_main PROC

	call wyswietl132_nowy
	dd	123456789

	push 0
	call _ExitProcess@4
_main ENDP
END
