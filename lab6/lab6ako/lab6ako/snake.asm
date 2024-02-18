.386
rozkazy SEGMENT	USE16
ASSUME CS:rozkazy

snake_pos dw 200
snake_vector db 0 ;0 - in place, 1 - right, 2 - down, 3 - left, 4 - up

interupt_counter db 0
wektor8 dd ?

right_key db 'd'
left_key db 'a'
up_key db 'w'
down_key db 's'

exit_program PROC
	;restoring the orignal vector function
	mov eax, cs:wektor8
	cli
	mov ds:[32], eax
	sti

	mov al, 0
	mov ah, 4CH
	int 21H

	jmp dword ptr cs:wektor8
exit_program ENDP

check_wall PROC
	push ax
	push bx

	;check based on current position whether player has hit the wall

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
	mov byte ptr es:[bx+1], 00011110b ;yellow on blue

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


begin:
mov al, 0 ;page number
mov ah, 5 ;active display page
int 10

;setting up the interupt func (saving to wektor8 orginal one)
mov ax, 0
mov ds, ax

mov eax, ds:[32]
mov cs:wektor8, eax

;overwriting orginal vector intr
mov bx, SEG clock_interrupt
mov ax, OFFSET clock_interrupt

cli
mov ds:[32], ax
mov ds:[34], bx
sti

call cs:draw_snake

;main game loop
loop_until_x:
mov ah, 1
int 16h

;zf flag is set when key pressed
jz loop_until_x	

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
