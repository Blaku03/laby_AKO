.686
.model flat

extern _ExitProcess@4 : PROC
extern _MessageBoxW@16 : PROC

.data
utf8 db 50H, 6FH, 0C5H, 82H, 0C4H, 85H, 63H, 7AH, 65H, 6EH, 69H, 61H, 20H
;utf8 db 0C5h,0BCh,61h,62h,61h,0C5h,0BCh,61h
dlugosc equ $-utf8
title_mes dw 'U','t','f','1','6',0
utf16 dw 80 dup (0),0

.code
_main PROC

	xor esi,esi
	xor edi, edi
	mov ecx, dlugosc

	ptl:
	xor ebx, ebx
	xor eax, eax
	xor edx, edx
	mov bl, utf8[esi]
	inc esi

	cmp bl, 0C0h
	jbe zero_bytes ; number of more bytes to read

	cmp bl, 0E0h
	jbe one_bytes

	;cmp bl, xxx
	;jbe two_bytes

	;cmp bl, xxx
	;jbe three_bytes

	one_bytes:
	;---- getting bytes
	sub bl, 0C0h
	mov bh, utf8[esi]
	inc esi
	sub bh, 80h

	;--- just to be easier to read :D
	xchg bl, bh

	;---second byte----
	mov al, 30h
	and al, bl
	shr al, 4

	mov ah, 3
	and ah, bh

	movzx dx, ah
	shr ah, 2

	shl dx, 2
	add dx, ax; get second byte

	;---- cleaning
	shr bh, 2; clean first byte

	shl bl,4
	shr bl,4; clean third byte
	;---- combining
	shl dx, 4
	
	add dl, bl
	mov utf16[2*edi], dx
	inc edi
	shr bx,8 ; gettting rid of bl
	mov utf16[2*edi-1], bx
	sub ecx,2

	jmp next_itr

	zero_bytes:
	mov utf16[2*edi], bx
	inc edi
	dec ecx
	next_itr:
	cmp ecx, 0
	jg ptl

	mov utf16[2*edi], word PTR 0

	push 1
	push OFFSET title_mes
	push OFFSET utf16
	push 0
	call _MessageBoxW@16

	push 0
	call _ExitProcess@4
	
_main ENDP
END