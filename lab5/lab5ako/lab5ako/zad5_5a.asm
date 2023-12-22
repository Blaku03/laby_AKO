.686
.xmm
.model flat

.data
jedynki dd 4 dup (1.0)

.code
_pm_jeden PROC
	push ebp
	mov ebp, esp

	mov esi, [ebp + 8]
	movups	xmm1, [esi]
	movups xmm2, jedynki

	addsubps xmm1, xmm2

	movups	[esi], xmm1

	pop ebp
	ret
_pm_jeden ENDP
END