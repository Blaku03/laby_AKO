.686
.model flat

.data
;2x^2 -x - 15 = 0
wsp_a dd +2.0
wsp_b dd -1.0
wsp_c dd -15.0
dwa dd 2.0
cztery dd 4.0
x1 dd ?
x2 dd ?
data dd 00d73000h

.code
_fun PROC
	mov ax, 1
	mov cx, word ptr data
	db 66h, 8bh, 0dh, 00h, 30h, 0d7h, 00h

	mov cx, word ptr [data + ebp]
	db 66h, 8bh, 0ch, 2dh, 00h, 30h, 0d7h, 00h



	finit
	fld wsp_a
	fld wsp_b
	fst st(2)

	fmul st(0), st(0) ;b^2
	fld cztery

	fmul st(0), st(2) ;4*a
	fmul wsp_c ;4*a*c

	;st(1) -> b^2, st(0) -> 4ac
	fsub

	fldz
	fcomi st(0), st(1)
	fstp st(0)
	;ja delta_ujemna
	;tylko gdy sa pierwiastki

	fxch st(1)
	fadd st(0), st(0)
	fstp st(3)
	;st(0) b^2 - 4ac
	;st(1) = b
	;st(2) = 2*a
	fsqrt
	fst st(3)

	fchs
	fsub st(0), st(1)
	fdiv st(0), st(2)
	fstp x1

	;st(0) = b
	;st(1) = 2*a
	;st(2) = sqrt(b^2-4ac)

	fchs
	fadd st(0), st(2)
	fdiv st(0), st(1)
	fstp x2

	fstp st(0)
	fstp st(0)

	ret
_fun ENDP
END