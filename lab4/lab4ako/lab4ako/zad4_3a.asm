.686
.model flat

public _odejmij_jeden

.code 
_odejmij_jeden PROC
	push ebp
	mov ebp, esp

	mov eax, [ebp + 8] ; **k
	mov eax, [eax]; *k
	dec dword ptr [eax]

	pop ebp
	ret
_odejmij_jeden ENDP
END
