.686
.model flat

.code
_nowy_exp PROC
	push ebp
	mov ebp, esp

	fld1
	fld1
	fld1
	mov ecx, 20 ;ilosc iteracji
	mov eax, 1
	;st(0) = x^
	;st(1) = 1*2*3...
	;st(2) = wynik

	petla:
	;wymnozenie x
	fld dword ptr [ebp + 8]
	fmul
	;st(0) = x^
	;st(1) = 1*2*3...
	;st(2) = wynik

	;zaldowanie kolejnej wartosci iteracji
	fxch 
	push eax
	fild dword ptr [esp]
	add esp,4
	inc eax
	fmul
	;st(0) = 1*2*3
	;st(1) = x^
	;st(2) = wynik

	;zapisanie wartosci na kolejne iteracje
	sub esp, 8
	fst dword ptr [esp] ;1*2*3
	fxch
	fst dword ptr [esp+4] ;x^

	; dodanie do wyniku
	fxch
	fdiv
	fadd

	fld dword ptr [esp]
	fld dword ptr [esp+4]
	add esp, 8

	loop petla
	
	fstp st(0)
	fstp st(0)

	pop ebp
	ret
_nowy_exp ENDP
END