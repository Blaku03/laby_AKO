.686
.model flat

extern __read : PROC
extern __write : PROC
extern _MessageBoxW@16 : PROC
extern _MessageBoxA@16 : PROC
extern _ExitProcess@4 : PROC

public _main

.data
user_text db 80 dup (?),0
display_messageW dw 80 dup (0),0
tytul dw 'U','t','f','-','1','6',0

.code 

replace PROC
sub edi, 3
mov display_messageW[2*edi],2615h
inc edi
mov display_messageW[2*edi],0
inc edi
mov display_messageW[2*edi],0
dec edi
ret
replace ENDP


_main PROC

push dword PTR 80
push OFFSET user_text
push dword PTR 0
call __read
add esp, 12

mov ecx, eax
xor esi, esi
xor edi, edi
xor edx, edx
xor eax, eax

ptl:
mov dl, user_text[esi]
inc esi

mov display_messageW[2*edi], dx
inc edi

cmp dl, 'A'
je first_letter

cmp dl, 'k'
je second_letter

cmp dl, 'o'
je third_letter

jmp not_chain

first_letter:
cmp eax, 0
jne not_chain_A
inc eax
jmp next_itr

second_letter:
cmp eax, 1
jne not_chain
inc eax
jmp next_itr

third_letter:
cmp eax, 2
jne not_chain
call replace	
jmp not_chain

not_chain_A:
mov eax, 1
jmp next_itr

not_chain:
mov eax, 0

next_itr:
dec ecx
jnz ptl

push 0
push OFFSET tytul
push OFFSET display_messageW
push 0
call _MessageBoxW@16

push dword PTR 0
call _ExitProcess@4

_main ENDP
END