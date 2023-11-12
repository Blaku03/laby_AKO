.686
.model flat
extern __write : PROC
extern __read : PROC
extern _ExitProcess@4 : PROC
public _main

.data
obszar db 12 dup(?),0
dekoder db '0123456789ABCDEF'

.code

wczytaj_EAX_dwun PROC
	;preserve registers changed by __write
	push edx
	push ecx
	push dword PTR 12 ; max ilosc znakow wczytywanej liczby
	push dword PTR OFFSET obszar
	push dword PTR 0 ; numer urzadzenia (0 dla klawiatury)
	call __read ; odczytywanie znaków z klawiatury
	add esp, 12
	pop ecx
	pop edx

	mov eax, 0
	mov ebx, dword PTR OFFSET obszar ; adres obszaru ze znakami

	pobieraj_znaki:
	mov cl, [ebx] ; pobranie kolejnej cyfry w kodzie ASCII
	inc ebx
	cmp cl, 'C'
	ja zakoncz_program

	cmp cl, 0Ah ; sprawdzenie czy nacisnieto Enter
	je byl_enter

	sub cl, 30H ; zamiana kodu ASCII na wartosc cyfry
	movzx ecx, cl
	imul eax, 12
	add eax, ecx
	jmp pobieraj_znaki
	byl_enter:
	ret
	
	zakoncz_program:
	push 0
	call _ExitProcess@4

wczytaj_EAX_dwun ENDP

wyswietl_EAX_dwun PROC
	pushad
	sub esp, 12
	mov ebp, esp

	mov byte ptr [ebp], 0
	mov esi, 11 ;ilosc znakow
	mov ebx, 12 ;dzielna

	zapis_tablica:
	inc edi
	xor edx, edx
	div ebx
	push ebx
	mov bl, dekoder[edx]
	mov byte ptr [ebp + esi], bl
	pop ebx
	dec esi
	jz wypisz_konsola ;skonczylo sie miejsce w pamieci 
	cmp eax, 0
	jnz zapis_tablica

	dopeln_tablice:
	or esi, esi
	jz wypisz_konsola
	mov byte ptr [ebp + esi], 0
	dec esi
	jmp dopeln_tablice


	wypisz_konsola:
	;state of array now : 0000xxxx0 where x is a digit
	mov byte ptr [ebp], 0Ah

	push dword PTR 12
	push ebp
	push dword PTR 1
	call __write
	add esp, 24 ;usuwanie miejsca spod ebp

	popad
	ret
wyswietl_EAX_dwun ENDP


_main PROC

	call wczytaj_EAX_dwun
	mov edx, eax
	call wczytaj_EAX_dwun

	;edx = n
	;eax = p

	mov ecx, 1 ;store what do add or div
	xor ebx, ebx ;bool reg 0 - sub 1 - add
	petla_glowna:
	call wyswietl_EAX_dwun	

	or ebx, ebx ;check if ebx 0
	jz sub_ins
	add eax, ecx
	mov ebx, 0
	jmp next_itr

	sub_ins:
	sub eax, ecx
	mov ebx, 1

	next_itr:
	add ecx, 2
	dec edx
	jnz petla_glowna

	zakoncz_program:
	push 0
	call _ExitProcess@4

_main ENDP
END
