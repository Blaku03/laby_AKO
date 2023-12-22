.386
rozkazy SEGMENT	USE16
ASSUME CS:rozkazy

clock_interrupt PROC
	push ax
	push bx
	push es

	mov al, cs:interupt_counter
	cmp al, 18; 1000ms / 55ms
	jz wykonaj

	inc al
	mov cs:interupt_counter, al
	jmp koniec

wykonaj:
	mov byte ptr cs:interupt_counter, 0

	mov ax, 0B800h ;multiplied by 16 automaticly
	mov es, ax

	mov bx, cs:licznik 

	mov byte ptr es:[bx], '*'
	mov byte ptr es:[bx+1], 00011110b ;yellow on blue

	add bx, 2

	cmp bx, 4000 ;end of screen 25 * 160
	jb wysw_dalej

	mov bx, 0
	
wysw_dalej:

	mov cs:licznik, bx

koniec:
	pop es
	pop bx
	pop ax

	jmp dword ptr cs:wektor8
wektor8 dd ?
licznik dw 160
interupt_counter db 0
;25 wierszy po 160 znakow kazdy
clock_interrupt ENDP

begin:
mov al, 0 ;page number
mov ah, 5 ;active display page
int 10

mov ax, 0
mov ds, ax

mov eax, ds:[32] ;zapisanie orginalnego wektor8
mov cs:wektor8, eax

;nadpisanie wlasnym clock interrupt
mov bx, SEG clock_interrupt
mov ax, OFFSET clock_interrupt

cli
mov ds:[32], ax
mov ds:[34], bx
sti

;czekanie na klawisz
wait_for_x:
	mov ah,1
	int 16h

;zf flag is set when key pressed
jnz wait_for_x

;odczytanie klawisza
mov ah, 0
int 16h

cmp al, 'x'
jnz wait_for_x

mov eax, cs:wektor8
cli
mov ds:[32], eax
sti

; zakoñczenie programu
mov al, 0
mov ah, 4CH
int 21H

rozkazy ENDS
custom_stos SEGMENT	stack
db 128 dup (?)
custom_stos ENDS
END begin
