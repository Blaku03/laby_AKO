.686
.model flat
extern __write : PROC
extern _ExitProcess@4 : PROC
public _main
.data
tekst db "¹A\\\\\\la ma kot¹ó",0
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

	;checking for special small letter
	;!From call its latin2 from vs its win1250
	cmp dl, 185 ; a
	je special_a
	cmp dl, 134 ; c
	je special_c
	cmp dl, 169 ; e
	je special_e
	cmp dl, 136 ; l
	je special_l
	cmp dl, 228 ; n
	je special_n
	cmp dl, 162 ; o
	je special_o
	cmp dl, 152 ; s
	je special_s
	cmp dl, 190 ; z_dot
	je special_z_dot
	cmp dl, 171 ; z_dash
	je special_z_dash

	jmp not_polish_letter

	special_a: mov tekst_BIG[ebx + esi], 164 
	jmp dalej_no_move
	special_c: mov tekst_BIG[ebx + esi], 143 
	jmp dalej_no_move
	special_e: mov tekst_BIG[ebx + esi], 168 
	jmp dalej_no_move
	special_l: mov tekst_BIG[ebx + esi], 157 
	jmp dalej_no_move
	special_n: mov tekst_BIG[ebx + esi], 227 
	jmp dalej_no_move
	special_o: mov tekst_BIG[ebx + esi], 224 
	jmp dalej_no_move
	special_s: mov tekst_BIG[ebx + esi], 151 
	jmp dalej_no_move
	special_z_dot: mov tekst_BIG[ebx + esi], 189
	jmp dalej_no_move
	special_z_dash:mov tekst_BIG[ebx + esi], 141 
	jmp dalej_no_move

	not_polish_letter:
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