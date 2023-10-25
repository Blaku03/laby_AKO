.686
.model flat

extern __read : PROC
extern __write : PROC
extern _MessageBoxW@16 : PROC
extern _MessageBoxA@16 : PROC
extern _ExitProcess@4 : PROC

public _main

.data
tekst_base db 40 dup(0),0
tekst_find db 40 dup(0),0
tekst_replace db 40 dup(0),0
tekst_final db 40 dup(0),0

dl_base dd 0
dl_base_loop dd 0
dl_find dd 0
dl_replace dd 0
dl_final dd 0

.code 

_main PROC

push 40
push OFFSET tekst_base
push 0
call __read
add esp,12
dec eax
mov dl_base, eax
mov dl_base_loop, eax

push 40
push OFFSET tekst_find
push 0
call __read
add esp,12
dec eax
mov dl_find, eax

push 40
push OFFSET tekst_replace
push 0
call __read
add esp,12
dec eax
mov dl_replace, eax

xor ecx, ecx
xor esi, esi
xor edi, edi

loop_base:
mov bl, tekst_base[ecx]
mov tekst_final[edi], bl
inc edi


xor esi, esi
check_next_letter:
mov bl, [tekst_base + ecx + esi]
cmp bl, tekst_find[esi]
jne next_itr
inc esi
cmp esi, dl_find
jb check_next_letter

add ecx, dl_find
dec ecx

xor eax, eax

found:
mov bl, [tekst_replace + eax]
mov [tekst_final + edi - 1], bl 
inc eax
inc edi
cmp edi, dl_replace
jbe found
dec edi

next_itr:
inc ecx
cmp ecx, dl_base
jb loop_base

;calculate the final length
xor eax, eax
mov eax, dl_base
sub eax, dl_find
add eax, dl_replace

push eax
push OFFSET tekst_final
push 1
call __write
add esp,12

push 0
call _ExitProcess@4

_main ENDP
END