.686
.model flat

extern __read : PROC
extern __write : PROC
extern _MessageBoxW@16 : PROC
extern _MessageBoxA@16 : PROC
extern _ExitProcess@4 : PROC

public _main

.data
latin2_s db 165, 134, 169, 136, 228, 162, 152, 171, 190
latin2_b db 164, 143, 168, 157, 227, 224, 151, 141, 189
win1250_s db 185, 230, 234, 179, 241, 243, 156, 159, 191
win1250_b db 165, 198, 202, 163, 209, 211, 140, 143, 175
utf16_s dw 0105h, 0107h, 0119h, 0142h, 0144h, 00F3h, 015Bh, 017Ah, 017Ch
utf16_b dw 0104h, 0106h, 0118h, 0141h, 0143h, 00D3h, 015Ah, 0179h, 017Bh

wczytany_tekst db 80 dup(0),0
wielki_tekst db 80 dup(0),0
wielki_tekst_W dw 80 dup(0),0
tytul_W dw 'U','t','f',0

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
push esi
push edi

;assign values to registers
mov edx, [esp + 4*4 + 4] ;char argument
mov esi, [esp + 4*4 + 2*4] ;search in addres
mov edi, [esp + 4*4 + 3*4] ;search from addres
mov al, byte PTR [esp + 4*4 + 4*4] ;search in byte size
mov ah, byte PTR [esp + 4*4 + 5*4] ;return from byte size

;special case for space:
cmp edx, 20h
je end_func

;for easier function ebx will be used as counter

xor ebx, ebx
cmp al,2
je find_loop_utf16

find_loop:

inc ebx
cmp [esi + ebx - 1], dl
je change_to_big_special

cmp ebx, 9
jne find_loop

jmp change_to_big_normal

find_loop_utf16:

inc ebx
cmp [esi + 2*ebx - 2], dx
je change_to_big_special

cmp ebx, 9
jne find_loop_utf16

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
pop ebx
pop eax

ret
_change_To_Big@20 ENDP

_main PROC

push 80
push OFFSET wczytany_tekst
push 0
call __read
add esp,12

xor ecx, ecx
dec eax ; pozbycie sie entera

petla:
mov dl, wczytany_tekst[ecx]

push 1
push 1
push OFFSET latin2_b
push OFFSET latin2_s
push edx
call _change_To_Big@20
add esp,20


mov wielki_tekst[ecx], dl

mov dl, wczytany_tekst[ecx]

push 2
push 1
push OFFSET utf16_b
push OFFSET latin2_s
push edx
call _change_To_Big@20	
add esp,20

mov wielki_tekst_W[2*ecx], dx
xor dh, dh
inc ecx
cmp ecx, eax
jne petla

push eax
push OFFSET wielki_tekst
push 1
call __write
add esp,12

push 0
push OFFSET tytul_W
push OFFSET wielki_tekst_W
push 0
call _MessageBoxW@16

push 0
call _ExitProcess@4

_main ENDP
END