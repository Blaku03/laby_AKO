.686
.model flat
extern __write : PROC
extern _ExitProcess@4 : PROC
public _main

.data
znaki db 12 dup (0),0

.code
wyswietl_EAX_new_line PROC
	pusha
	mov esi, 10 ; indeks w tablicy 'znaki'
	mov ebx, 10 ; dzielnik rowny 10
	konwersja:
	mov edx, 0 ; zerowanie starszej czesci dzielnej
	div ebx ; dzielenie przez 10, reszta w EDX, iloraz w EAX
	add dl, 30H ; zamiana reszty z dzielenia na kod ASCII
	mov znaki[esi], dl; zapisanie cyfry w kodzie ASCII
	dec esi ; zmniejszenie indeksu
	cmp eax, 0 ; sprawdzenie czy iloraz = 0
	jne konwersja ; skok, gdy iloraz niezerowy
	; wypelnienie pozostalych bajtow spacjami i wpisanie
	; znakow nowego wiersza
	wypeln:
	or esi, esi
	jz wyswietl ; skok, gdy ESI = 0
	mov byte PTR znaki[esi], 20H ; kod spacji
	dec esi ; zmniejszenie indeksu
	jmp wypeln
	wyswietl:
	mov byte PTR znaki [0], 0AH ; kod nowego wiersza
	mov byte PTR znaki [11], 0AH ; kod nowego wiersza
	; wyswietlenie cyfr na ekranie
	push dword PTR 12 ; liczba wyswietlanych znakow
	push dword PTR OFFSET znaki ; adres wysw. obszaru
	push dword PTR 1; numer urzadzenia (ekran ma numer 1)
	call __write ; wyswietlenie liczby na ekranie
	add esp, 12 ; usuniecie parametrów ze stosu
	popa
	ret
wyswietl_EAX_new_line ENDP

wyswietl_EAX_comma PROC
	pusha
	mov ebx, 10 ; dzielna
	mov esi, 10 ; indeks zaczynajacy wpisywanie do tablicy

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
	
	mov znaki[esi], 20h ; zapisz spacje przed liczba
	dec esi

	dopelnij_tablice:
	or esi, esi
	jz wypisz_konsola
	mov znaki[esi], 0
	dec esi
	jmp dopelnij_tablice

	wypisz_konsola:
	mov znaki[11], 2Ch ; comma
	push dword PTR 12
	push OFFSET znaki
	push dword PTR 1
	call __write
	add esp, 12

	popa
	ret
wyswietl_EAX_comma ENDP

_main PROC

	mov ecx, 50 ; number of digits
	mov ebx, 0 ; increment value
	mov eax, 1

	wypisz_liczby:
	add eax, ebx
	call wyswietl_EAX_comma
	inc ebx
	dec ecx
	jnz wypisz_liczby

	push 0
	call _ExitProcess@4
_main ENDP
END