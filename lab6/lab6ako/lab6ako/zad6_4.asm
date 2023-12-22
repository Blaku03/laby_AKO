.386
rozkazy SEGMENT	USE16
ASSUME CS:rozkazy

wyswietl_al PROC
	push ax
	push cx
	push bx
	push es

	mov cx, 0B800h ;multiplied by 16 automaticly
	mov es, cx

	mov bx, 160
	mov cl, 10 ; dzielnik

	mov ah, 0 
	div cl
	add ah, 30H ; zamiana na kod ASCII
	mov es:[bx+4], ah ; cyfra jednosci
	;mov byte ptr es:[bx+4], '*'

	mov ah, 0
	div cl ; drugie dzielenie przez 10
	add ah, 30H ; zamiana na kod ASCII
	mov es:[bx+2], ah ; cyfra dziesi¹tek
	;mov byte ptr es:[bx+2], '*'

	add al, 30H ; zamiana na kod ASCII
	mov es:[bx+0], al ; cyfra setek
	;mov byte ptr es:[bx+2], '*'

	; wpisanie kodu koloru (intensywny bia³y) do pamieci ekranu
	mov al, 00001111B
	mov es:[bx+1],al
	mov es:[bx+3],al
	mov es:[bx+5],al

	pop es
	pop bx
	pop cx
	pop ax
	ret
wyswietl_al ENDP

odczytaj_klawisz PROC
	push ax
	
	in al, 60h

	;wcisniety ctrl
	cmp al, 0E0h
	jne bez_ctrl
	call wyswietl_al	
	in al, 60h

	bez_ctrl:
	call wyswietl_al	

	pop ax
	jmp dword ptr cs:wektor9
	wektor9 dd ?
odczytaj_klawisz ENDP

begin:
mov al, 0 ;page number
mov ah, 5 ;active display page
int 10

mov ax, 0
mov ds, ax

;zapisanie wektor9
mov eax, ds:[36] 
mov cs:wektor9, eax

;nadpisanie wektor9
mov bx, SEG odczytaj_klawisz
mov ax, OFFSET odczytaj_klawisz

cli
mov ds:[36], ax
mov ds:[38], bx
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

;przywrocenie wektor9
mov eax, cs:wektor9
cli
mov ds:[36], eax
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
