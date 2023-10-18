.686
.model flat
extern __write : PROC
extern _ExitProcess@4 : PROC
public _main
.data
tekst db "\A\\\\\\la ma k\\\\\\\\ota",0
dlugosc equ $ - tekst
tekst_BIG db 4*dlugosc dup (?)
.code

_main proc
	mov ecx, dlugosc
	xor ebx, ebx
	xor esi, esi
	mov eax, 0
	ptl:
	mov dl, byte PTR tekst[ebx]

	cmp dl , '\'
	jne not_special_char
	
	;check if previous char was \
	cmp eax, 1
	je dalej_no_move

	mov eax, 1

	;change to space
	push ecx
	mov ecx, 0
	space_ptl:
	mov tekst_BIG[ebx + esi], 20h
	inc ecx
	inc esi
	cmp ecx, 4
	jne space_ptl

	pop ecx
	jmp dalej_no_move

	not_special_char:
	cmp dl, 'a'
	jb dalej 
	cmp dl, 'z'
	ja dalej

	sub dl, 20h ; lower the case

	dalej:
	mov tekst_BIG[ebx + esi], dl
	mov eax, 0
	dalej_no_move:
	inc ebx
	dec ecx
	jnz ptl

	mov tekst_BIG[ebx + esi], 0

	push dlugosc*4
	push OFFSET tekst_BIG
	push 1
	call __write
	add esp, 12

	push 0
	call _ExitProcess@4
_main endp
end