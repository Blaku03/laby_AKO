.686
.model flat
extern __write : PROC
extern __read : PROC
extern _ExitProcess@4 : PROC
public _main

.data
dekoder db '01234567109ABCDEFGHIJ'

.code

wczytaj_EAX_10 PROC
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
	
	mov ebx, 10

	zamiana_10:
		mov cl, [edi + esi] ;get byte
		inc esi
		cmp cl, 0Ah
		je koniec_10
		sub cl, '0'
		mul ebx
		add eax, ecx
		jmp zamiana_10


	koniec_10:
	add esp, 12
	pop edx
	pop ebx
	pop ecx
	pop esi
	pop edi
	ret
wczytaj_EAX_10 ENDP

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

dzielenie PROC
	;in eax divident
	;in ebx divisor
	pusha
	sub esp, 12
	mov edi, esp

	xor esi, esi

	;normal division
	xor edx, edx
	div ebx

	;handle showing eax to external function
	call wyswietl_EAX_10


	or edx, edx ;check if there will be any decimal
	jz koniec

	mov byte ptr [edi], ','
	inc esi
	mov ecx, 3 ;number of decimal points
	imul eax, edx, 10 ;move comma to eax

	;assuming decmials now
	dziel_3_comma:
	xor edx, edx
	div ebx
	mov al, [dekoder + eax]
	mov byte ptr [edi + esi], al
	imul eax, edx, 10	
	inc esi	
	dec ecx
	or edx, edx
	jz koniec ;finished dividing
	jecxz koniec
	cmp esi, 10
	jae koniec_max_buf
	jmp dziel_3_comma
	
koniec_max_buf:
	inc esi

koniec:
	mov byte ptr [edi + esi], 0
	push esi
	push edi
	push 1
	call __write

	add esp, 24
	popa
	ret
dzielenie ENDP

_main PROC

	call wczytaj_EAX_10
	push eax
	call wczytaj_EAX_10
	mov ebx, eax
	pop eax
	
	call dzielenie

	push 0
	call _ExitProcess@4
_main ENDP
END
