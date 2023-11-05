.686
.MODEL flat
.DATA
loops equ 5
.CODE
_main PROC
	mov ecx, 0
	mov eax, 0
	loop_body:
		inc ecx
		inc eax
		cmp ecx, 5
		jl loop_body

	ret
_main ENDP
END



