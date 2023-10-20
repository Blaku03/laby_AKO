.686
.model flat

extern __read : PROC
extern __write : PROC
extern _MessageBoxW@16 : PROC
extern _MessageBoxA@16 : PROC
extern _ExitProcess@4 : PROC

public _main

.data
maks_dlugosc_tekstu equ 20
tekst_do_usuniecia db maks_dlugosc_tekstu dup (0),0
tekst db 'Ala ma kotakota',0
dlugosc_tekst equ $-tekst
wypisz_tekst db dlugosc_tekst dup (0),0

.code 
replace PROC
push ecx
mov ecx, eax

replace_ptl:
mov wypisz_tekst[edi], 0
dec edi
dec ecx
jnz replace_ptl

pop ecx
ret
replace ENDP

_main PROC

push maks_dlugosc_tekstu
push OFFSET tekst_do_usuniecia
push 0
call __read
add esp, 12
dec eax

xor esi, esi
xor edi, edi
mov ecx, dlugosc_tekst
xor ebx, ebx
xor edx, edx

ptl:
mov bl, tekst[esi]
inc esi

mov wypisz_tekst[edi], bl
inc edi

cmp bl, tekst_do_usuniecia[edx]
jne check_first_letter
inc edx
cmp edx, eax ; check if number of letters is equal to number of letters to delete
je is_equal
jmp next_itr

is_equal:
call replace 
jmp next_itr

check_first_letter:
cmp bl, tekst_do_usuniecia[0]
mov edx, 1
jmp next_itr

xor edx, edx

next_itr:
dec ecx
jnz ptl

push dlugosc_tekst
push OFFSET wypisz_tekst
push 1
call __write
add esp, 12

push 0
call _ExitProcess@4

_main ENDP
END