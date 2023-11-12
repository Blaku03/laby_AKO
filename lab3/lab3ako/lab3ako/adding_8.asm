.686
.model flat
extern __write : PROC
extern __read : PROC
extern _ExitProcess@4 : PROC
public _main

.data
dekoder db '0123456789ABCDEFGHIJ'

.code

wczytaj_EAX_20 PROC
	push edi
	push esi
	push ecx
	push ebx
	push edx

	sub esp, 12
	mov edi, esp ;store register

	push 12
	push edi
	push 0
	call __read
	add esp, 12

	xor esi, esi
	xor ecx, ecx
	xor edx, edx
	xor eax, eax
	
	mov ebx, 20

	zamiana_20:
		mov cl, [edi + esi] ;get byte
		inc esi
		cmp cl, 0Ah
		je koniec_20

		cmp cl, '0'
		jb zamiana_20
		cmp cl, '9'
		ja wielka_liczba_20
		sub cl, '0'

		zapisz_do_EAX_20:
		mul ebx
		add eax, ecx
		jmp zamiana_20

		wielka_liczba_20:
		cmp cl, 'A'
		jb zamiana_20
		cmp cl, 'Z'
		ja mala_liczba_20
		sub cl, 'A' - 10
		jmp zapisz_do_EAX_20

		mala_liczba_20:
		cmp cl, 'a'
		jb zamiana_20
		cmp cl, 'z'
		ja zamiana_20
		sub cl, 'a' - 10
		jmp zapisz_do_EAX_20


	koniec_20:
	add esp, 12
	pop edx
	pop ebx
	pop ecx
	pop esi
	pop edi
	ret
wczytaj_EAX_20 ENDP

wczytaj_EAX_8 PROC
	push edi
	push esi
	push ecx
	push ebx
	push edx

	sub esp, 12
	mov edi, esp ;store register

	push 12
	push edi
	push 0
	call __read
	add esp, 12

	xor esi, esi
	xor ecx, ecx
	xor edx, edx
	xor eax, eax
	
	mov ebx, 8

	zamiana_8:
		mov cl, [edi + esi] ;get byte
		inc esi
		cmp cl, 0Ah
		je koniec_8
		sub cl, '0'
		mul ebx
		add eax, ecx
		jmp zamiana_8


	koniec_8:
	add esp, 12
	pop edx
	pop ebx
	pop ecx
	pop esi
	pop edi
	ret
wczytaj_EAX_8 ENDP

wyswietl_EAX_20 PROC
	pushad
	sub esp, 12
	mov edi, esp

	mov byte ptr [edi], 0
	mov byte ptr [edi + 11], 0Ah

	mov ebx, 20
	xor ecx, ecx
	mov esi, 10

	zamiana_20_wys:
		xor edx, edx
		div ebx
		mov cl, [dekoder + edx]
		mov [edi + esi], cl
		dec esi

		or esi, esi
		jz wypisz_20
		or eax, eax
		jnz zamiana_20_wys

	dopeln_20:
		or esi, esi
		jz wypisz_20
		mov byte ptr [edi + esi], 0
		dec esi
	jmp dopeln_20

	wypisz_20:
	push 12
	push edi
	push 1
	call __write
	add esp, 24

	popad
	ret
wyswietl_EAX_20 ENDP


wyswietl_EAX_8 PROC
	pushad
	sub esp, 12
	mov edi, esp

	mov byte ptr [edi], 0
	mov byte ptr [edi + 11], 0Ah

	mov ebx, 8
	xor ecx, ecx
	mov esi, 10

	zamiana_8_wys:
		xor edx, edx
		div ebx
		mov cl, [dekoder + edx]
		mov [edi + esi], cl
		dec esi

		or esi, esi
		jz wypisz_8
		or eax, eax
		jnz zamiana_8_wys

	dopeln_8:
		or esi, esi
		jz wypisz_8
		mov byte ptr [edi + esi], 0
		dec esi
	jmp dopeln_8

	wypisz_8:
	push 12
	push edi
	push 1
	call __write
	add esp, 24

	popad
	ret
wyswietl_EAX_8 ENDP

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
;	call wczytaj_EAX_8
;	mov edx, eax
;	call wczytaj_EAX_8

;	add eax, edx
;	call wyswietl_EAX_8	
	call wczytaj_EAX_20	
	call wyswietl_EAX_10	
	call wyswietl_EAX_20	

	push 0
	call _ExitProcess@4
_main ENDP
END
