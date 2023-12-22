.686
.model flat

public _szukaj_max
public _szukaj4_max

.code 
_szukaj4_max PROC
	push ebp 
	mov ebp, esp

	mov eax, [ebp + 8] ;a

	mov ecx, [ebp + 12] ;b
	cmp eax, ecx
	cmovl eax, ecx ;max is in eax

	mov ecx, [ebp + 16]
	cmp eax, ecx
	cmovl eax, ecx ;max is in eax

	mov ecx, [ebp + 20]
	cmp eax, ecx
	cmovl eax, ecx ;max is in eax

	pop ebp
	ret
_szukaj4_max ENDP

_szukaj_max PROC
	push ebp
	mov ebp, esp

	mov eax, [ebp + 8] ;x
	mov ecx, [ebp + 12] ;y

	cmp eax, ecx
	cmovl eax, ecx ;max is in eax

	mov ecx, [ebp + 16]
	cmp eax, ecx
	cmovl eax, ecx ;max is in eax
	
	pop ebp
	ret
_szukaj_max ENDP
END