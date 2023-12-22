.686
.xmm
.model flat

.code
_sumy_elementow PROC
	push ebp
	mov ebp, esp

	mov esi, [ebp + 8]
	mov edi, [ebp + 12]
	mov ebx, [ebp + 16]

	movdqu xmm0, [esi]
	movdqu xmm1, [edi]
	paddb xmm0, xmm1

	movdqu [ebx], xmm0

	pop ebp
	ret
_sumy_elementow ENDP
END