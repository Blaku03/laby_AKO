.686
.model flat

extern __read : PROC
extern __write : PROC
extern _MessageBoxW@16 : PROC
extern _MessageBoxA@16 : PROC
extern _ExitProcess@4 : PROC

public _main

.data
utf16BE db '0','A','0','l','0','a','0',' ','0','m','0','a'
dlugosc_BE equ $-utf16BE
utf16LE dw 80 dup (0), 0
lancuch_do_usuniecia db 4 dup (?)

tytul dw 'U','t','f','-','1','6',0
.code 
_main PROC

mov ecx, dlugosc_BE
xor edi, edi
xor esi, esi
xor ebx, ebx
inc esi
ptl:
mov bl, utf16BE[esi]
add esi, 2

mov utf16LE[2*edi], bx
inc edi

sub ecx,2
jnz ptl

push 0
push OFFSET tytul
push OFFSET utf16LE
push 0
call _MessageBoxW@16


push 0
call _ExitProcess@4

_main ENDP
END