.686
.model flat
extern _ExitProcess@4 : PROC
extern _MessageBoxA@16 : PROC
extern _MessageBoxW@16 : PROC
public _main
.data

	tytul_ZadanieU dw 'Z', 'n', 'a', 'k', 'i', 0
	tekst_ZadanieU dw 'T', 'o', ' ', 'j', 'e', 's', 't', ' ', 's'
	dw 'a', 't', 'e', 'l', 'i', 't', 'a', 0D83DH, 0DEF0H, ' ', 'o', 'r', 'a', 'z', ' ', 'U', 'F', 'O', 0D83DH, 0DEF8H, 0
.code
_main PROC
	push 0
	push OFFSET tytul_ZadanieU
	push OFFSET tekst_ZadanieU
	push 0
	call _MessageBoxW@16
	push 0
	call _ExitProcess@4
_main ENDP
END
