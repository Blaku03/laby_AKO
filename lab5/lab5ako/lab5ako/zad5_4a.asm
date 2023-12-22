.686
.xmm
.model flat

.code
_int2float PROC
	push ebp
	mov ebp, esp

	mov esi, [ebp + 8]
	mov edi, [ebp + 12]

	cvtpi2ps xmm5, qword PTR [esi]
	movups [edi], xmm5

	pop ebp
	ret
_int2float ENDP
END