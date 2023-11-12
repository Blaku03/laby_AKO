.686
.model flat
extern _ExitProcess@4 : PROC
extern __write : PROC
extern __read : PROC
public _main

.data
dekoder db '0123456789ABCDEF'

.code

wyswietl_EAX_dwun PROC
	pusha
	sub esp, 12
	mov ebp, esp

	mov byte ptr [ebp], 0
	mov esi, 11
	mov ebx, 12 ;dzielna
	mov ecx, 4 ;spacja co 3 znaki

	mov edi, 0 ;licznik

	zapis_tablica:
	inc edi
	cmp edi, ecx
	jne dalej_nie_skok
	mov edi, 0
	mov byte ptr [ebp + esi], ' '
	dec esi
	jmp zapis_tablica
	dalej_nie_skok:
	xor edx, edx
	div ebx
	push ebx
	mov bl, dekoder[edx]
	mov byte ptr [ebp + esi], bl
	pop ebx
	dec esi
	jz wypisz_konsola
	cmp eax, 0
	jnz zapis_tablica

	dopeln_tablice:
	or esi, esi
	jz wypisz_konsola
	mov byte ptr [ebp + esi], 0
	dec esi
	jmp dopeln_tablice


	wypisz_konsola:
	push dword PTR 12
	push ebp
	push dword PTR 1
	call __write
	add esp, 24
	popa
	ret
wyswietl_EAX_dwun ENDP


wyswietl_EAX PROC
	pusha
	sub esp, 12
	mov ebp, esp

	mov byte ptr [ebp], 0

	mov ebx, 10 ; dzielna
	mov esi, 11 ; indeks zaczynajacy wpisywanie do tablicy

	zapisz_w_tablicy:
	xor edx, edx
	div ebx
	add dl, 30h ; zapisz w ascii
	mov [ebp + esi], dl ; zapisz reszte z dzielenia
	dec esi
	or esi, esi ; maksymalna dlugosc liczby
	jz wypisz_konsola
	or eax, eax ; sprawdzenie czy iloraz 0
	jnz zapisz_w_tablicy

	dopelnij_tablice:
	or esi, esi
	jz wypisz_konsola
	mov byte ptr [ebp + esi], 0
	dec esi
	jmp dopelnij_tablice

	wypisz_konsola:
	push dword PTR 12
	push ebp
	push dword PTR 1
	call __write
	add esp, 24

	popa
	ret
wyswietl_EAX ENDP

wczytaj_do_EAX_hex PROC
	; wczytywanie liczby szesnastkowej z klawiatury � liczba po
	; konwersji na posta� binarn� zostaje wpisana do rejestru EAX
	; po wprowadzeniu ostatniej cyfry nale�y nacisn�� klawisz
	; Enter
	push ebx
	push ecx
	push edx
	push esi
	push edi
	push ebp
	; rezerwacja 12 bajt�w na stosie przeznaczonych na tymczasowe
	; przechowanie cyfr szesnastkowych wy�wietlanej liczby
	sub esp, 12 ; rezerwacja poprzez zmniejszenie ESP
	mov esi, esp ; adres zarezerwowanego obszaru pami�ci
	push dword PTR 10 ; max ilo�� znak�w wczytyw. liczby
	push esi ; adres obszaru pami�ci
	push dword PTR 0; numer urz�dzenia (0 dla klawiatury)
	call __read ; odczytywanie znak�w z klawiatury
	; (dwa znaki podkre�lenia przed read)
	add esp, 12 ; usuni�cie parametr�w ze stosu
	mov eax, 0 ; dotychczas uzyskany wynik
	pocz_konw:
	mov dl, [esi] ; pobranie kolejnego bajtu
	inc esi ; inkrementacja indeksu
	cmp dl, 10 ; sprawdzenie czy naci�ni�to Enter
	je gotowe ; skok do ko�ca podprogramu
	; sprawdzenie czy wprowadzony znak jest cyfr� 0, 1, 2 , ..., 9
	cmp dl, '0'
	jb pocz_konw ; inny znak jest ignorowany
	cmp dl, '9'
	ja sprawdzaj_dalej
	sub dl, '0' ; zamiana kodu ASCII na warto�� cyfry
	dopisz:
	shl eax, 4 ; przesuni�cie logiczne w lewo o 4 bity
	or al, dl ; dopisanie utworzonego kodu 4-bitowego
	 ; na 4 ostatnie bity rejestru EAX
	jmp pocz_konw ; skok na pocz�tek p�tli konwersji
	; sprawdzenie czy wprowadzony znak jest cyfr� A, B, ..., F
	sprawdzaj_dalej:
	cmp dl, 'A'
	jb pocz_konw ; inny znak jest ignorowany
	cmp dl, 'F'
	ja sprawdzaj_dalej2
	sub dl, 'A' - 10 ; wyznaczenie kodu binarnego
	jmp dopisz
	; sprawdzenie czy wprowadzony znak jest cyfr� a, b, ..., f
	sprawdzaj_dalej2:
	cmp dl, 'a'
	jb pocz_konw ; inny znak jest ignorowany
	cmp dl, 'f'
	ja pocz_konw ; inny znak jest ignorowany
	sub dl, 'a' - 10
	jmp dopisz
	gotowe:
	; zwolnienie zarezerwowanego obszaru pami�ci
	add esp, 12
	pop ebp
	pop edi
	pop esi
	pop edx
	pop ecx
	pop ebx
	ret
wczytaj_do_EAX_hex ENDP

_main PROC

	call wczytaj_do_EAX_hex	
	call wyswietl_EAX_dwun

	push 0
	call _ExitProcess@4
_main ENDP
end