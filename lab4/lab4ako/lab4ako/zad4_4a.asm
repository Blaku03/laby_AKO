.686
.model flat

public _przestaw

.code
_przestaw PROC
	push ebp
	mov ebp, esp
	push ebx
	push esi

	mov ebx, [ebp + 8] ;adres tablicy
	mov ecx, [ebp + 12] ;liczba elementow
	xor esi, esi
	dec ecx

	petla:
		mov edx, [ebx + esi] ;0
		add esi, 4 ;elementy sa 4bajtowe
		mov eax, [ebx + esi] ;1

		cmp edx, eax
		jle next_itr	

		;zamiana elemetnow
		mov [ebx + esi - 4], eax 
		mov [ebx + esi], edx

		next_itr:
	loop petla

	pop esi
	pop ebx
	pop ebp
	ret
_przestaw ENDP
END