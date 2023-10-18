.686
.model flat
extern _ExitProcess@4 : PROC
extern __write : PROC
extern __read : PROC
public _main

.data
obszar db 12 dup (?)
dziesiec dd 10 ; mnoznik
znaki db 12 dup (?)
	
.code
wyswietl_EAX PROC
	pusha
	mov ebx, 10 ; dzielna
	mov esi, 11 ; indeks zaczynajacy wpisywanie do tablicy

	zapisz_w_tablicy:
	xor edx, edx
	div ebx
	add dl, 30h ; zapisz w ascii
	mov znaki[esi], dl ; zapisz reszte z dzielenia
	dec esi
	or esi, esi ; maksymalna dlugosc liczby
	jz wypisz_konsola
	or eax, eax ; sprawdzenie czy iloraz 0
	jnz zapisz_w_tablicy

	dopelnij_tablice:
	or esi, esi
	jz wypisz_konsola
	mov znaki[esi], 0
	dec esi
	jmp dopelnij_tablice

	wypisz_konsola:
	push dword PTR 12
	push OFFSET znaki
	push dword PTR 1
	call __write
	add esp, 12

	popa
	ret
wyswietl_EAX ENDP

wczytaj_EAX PROC
	push dword PTR 12 ; max ilosc znakow wczytywanej liczby
	push dword PTR OFFSET obszar
	push dword PTR 0 ; numer urzadzenia (0 dla klawiatury)
	call __read ; odczytywanie znaków z klawiatury
	add esp, 12

	mov eax, 0
	mov ebx, dword PTR OFFSET obszar ; adres obszaru ze znakami

	pobieraj_znaki:
	mov cl, [ebx] ; pobranie kolejnej cyfry w kodzie ASCII
	inc ebx
	cmp cl,10 ; sprawdzenie czy nacisnieto Enter
	je byl_enter
	sub cl, 30H ; zamiana kodu ASCII na wartosc cyfry
	movzx ecx, cl
	mul dword PTR dziesiec
	add eax, ecx
	jmp pobieraj_znaki
	byl_enter:
	ret
wczytaj_EAX ENDP

kwadrat_EAX PROC
	mul eax
	ret
kwadrat_EAX ENDP	

_main PROC

	call wczytaj_EAX	
	call kwadrat_EAX
	call wyswietl_EAX	

	push 0
	call _ExitProcess@4
_main ENDP
end