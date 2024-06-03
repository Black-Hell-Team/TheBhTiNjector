BITS 32

section .text

global _start

_start:
    xor eax, eax ; zero out eax register
    xor edx, edx ; zero out edx register
    mov al, 0x43 ; caractere 'C'
    push eax ; push 0x43 (C)
    mov al, 0x3a ; caractere ':'
    push eax ; push 0x3a (:)
    mov al, 0x5c ; caractere '\'
    push eax ; push 0x5c (\)
    mov al, 0x57 ; caractere 'W'
    push eax ; push 0x57 (W)
    mov al, 0x49 ; caractere 'I'
    push eax ; push 0x49 (I)
    mov al, 0x4e ; caractere 'N'
    push eax ; push 0x4e (N)
    mov al, 0x44 ; caractere 'D'
    push eax ; push 0x44 (D)
    mov al, 0x4f ; caractere 'O'
    push eax ; push 0x4f (O)
    mov al, 0x57 ; caractere 'W'
    push eax ; push 0x57 (W)
    mov al, 0x53 ; caractere 'S'
    push eax ; push 0x53 (S)
    mov al, 0x2e ; caractere '.'
    push eax ; push 0x2e (.)
    mov al, 0x65 ; caractere 'e' 
    push eax ; push 0x65 (e)
    mov al, 0x78 ; caractere 'x'
    push eax ; push 0x78 (x)
    mov al, 0x65 ; caractere 'e'
    push eax ; push 0x65 (e)
    mov al, 0x0 ; null terminator
    push eax ; push null terminator
    mov eax, esp 
    push eax 
    xor eax, eax ; zero out eax register
    push eax ; push 0x0 (null terminator)
    push eax ; push 0x0 (null terminator)
    mov al, 0x30 ; caractere '0'
    push eax ; push 0x30 (0)
    mov al, 0x78 ; caractere 'x'
    push eax ; push 0x78 (x)
    mov al, 0x65 ; caractere 'e'
    push eax ; push 0x65 (e)
    mov al, 0x63 ; caractere 'c'
    push eax ; push 0x63 (c)
    mov al, 0x2e ; caractere '.'
    push eax ; push 0x2e (.)
    mov al, 0x6d ; caractere 'm'
    push eax ; push 0x6d (m)
    mov al, 0x64 ; caractere 'd'
    push eax ; push 0x64 (d)
    mov al, 0x65 ; caractere 'e'
    push eax ; push 0x65 (e)
    mov al, 0x2f ; caractere '/'
    push eax ; push 0x2f (/)
    mov al, 0x2f ; caractere '/'
    push eax ; push 0x2f (/)
    mov al, 0x62 ; caractere 'b'
    push eax ; push 0x62 (b)
    mov al, 0x69 ; caractere 'i'
    push eax ; push 0x69 (i)
    mov al, 0x6e ; caractere 'n'
    push eax ; push 0x6e (n)
    mov al, 0x2f ; caractere '/'
    push eax ; push 0x2f (/)
    mov al, 0x73 ; caractere 's'
    push eax ; push 0x73 (s)
    mov al, 0x68 ; caractere 'h'
    push eax ; push 0x68 (h)
    mov al, 0x0 ; null terminator
    push eax ; push null terminator
    mov eax, esp  
    push eax 
    xor eax, eax 
    mov al, 0x11 
    int 0x2e 

    
    xor eax, eax 
    inc eax ; return 1
    int 0x80 ; exit
