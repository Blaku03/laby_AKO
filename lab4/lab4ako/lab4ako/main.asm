.686
.model flat
.data
.code 
_main PROC

	xor eax, eax
	test eax, eax
	cmovz eax, ebx
	ret
_main ENDP
END