section .text
global _start

_start:
    jmp short resolve_functions

file_name_1:
    db 'first_binary.exe', 0

file_name_2:
    db 'second_binary.exe', 0

resolve_functions:
    call get_kernel32_base       ; Get the base address of kernel32.dll
    pop ebx                      ; Store the base address of kernel32.dll in ebx

    ; Resolve the address of CreateProcessA function
    mov eax, dword [ebx + 0x3bd8]  ; Offset to CreateProcessA in kernel32.dll
    add eax, ebx                   ; Add the base address to get the real address
    mov dword [ebp + 0x10], eax    ; Store the address of CreateProcessA in ebp + 0x10

    ; Resolve the address of WaitForSingleObject function
    mov eax, dword [ebx + 0x3fb4]  ; Offset to WaitForSingleObject in kernel32.dll
    add eax, ebx                   ; Add the base address to get the real address
    mov dword [ebp + 0x18], eax    ; Store the address of WaitForSingleObject in ebp + 0x18

    ; Resolve the address of CloseHandle function
    mov eax, dword [ebx + 0x3bb0]  ; Offset to CloseHandle in kernel32.dll
    add eax, ebx                   ; Add the base address to get the real address
    mov dword [ebp + 0x1c], eax    ; Store the address of CloseHandle in ebp + 0x1c

    ; Resolve the address of ExitProcess function
    mov eax, dword [ebx + 0x37ec]  ; Offset to ExitProcess in kernel32.dll
    add eax, ebx                   ; Add the base address to get the real address
    mov dword [ebp + 0x20], eax    ; Store the address of ExitProcess in ebp + 0x20

    ; Create the first process
    mov ebx, file_name_1          ; Store the address of file name 1 in ebx
    xor ecx, ecx                  ; Clear ecx
    push ecx                      ; lpThreadAttributes
    push ecx                      ; bInheritHandles
    push ecx                      ; lpEnvironment
    push ebx                      ; lpCommandLine
    push ecx                      ; lpProcessAttributes
    call dword [ebp + 0x10]       ; Call to create the process
    add esp, 20                   ; Clean the stack of arguments

    ; Check if the first CreateProcessA call was successful
    test eax, eax
    jz exit_failure               ; If failed, exit with error code

    ; Wait for the first process to complete
    mov edx, eax                  ; Store the PID of the first process in edx
    push edx                      ; hHandle
    call dword [ebp + 0x18]       ; Call to WaitForSingleObject
    add esp, 4                    ; Clean the stack of argument

    ; Create the second process as a subprocess
    mov ebx, file_name_2          ; Store the address of file name 2 in ebx
    xor ecx, ecx                  ; Clear ecx
    push ecx                      ; lpThreadAttributes
    push ecx                      ; bInheritHandles
    push ecx                      ; lpEnvironment
    push ebx                      ; lpCommandLine
    push ecx                      ; lpProcessAttributes
    call dword [ebp + 0x10]       ; Call to create the process
    add esp, 20                   ; Clean the stack of arguments

    ; Check if the second CreateProcessA call was successful
    test eax, eax
    jz exit_failure               ; If failed, exit with error code

    ; Terminate the program with success code
    push ecx
    call dword [ebp + 0x20]       ; Call to ExitProcess

exit_failure:
    ; Terminate the program with error code
    push 1
    call dword [ebp + 0x20]       ; Call to ExitProcess

get_kernel32_base:
    ; Function to get the base address of kernel32.dll
    xor ecx, ecx                  ; Initialize the module counter
    mov ebx, dword [fs:ecx + 0x30] ; Jump to the PEB
    mov ebx, dword [ebx + 0x0c]   ; Get the address of the module list
    mov ebx, dword [ebx + 0x1c]   ; Get the base address of kernel32.dll
    ret
