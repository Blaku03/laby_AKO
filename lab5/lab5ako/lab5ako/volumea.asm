.686
.model flat
.data
cztery dd 4.0
trzy dd 3.0

.code
_objetosc_kuli PROC
	push ebp
	mov ebp, esp

	fld dword ptr [ebp + 8]
	fmul st(0),st(0)
	fmul dword ptr [ebp + 8]
	fldpi
	fmul
	fdiv dword ptr [trzy] 
	fmul dword ptr [cztery]

	pop ebp
	ret
_objetosc_kuli ENDP
END
