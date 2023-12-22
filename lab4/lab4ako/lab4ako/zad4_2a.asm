.686
.model flat

public _plus_jeden 
public _przeciwna
.code 
_przeciwna PROC
	push ebp
	mov ebp, esp

	mov eax, [ebp + 8]

	neg dword ptr [eax]

	pop ebp
	ret
_przeciwna ENDP

_plus_jeden PROC
	push ebp
	mov ebp, esp

	mov eax, [ebp + 8]
	add dword ptr [eax], 1

	pop ebp
	ret
_plus_jeden ENDP
END
