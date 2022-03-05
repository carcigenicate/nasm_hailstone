global _start

section .data
    newline: db `\n`
    end_str: db `1\n`

section .text
    print_string:  ; (char* string, int length)
        push ebp
        mov ebp, esp

        push ebx

        mov eax, 4
        mov ebx, 1
        mov ecx, [ebp + 8]
        mov edx, [ebp + 12]
        int 0x80

        pop ebx

        mov esp, ebp
        pop ebp

        ret


    print_int:  ; (int n_to_print)
        push ebp
        mov ebp, esp

        push ebx
        push esi

        mov esi, esp  ; So we can calculate how many were pushed easily

        mov ecx, [ebp + 8]

        .loop:
            mov edx, 0  ; Zeroing out edx for div
            mov eax, ecx  ; Num to be divided
            mov ebx, 10  ; Divide by 10
            div ebx
            mov ecx, eax  ; Quotient

            add edx, '0'
            push edx  ; Remainder

            cmp ecx, 0
            jne .loop

        mov eax, 4  ; Write
        mov ebx, 1  ; STDOUT
        mov ecx, esp  ; The string on the stack
        mov edx, esi
        sub edx, esp  ; Calculate how many bytes were pushed
        int 0x80

        add esp, edx

        pop esi
        pop ebx

        mov esp, ebp
        pop ebp

        ret


    main_loop:  ; (int starting_n)
        push ebp
        mov ebp, esp

        push ebx

        mov ebx, [ebp + 8]  ; ebx is the accumulator
        .loop:
            push ebx
            call print_int
            add esp, 4

            push 1
            push newline
            call print_string
            add esp, 8

            test ebx, 1
            jz .even
            .odd:
                mov eax, ebx
                mov ecx, 3  ; Because multiply needs a memory location
                mul ecx
                inc eax
                mov ebx, eax
                jmp .end

            .even:
                shr ebx, 1

            .end:
                cmp ebx, 1
                jnz .loop

        push 2
        push end_str
        call print_string
        add esp, 8

        pop ebx

        mov esp, ebp
        pop ebp

        ret


    _start:
        push 1000  ; The starting number
        call main_loop
        add esp, 4

        mov eax, 1
        mov ebx, 0
        int 0x80