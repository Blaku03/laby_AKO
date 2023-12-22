.386
rozkazy SEGMENT use16
ASSUME cs:rozkazy

linia PROC
	; przechowanie rejestrów
	push ax
	push bx
	push es
	push dx

	mov ax, 0A000H ; adres pamiêci ekranu dla trybu 13H
	mov es, ax

	mov bx, cs:adres_piksela ; adres bie¿¹cy piksela
	mov byte ptr es:[bx], 1 ; wpisanie kodu koloru do pamiêci ekranu

	add bx, cs:zmiana

	; sprawdzenie czy ca³a przekatna wykreœlona
	cmp bx, 320*200
	jb dalej
	mov bx, 319
	mov word ptr cs:zmiana, 318
	dalej:

	
	mov dx, 0
	cmp dx, cs:poprzednia_wart
	jne nie_zmien
	mov word ptr cs:poprzednia_wart, 1

	jmp wpisz
	nie_zmien:
	mov word ptr cs:poprzednia_wart, 0

	wpisz:
	add bx, cs:poprzednia_wart
	mov cs:adres_piksela, bx

	; odtworzenie rejestrów
	pop dx
	pop es
	pop bx
	pop ax
	; skok do oryginalnego podprogramu obs³ugi przerwania
	; zegarowego
	jmp dword PTR cs:wektor8
	; zmienne procedury
	adres_piksela dw 0 ; bie¿¹cy adres piksela
	poprzednia_wart dw 0
	zmiana dw 321
	wektor8 dd ?
linia ENDP

; INT 10H, funkcja nr 0 ustawia tryb sterownika graficznego
zacznij:
mov ah, 0
mov al, 13H ; nr trybu
int 10H

mov bx, 0
mov es, bx ; zerowanie rejestru ES
mov eax, es:[32] ; odczytanie wektora nr 8
mov cs:wektor8, eax; zapamiêtanie wektora nr 8

; adres procedury 'linia' w postaci segment:offset
mov ax, SEG linia
mov bx, OFFSET linia

cli ; zablokowanie przerwañ
; zapisanie adresu procedury 'linia' do wektora nr 8
mov es:[32], bx
mov es:[32+2], ax
sti ; odblokowanie przerwañ

czekaj:
mov ah, 1 ; sprawdzenie czy jest jakiœ znak
int 16h ; w buforze klawiatury
jz czekaj

mov ah, 0 ; funkcja nr 0 ustawia tryb sterownika
mov al, 3H ; nr trybu
int 10H

; odtworzenie oryginalnej zawartoœci wektora nr 8
mov eax, cs:wektor8
mov es:[32], eax
; zakoñczenie wykonywania programu

mov ax, 4C00H
int 21H

rozkazy ENDS
stosik SEGMENT stack
db 256 dup (?)
stosik ENDS
END zacznij
