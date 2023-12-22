.686
.model flat

.code
_uint48_float PROC
	push ebp
	mov ebp, esp

	mov eax, [ebp + 8] ;16bit calk, 16bit zmien
	mov ebx, [ebp + 12] ;16bit calk

	;wyznaczenie wykladnika
	xor edx, edx
	mov dx, ax ;zapisanie 16bit zmien
	shr eax, 16
	or eax, ebx ;zlaczenie calej calk
	mov ecx, 31 
	wyznacz:
		or ecx, ecx
		jz mniejsze_zero
		bt eax, ecx
		dec ecx
	jnc wyznacz
	
	or ecx, ecx
	jz mniejsze_zero
	inc ecx
	push ecx ;przydatne potem
	btr eax, ecx
	add ecx, 127 ;wykladnik w ecx
	;proste podejscie matysa 16bit - zmien, maks 7bit calk
	;mozna by lepiej (wykrywac ile jest znaczacych liczb w calk i zmien)

	shl eax, 16
	or eax, edx ;23bit mantysy
	and eax, 007fffffh ;wyczyszczenie wykladnika i znaku

	;poprawienie mantysy (bo 7 - obecnie)
	mov edx, ecx
	pop ecx
	inc ecx
	shl eax, cl

	shl edx, 23
	or eax, edx

	jmp koniec
	mniejsze_zero:

	koniec:
	push eax
	fld dword ptr [esp]
	add esp, 4

	pop ebp
	ret
_uint48_float ENDP
END