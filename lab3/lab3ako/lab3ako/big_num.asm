.686
.model flat
extern __write : PROC
extern _ExitProcess@4 : PROC

public _main

.data
; deklaracja tablicy 12-bajtowej do przechowywania
; tworzonych cyfr
dzielnik dd 1
znaki db 12 dup (?)
w2 dd 0
w1 dd 0
w0 dd 0

.code
_wyswietl_EAX PROC
	;push ebp
	;mov ebp,esp
	sub esp, 36  ; rezerwacja zmiennej dynamicznej
	mov edi, esp
	pushad
	;mov eax,[ebp+8]
	mov w2,ecx
	mov w1,edx  ; w1 = a1
	mov w0,eax  ; w0 = a0
	;lea edi,[ebp-12]
		
	mov esi, 34 ; indeks w tablicy 'znaki' 
	mov ebx, 10 ; dzielnik r�wny 10

konwersja: 
	mov edx, 0 ; zerowanie starszej cz�ci dzielnej 

	mov eax, w2
	div ebx
	mov w2, eax

	mov eax,w1
	div ebx
	mov w1,eax 

	mov eax,w0
	div ebx
	mov w0,eax

	add dl, 30H ; zamiana reszty z dzielenia na kod ASCII 
	mov [edi][esi], dl; zapisanie cyfry w kodzie ASCII
	dec esi ; zmniejszenie indeksu 

	or eax, w1 ; w1 i w0 =0??? sprawdzenie czy iloraz = 0 
	jne konwersja ; skok, gdy iloraz niezerowy
	or eax, w2
	jne konwersja
; wype�nienie pozosta�ych bajt�w spacjami i wpisanie 
; znak�w nowego wiersza 

wypeln: 
	or esi, esi		; cmp esi,0
	jz wyswietl ; skok, gdy ESI = 0 
	mov byte PTR [edi][esi], 20H ; kod spacji 
	dec esi ; zmniejszenie indeksu 
	jmp wypeln 

wyswietl: 
	mov byte PTR [edi+0], 0AH ; kod nowego wiersza 
	mov byte PTR [edi][35], 0AH ; kod nowego wiersza
; wy�wietlenie cyfr na ekranie 
	push dword PTR 36 ; liczba wy�wietlanych znak�w 
	;push dword PTR OFFSET znaki ; adres wy�w. obszaru 
	push edi
	push dword PTR 1; numer urz�dzenia (ekran ma numer 1) 
	call __write ; wy�wietlenie liczby na ekranie 
	add esp, 12 ; usuni�cie parametr�w ze stosu

	
	popad
	add esp, 36	; usuni�cie zmiennej dynamicznej
	;pop ebp
	ret
_wyswietl_EAX ENDP


_main PROC

	mov ecx, 7fffffffh 
	mov edx, -1
	mov eax, -1
	call _wyswietl_EAX
	push 0
	call _ExitProcess@4
_main ENDP
END
