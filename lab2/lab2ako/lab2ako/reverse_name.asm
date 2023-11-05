.686
.model flat

extern __read : PROC
extern __write : PROC
extern _MessageBoxW@16 : PROC
extern _MessageBoxA@16 : PROC
extern _ExitProcess@4 : PROC

public _main

.data
imie_nazwisko db 80 dup (0),0
len dd 0
imie db 40 dup (0),0
nazwisko db 40 dup (0),0
len_imie dd 0

latin2_s db 165, 134, 169, 136, 228, 162, 152, 171, 190
latin2_b db 164, 143, 168, 157, 227, 224, 151, 141, 189
win1250_s db 185, 230, 234, 179, 241, 243, 156, 159, 191
win1250_b db 165, 198, 202, 163, 209, 211, 140, 143, 175
utf16_s dw 0105h, 0107h, 0119h, 0142h, 0144h, 00F3h, 015Bh, 017Ah, 017Ch
utf16_b dw 0104h, 0106h, 0118h, 0141h, 0143h, 00D3h, 015Ah, 0179h, 017Bh

.code 

_change_To_Big@20 PROC
;(order of arguments as in normal function : arg1, arg2, arg3...)
;first argument is char
;second argument is encoding address to search in
;third argument is encoding address to return from
;fifth argument is encoding byte size jump of address to search from (utf16 support)
;fourth argument is encoding byte size jump of address to return from (utf16 support)
;returns in edx changed code (only encoding size bytes will be changed)

;store orginal register values
push eax
push ebx
push ecx
push esi
push edi

;assign values to registers
mov edx, [esp + 5*4 + 4] ;char argument
mov esi, [esp + 5*4 + 2*4] ;search in addres
mov edi, [esp + 5*4 + 3*4] ;search from addres
mov al, byte PTR [esp + 5*4 + 4*4] ;search in byte size
mov ah, byte PTR [esp + 5*4 + 5*4] ;return from byte size

;special case for space:
cmp edx, 20h
je end_func

;for easier function ebx will be used as counter

xor ebx, ebx
xor ecx, ecx
cmp al,2
je find_loop_utf16

find_loop:

inc ebx
cmp [esi + ebx - 1], dl
je change_to_big_special

cmp ebx, 9
jne find_loop

cmp ecx, 1
je change_to_big_normal

add esi, 9
xor ebx, ebx
inc ecx
jmp find_loop

find_loop_utf16:

inc ebx
cmp [esi + 2*ebx - 2], dx
je change_to_big_special

cmp ebx, 9
jne find_loop_utf16

cmp ecx, 1
je change_to_big_normal

add esi, 18 
xor ebx, ebx
inc ecx
jmp find_loop_utf16

change_to_big_normal:

and dl, 11011111b
jmp end_func

change_to_big_special:

cmp ah, 2
je utf16_return

mov dl, [edi + ebx - 1]
xor dh, dh
jmp end_func

utf16_return:
mov dx, [edi + 2*ebx - 2]

end_func:
pop edi
pop esi
pop ecx
pop ebx
pop eax

ret
_change_To_Big@20 ENDP

_main PROC

push 80
push OFFSET imie_nazwisko
push 0
call __read
add esp, 12

mov len, eax
mov ecx, eax

dec ecx
xor edx, edx
xor esi, esi
xor edi, edi
xor ebx, ebx

ptl:

mov dl, imie_nazwisko[esi]
inc esi

cmp dl, ' '
jne brak_spacji

mov ebx, 1
mov len_imie, edi
xor edi, edi
jmp ptl

brak_spacji:

push 1
push 1
push OFFSET latin2_b
push OFFSET latin2_s
push edx
call _change_To_Big@20
add esp,20

cmp ebx, 1
je nazwisko_sec

mov imie[edi], dl
inc edi
jmp next_itr

nazwisko_sec:
mov nazwisko[edi], dl
inc edi

next_itr:
dec ecx
jnz ptl


mov nazwisko[edi-1], 20h

push edi
push OFFSET nazwisko
push 1
call __write
add esp,12

push [len_imie]
push OFFSET imie
push 1
call __write
add esp,12

push 0
call _ExitProcess@4

_main ENDP
END