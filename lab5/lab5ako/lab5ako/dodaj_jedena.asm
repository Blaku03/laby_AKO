.686
.model flat

.code
_dodaj_jeden PROC
	push ebp
	mov ebp, esp

	mov eax, [ebp + 8]
	shr eax, 23
	cmp al, 127
	ja wieksze_jeden
	sub al, 127
	neg al ;wykladnik liczby (ile do jedynki potrzebne)
	mov cl, al

	mov eax, [ebp + 8]
	and eax, 007fffffh ;mantysa podanej liczby
	bts eax, 23
	shr eax, cl

	mov edx, 127 ;zrobienie niejawnej jedynki
	shl edx, 23

	or eax, edx
	jmp koniec

	wieksze_jeden:
	sub al, 127 ;w al wartosc wykladnika

	xor ebx, ebx
	bts ebx, 23
	mov cl, al ;... asm
	shr ebx, cl ;jedynka w stopniu wykladnika podanej liczby

	mov eax, [ebp + 8]
	and eax, 007fffffh ;mantysa podanej liczby
	mov edx, [ebp + 8]
	and edx, 0ff800000h ;wykladnik podanej liczby

	add eax, ebx ;dodanie mantys
	bt eax, 23 ;sprawdzenie czy nastapilo przeniesienie 
	jnc zlaczenie
	;Zwiekszenie wykladnika bo liczba jest za duza
;	shr edx, 23
;	add edx, 1
;	shl edx, 23
	add edx, 100000000000000000000000b

	btr eax, 23
	shr eax, 1

	zlaczenie:
	or eax, edx

	koniec:
	push eax
	fld dword ptr [esp]
	add esp, 4
	pop ebp
	ret
_dodaj_jeden ENDP
END