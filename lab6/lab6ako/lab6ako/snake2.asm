.386
rozkazy SEGMENT	USE16
ASSUME CS:rozkazy

snake_pos dw 2000
snake_vector db 0 ;0 - in place, 1 - right, 2 - down, 3 - left, 4 - up

interupt_counter db 0
wektor8 dd ?
wektor9 dd ?


right_key db 77
left_key db 75
up_key db 72
down_key db 80 

last_key_pressed db ?

exit_program PROC
	;restoring the orignal vector function
	mov eax, cs:wektor8
	cli
	mov ds:[32], eax
	sti

	mov eax, cs:wektor9
	cli
	mov ds:[36], eax
	sti

	mov al, 0
	mov ah, 4Ch
	int 21h

	jmp dword ptr cs:wektor8
exit_program ENDP

check_wall PROC
	push ax
	push bx

	;check if snake hit yourself

	cmp cs:snake_pos, 2000
	je game_has_not_started
	mov bx, cs:snake_pos
	cmp byte PTR es:[bx], '*'
	je exit_program

	;check based on current position whether player has hit the wall

	game_has_not_started:
	;check for ceil
	mov bx, cs:snake_pos
	cmp bx, 0
	jl cs:exit_program

	;check left
	mov bl, 160
	mov ax, cs:snake_pos 
	div bl
	cmp ah, 0
	je cs:exit_program

	;check right
	mov bl, 160
	mov ax, cs:snake_pos 
	add ax, 2
	div bl
	cmp ah, 0
	je cs:exit_program

	;check floor
	mov bx, cs:snake_pos
	cmp bx, 4000
	jg cs:exit_program
	
	end_fun:
	pop bx
	pop ax
	ret
check_wall ENDP

;clock interrupt function
move_snake_vector PROC
	push bx
	push dx

	mov bl, cs:snake_vector
	mov dx, cs:snake_pos
	
	;right
	cmp bl, 1
	jne msv_check_down
	add dx, 2
	jmp msv_end_fun

	msv_check_down:
	cmp bl, 2
	jne msv_check_left
	add dx, 160
	jmp msv_end_fun

	msv_check_left:
	cmp bl, 3
	jne msv_check_up
	sub dx, 2
	jmp msv_end_fun

	msv_check_up:
	cmp bl, 4
	jne msv_end_fun
	sub dx, 160

	msv_end_fun:
	mov cs:snake_pos, dx
	pop dx
	pop bx
	ret
move_snake_vector ENDP

change_vector_input PROC
	;cvi - change vector input (to make sure that same label does not exist somwhere in program)
	mov al, last_key_pressed

	cmp al, cs:up_key
	jne cvi_check_right
	mov byte ptr cs:snake_vector, 4
	jmp cvi_end_func

	cvi_check_right:
	cmp al, cs:right_key
	jne cvi_check_down
	mov byte ptr cs:snake_vector, 1
	jmp cvi_end_func

	cvi_check_down:
	cmp al, cs:down_key
	jne cvi_check_left
	mov byte ptr cs:snake_vector, 2
	jmp cvi_end_func

	cvi_check_left:
	cmp al, cs:left_key
	jne cvi_end_func
	mov byte ptr cs:snake_vector, 3

	cvi_end_func:
	ret
change_vector_input ENDP

draw_snake PROC
	push ax
	push bx

	mov ax, 0B800h
	mov es, ax
	mov bx, cs:snake_pos

	mov byte ptr es:[bx], '*'
	mov byte ptr es:[bx+1], 01001111b

	pop bx
	pop ax
	ret
draw_snake ENDP

clock_interrupt PROC
	push ax
	push bx
	push es

	mov al, cs:interupt_counter
	cmp al, 18; 1000ms / 55ms
	jz execute

	inc al
	mov cs:interupt_counter, al
	jmp ci_end_fun

execute:
	call cs:move_snake_vector
	call cs:check_wall
	call cs:draw_snake

ci_end_fun:
	pop es
	pop bx
	pop ax

	jmp dword ptr cs:wektor8
clock_interrupt ENDP

clear_screen PROC
	push bx
	push es
	push ax
	
	mov bx, 0
	mov ax, 0B800h
	mov es, ax

	fill_next_place:
		mov byte PTR es:[bx], ' '
		mov byte PTR es:[bx+1], 0
		add bx, 2
		cmp bx, 4000
	jne fill_next_place

	pop ax
	pop es
	pop bx
	ret
clear_screen ENDP
wyswietl_AL PROC
    ; wyœwietlanie zawartoœci rejestru AL na ekranie wg adresu
    ; podanego w ES:BX
    ; stosowany jest bezpoœredni zapis do pamiêci ekranu
    ; przechowanie rejestrów
    push ax
    push cx
    push dx
    mov cl, 10 ; dzielnik

    mov ah, 0 ; zerowanie starszej czêœci dzielnej
    ; dzielenie liczby w AX przez liczbê w CL, iloraz w AL,
    ; reszta w AH (tu: dzielenie przez 10)
    div cl
    add ah, 30H ; zamiana na kod ASCII
    mov es:[bx+4], ah ; cyfra jednoœci
    mov ah, 0
    div cl ; drugie dzielenie przez 10
    add ah, 30H ; zamiana na kod ASCII
    mov es:[bx+2], ah ; cyfra dziesi¹tek
    add al, 30H ; zamiana na kod ASCII
    mov es:[bx+0], al ; cyfra setek
    ; wpisanie kodu koloru (intensywny bia³y) do pamiêci ekranu
    mov al, 00001111B
    mov es:[bx+1],al
    mov es:[bx+3],al
    mov es:[bx+5],al
    ; odtworzenie rejestrów
    pop dx
    pop cx
    pop ax
    ret ; wyjœcie z podprogramu
wyswietl_AL ENDP

save_last_key_pressed PROC
	push ax
	push bx
	push es

	mov ax, 0B800H ; adres segmentu pamiêci ekranu
    mov es, ax ; do rejestru ES
    mov bx, 0


	in al, 60h

	cmp al, 128 ;sprawdzenie czy odczytana wartosc to kod pozycji lub kod zwolnienia
    jb dalej ;jesli kod pozycji to dalej
    sub al, 128 ;jesli kod zwolnienia to odjecie 128 i dostanie kodu pozycji
	dalej:
	mov cs:last_key_pressed, al
	call wyswietl_AL
	
    

	pop es
	pop bx
	pop ax
	jmp dword PTR cs:wektor9
save_last_key_pressed ENDP


begin:

	mov al, 0 ;page number
	mov ah, 5 ;active display page
	int 10

	call clear_screen

	;setting up the interupt func (saving to wektor8 orginal one)
	mov ax, 0
	mov ds, ax

	mov eax, ds:[32] ;saving clock interrupt function address
	mov cs:wektor8, eax

	;overwriting orginal vector intr
	mov bx, SEG clock_interrupt
	mov ax, OFFSET clock_interrupt

	cli
	mov ds:[32], ax
	mov ds:[34], bx
	sti

	mov eax,ds:[36] ; adres fizyczny 0*16 + 36 = 36
	mov cs:wektor9, eax

	; wpisanie do wektora nr 9 adresu procedury 'obsluga_klawiatury'
	mov ax, SEG save_last_key_pressed ; czêœæ segmentowa adresu
	mov bx, OFFSET save_last_key_pressed ; offset adresu
	cli ; zablokowanie przerwañ
	; zapisanie adresu procedury do wektora nr 9
	mov ds:[36], bx ; OFFSET
	mov ds:[38], ax ; cz. segmentowa
	sti ;odblokowanie przerwañ




	call cs:draw_snake

;main game loop
loop_until_x:
	mov ah, 1
	int 16h

;zf flag is set when key pressed
jnz loop_until_x	

	;read the key
	mov ah, 0
	int 16h

	cmp al, 'x'
	je cs:exit_program ;no point in call since we won't return anyways

	call cs:change_vector_input
jmp loop_until_x

rozkazy ENDS
custom_stos SEGMENT	stack
db 128 dup (?)
custom_stos ENDS
END begin
