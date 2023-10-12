.686
.model flat
extern _ExitProcess@4 : PROC
extern _MessageBoxA@16 : PROC
extern _MessageBoxW@16 : PROC
extern __write : PROC
extern __read : PROC
public _main

.data
tekst_pocz db 'Prosze napisac jakis tekst '
db 'i nacisnac Enter', 10
koniec_t db ?
magazyn db 80 dup (?)
magazynA db 80 dup (?)
magazynW dw 80 dup (?)
nowa_linia db 10
liczba_znakow dd ?
tytul_MbA db 'MessageBoxA:',0
tytul_MbW dw 'M','e','s','s','a','g','e','B','o','x','W',':',0

.code
_main PROC

 mov ecx,(OFFSET koniec_t) - (OFFSET tekst_pocz)
 push ecx
 push OFFSET tekst_pocz
 push 1
 call __write
 add esp, 12

 push 80
 push OFFSET magazyn
 push 0
 call __read
 add esp, 12

 ;String is in buffer
 mov liczba_znakow, eax
 mov ecx, eax
 mov ebx, 0
 xor edx, edx
ptl: mov dl, magazyn[ebx]
 
 mov magazynA[ebx], dl
 mov magazynW[ebx*2], dx ;moving 2bytes not one

 ;checking for special small letter
 cmp dl, 165 ; a
 je special_a
 cmp dl, 134 ; c
 je special_c
 cmp dl, 169 ; e
 je special_e
 cmp dl, 136 ; l
 je special_l
 cmp dl, 228 ; n
 je special_n
 cmp dl, 162 ; o
 je special_o
 cmp dl, 152 ; s
 je special_s
 cmp dl, 190 ; z_dot
 je special_z_dot
 cmp dl, 171 ; z_dash
 je special_z_dash

 ;checking for special capital lettr
 cmp dl, 164 ; a
 je special_a
 cmp dl, 143 ; c
 je special_c
 cmp dl, 168 ; e
 je special_e
 cmp dl, 157 ; l
 je special_l
 cmp dl, 227 ; n
 je special_n
 cmp dl, 224 ; o
 je special_o
 cmp dl, 151 ; s
 je special_s
 cmp dl, 189 ; z_dot
 je special_z_dot
 cmp dl, 141 ; z_dash
 je special_z_dash
 
 jmp not_special_char

 special_a: mov magazyn[ebx], 164 
 mov magazynA[ebx], 165 
 mov magazynW[ebx*2], 0104H
 jmp dalej
 special_c: mov magazyn[ebx], 143 
 mov magazynA[ebx], 198
 mov magazynW[ebx*2], 0106H
 jmp dalej
 special_e: mov magazyn[ebx], 168 
 mov magazynA[ebx], 202
 mov magazynW[ebx*2], 0118H
 jmp dalej
 special_l: mov magazyn[ebx], 157 
 mov magazynA[ebx], 163
 mov magazynW[ebx*2], 0141H
 jmp dalej
 special_n: mov magazyn[ebx], 227 
 mov magazynA[ebx], 209
 mov magazynW[ebx*2], 0143H
 jmp dalej
 special_o: mov magazyn[ebx], 224 
 mov magazynA[ebx], 211
 mov magazynW[ebx*2], 0D3H
 jmp dalej
 special_s: mov magazyn[ebx], 151 
 mov magazynA[ebx], 140
 mov magazynW[ebx*2], 15AH
 jmp dalej
 special_z_dot: mov magazyn[ebx], 189
 mov magazynA[ebx], 175
 mov magazynW[ebx*2], 179H
 jmp dalej
 special_z_dash:mov magazyn[ebx], 141 
 mov magazynA[ebx], 143
 mov magazynW[ebx*2], 17BH
 jmp dalej

 ;checking for small letter
 not_special_char:
 cmp dl, 'a'
 jb dalej 
 cmp dl, 'z'
 ja dalej

 ;converting to capital letter
 sub dl, 20H
 mov magazyn[ebx], dl
 mov magazynA[ebx], dl
 mov magazynW[ebx*2], dx

dalej:
 inc ebx
 dec ecx
 jnz ptl

 ;display in console
 push liczba_znakow
 push OFFSET magazyn
 push 1
 call __write
 add esp, 12

 ;MessageBoxA
 push 0
 push OFFSET tytul_MbA
 push OFFSET magazynA
 push 0
 call _MessageBoxA@16

 ;MessageBoxW
 push 0
 push OFFSET tytul_MbW 
 push OFFSET magazynW
 push 0
 call _MessageBoxW@16

 ;exit
 push 0
 call _ExitProcess@4

_main ENDP
END
