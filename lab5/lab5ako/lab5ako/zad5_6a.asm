.686
.XMM
.model flat

.data
ALIGN 16
tabl_A dd 1.0, 2.0, 3.0, 4.0
tabl_B dd 2.0, 3.0, 4.0, 5.0
tabl_C dd 3.0, 4.0, 5.0, 6.0
liczba db 1

.code
_dodawanie_SSE PROC
	
	mov ecx, 65535
	mov edx, 5
	add cx, dx
	sbb edx, edx
	neg edx
	bts ecx, edx

	xor eax, eax
	cmp eax, 0
	jz zero
	nop
	fild tabl_C
	fst tabl_C
	

	;jz = zf = 1 = je 
	;jnz = zf = 0 = jne

	zero:
	mov ebp, esp
	mov eax, [ebp+8]

	movaps xmm2, tabl_A
	movaps xmm3, tabl_B
	movaps xmm4, tabl_C
	
	addps xmm2, xmm3
	addps xmm2, xmm4

	movups [eax], xmm2

	pop ebp
	ret
_dodawanie_SSE ENDP
END