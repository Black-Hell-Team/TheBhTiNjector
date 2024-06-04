section .data
    file_name_1 db 'first_binary.exe', 0
    file_name_2 db 'second_binary.exe', 0

section .bss
    kernel32_base resq 1
    CreateProcessA_addr resq 1
    WaitForSingleObject_addr resq 1
    CloseHandle_addr resq 1
    ExitProcess_addr resq 1

section .text
global _start

_start:
    ; Get the base address of kernel32.dll
    call get_kernel32_base
    mov [kernel32_base], rax

    ; Resolve the address of the necessary functions
    call resolve_CreateProcessA
    call resolve_WaitForSingleObject
    call resolve_CloseHandle
    call resolve_ExitProcess

    ; Create the first process
    mov rcx, 0                       ; lpThreadAttributes
    mov rdx, 0                       ; bInheritHandles
    mov r8,  0                       ; lpEnvironment
    lea r9, [file_name_1]            ; lpCommandLine
    sub rsp, 40                      ; Align the stack for function calls
    call qword [CreateProcessA_addr]
    add rsp, 40                      ; Restore the stack

    ; Check if the first CreateProcessA call was successful
    test rax, rax
    jz exit_failure                  ; If failed, exit with error code

    ; Wait for the first process to complete
    mov rcx, rax                     ; hHandle (process handle)
    mov rdx, -1                      ; dwMilliseconds (infinite wait)
    sub rsp, 40                      ; Align the stack for function calls
    call qword [WaitForSingleObject_addr]
    add rsp, 40                      ; Restore the stack

    ; Create the second process
    lea r9, [file_name_2]            ; lpCommandLine
    sub rsp, 40                      ; Align the stack for function calls
    call qword [CreateProcessA_addr]
    add rsp, 40                      ; Restore the stack

    ; Check if the second CreateProcessA call was successful
    test rax, rax
    jz exit_failure                  ; If failed, exit with error code

    ; Terminate the program with success code
    xor ecx, ecx
    sub rsp, 40                      ; Align the stack for function calls
    call qword [ExitProcess_addr]

exit_failure:
    ; Terminate the program with error code
    mov ecx, 1
    sub rsp, 40                      ; Align the stack for function calls
    call qword [ExitProcess_addr]

get_kernel32_base:
    ; Function to get the base address of kernel32.dll
    xor rax, rax
    mov rax, gs:[0x60]               ; PEB
    mov rax, [rax + 0x18]            ; PEB_LDR_DATA
    mov rax, [rax + 0x20]            ; InMemoryOrderModuleList (first module)
    mov rax, [rax + 0x20]            ; InMemoryOrderModuleList (kernel32.dll)
    mov rax, [rax + 0x10]            ; BaseDllName (base address of kernel32.dll)
    ret

resolve_CreateProcessA:
    mov rbx, [kernel32_base]
    ; Resolve the address of CreateProcessA function
    mov rax, [rbx + 0x3bd8]          ; Offset to CreateProcessA in kernel32.dll
    add rax, rbx                     ; Add the base address to get the real address
    mov [CreateProcessA_addr], rax
    ret

resolve_WaitForSingleObject:
    mov rbx, [kernel32_base]
    ; Resolve the address of WaitForSingleObject function
    mov rax, [rbx + 0x3fb4]          ; Offset to WaitForSingleObject in kernel32.dll
    add rax, rbx                     ; Add the base address to get the real address
    mov [WaitForSingleObject_addr], rax
    ret

resolve_CloseHandle:
    mov rbx, [kernel32_base]
    ; Resolve the address of CloseHandle function
    mov rax, [rbx + 0x3bb0]          ; Offset to CloseHandle in kernel32.dll
    add rax, rbx                     ; Add the base address to get the real address
    mov [CloseHandle_addr], rax
    ret

resolve_ExitProcess:
    mov rbx, [kernel32_base]
    ; Resolve the address of ExitProcess function
    mov rax, [rbx + 0x37ec]          ; Offset to ExitProcess in kernel32.dll
    add rax, rbx                     ; Add the base address to get the real address
    mov [ExitProcess_addr], rax
    ret
