.686
.xmm
.model flat

.data
dzielnik dd 4 dup (?)

.code
_dziel PROC

	push ebp
	mov ebp, esp

	;zapisanie dzielnika w pamieci:
	mov edx, [ebp + 16]
	xor esi, esi
	mov ecx, 4
	przydziel:
		mov [OFFSET dzielnik + 4*esi], edx
		inc esi
	loop przydziel

	;dzielenie
	mov ecx, [ebp + 12]
	mov edi, [ebp + 8]
	xor esi, esi

	dziel:
		movups xmm5, [edi + esi]
		divps xmm5, xmmword ptr dzielnik
		movups [edi + esi], xmm5
		add esi, 16 
	loop dziel

	pop ebp
	ret
_dziel ENDP
END