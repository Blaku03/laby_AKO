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

.code 

_change_To_Big@16 PROC
;first argument is char
;second argument is encoding address to search in
;third argument is encoding address to return from
;fourth argument is encoding byte size jump of address to return from (utf16 support)
;returns in edx changed code (only encoding size bytes will be changed)

;store orginal register values
push eax
push ebx
push esi
push edi

;assign values to registers
mov edx, [esp + 4*4 + 4] ;include ret address
mov ebx, [esp + 4*4 + 2*4]
mov edi, [esp + 4*4 + 3*4]
mov eax, [esp + 4*4 + 4*4]

;special case for space:
cmp edx, 20h
je end_func

xor esi, esi
find_loop:

inc esi
cmp [ebx + esi - 1], dl
je change_to_big_special

cmp esi, 9
jne find_loop

and dl, 11011111b
jmp end_func

change_to_big_special:
imul esi, eax

cmp eax, 2
je utf16_return

mov dl, [edi + esi - 1]
jmp end_func

utf16_return:
mov dx, [edi + esi - 1]

end_func:
pop edi
pop esi
pop ebx
pop eax

ret
_change_To_Big@16 ENDP

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
push OFFSET latin2_b
push OFFSET latin2_s
push edx
call _change_To_Big@16
add esp,16

mov wielki_tekst[ecx], dl
inc ecx
cmp ecx, eax
jne petla

push eax
push OFFSET wielki_tekst
push 1
call __write
add esp,12

push 0
call _ExitProcess@4

_main ENDP
END