.686
.model flat

.data
jedynka dd 1.0

.code
_srednia_harm PROC
	push ebp
	mov ebp, esp
	push ebx
	push esi

	mov ebx, [ebp + 8]
	mov ecx, [ebp + 12]

	push ecx
	xor esi,esi
	fldz

	petla:
	fld jedynka
	fld dword ptr [ebx + 4*esi]
	inc esi
	;st(2) = wynik
	;st(1) = jedynka
	;st(0) = an
	fdiv
	fadd

	loop petla

	fild dword ptr [esp] ;dodanie n na wiercholek
	add esp,4

	fdiv st(0), st(1)

	pop esi
	pop ebx
	pop ebp
	ret
_srednia_harm ENDP
END
