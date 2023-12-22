.686
.model flat

.code
_power_e PROC
	push ebp
	mov ebp, esp
	mov eax, [ebp + 8]

	fild dword ptr [ebp + 8]
	fldl2e
	fmul
	fst st(1)
	frndint	
	fsub st(1), st(0)
	fxch 
	;st(0) czesc ulamkowa st(1) czesc calkowita
	f2xm1
	fld1
	fadd
	fscale
	fstp st(1) ;usuniecie wartosci stosu z st(1)

	pop ebp
	ret
_power_e ENDP
END