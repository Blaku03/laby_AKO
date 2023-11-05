.686
.model flat
extern _ExitProcess@4 : PROC
extern __write : PROC
extern __read : PROC
public _main

.data
dekoder db '0123456789ABCDEF'
dziesiec dd 10
obszar db 12 dup (?)

.code
wyswietl_EAX_hex PROC
	pusha

	sub esp, 12
	mov ebp, esp
	mov ecx, 8
	mov esi, 1
	ptl3hex:
	rol eax, 4
	mov ebx, eax
	and ebx, 0000000FH
	mov dl, dekoder[ebx] ; pobranie cyfry z tablicy
	; przes³anie cyfry do obszaru roboczego
	mov [ebp + esi], dl
	inc esi ;inkrementacja modyfikatora
	loop ptl3hex ; sterowanie pêtl¹

	mov esi, 1
	mov ecx, 8
	ptl_0_space:
	cmp byte ptr [ebp + esi], '0'
	jne wypisz
	mov byte ptr [ebp + esi], ' '
	inc esi
	loop ptl_0_space

	wypisz:
	mov byte PTR [ebp], 10
	mov byte PTR [ebp + 9], 10

	push 10
	push ebp
	push 1 
	call __write 
	add esp, 24

	popa
	ret
wyswietl_EAX_hex ENDP

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

_main PROC

	call wczytaj_EAX	
	call wyswietl_EAX_hex	

	push 0
	call _ExitProcess@4
_main ENDP
end