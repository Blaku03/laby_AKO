.686
.model flat

public _main
extern _ExitProcess@4 : proc
extern _MessageBoxA@16 : proc


.data
tekst	db 41h
		db 6bh
		db 6fh
		db 0
		db 41h,6bh,6fh,00
		db 'A','k','o',0h

y		dw 'A','k','o'

		dw 'Ak','oo'

tytul	db 'Ako',0
x		dd 11223344h



.code
_main PROC

	

	push 4 ; uType
	push OFFSET tekst
	push OFFSET tytul
	push 0  ; hwnd
	call _MessageBoxA@16


	push 4
	call _ExitProcess@4

_main ENDP

END