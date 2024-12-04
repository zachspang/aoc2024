.386
.model flat, stdcall
option casemap :none
INCLUDELIB C:\masm32\lib\masm32.lib
INCLUDE C:\masm32\include\masm32rt.inc

.data
    FileName db "C:\Users\spang\Desktop\Projects\aoc2024\2\input.txt", 0
    safeCount dword 0
    lineArray byte 10 DUP(?)

.data?
    hFile HANDLE ?
    hMemory HANDLE ?
    pMemory DWORD ?
    ReadSize DWORD ? 
.const
    MEMORYSIZE equ 65535 
.code

getSafteyLevel PROC
    LOCAL filePtr 
    LOCAL prevNum :byte
    LOCAL safeFlag :byte
    LOCAL increasingFlag :byte
    LOCAL decreasingFlag :byte
    LOCAL index: byte
    LOCAL innerIndex: byte
    LOCAL lastIndex: byte

    mov filePtr, eax
    mov index, 0
    mov eax, 0 
    mov ecx, 0
    mov esi, offset lineArray
    byteLoop: ;Loop through each byte of the file
        push ecx
        mov ebx, filePtr
        mov al, [ebx]
        sub al, 30h ;Subtract 30 to turn into decimal from ascii
        push eax
        ;printf ("Iteration: %u, Num: %d\n",bl, al)
        pop eax

        cmp al, 240 ;If the byte is a space add the number in ah to the array
            jne notSpace
            mov esi, offset lineArray
            movzx ebx, index
            add esi, ebx
            mov [esi], ah
            mov ah, 0
            inc index
            jmp nextByte
            
        notSpace:
        cmp al, 218 ;If byte is a new line add the last number to the array then check the array.
        jne number
            mov esi, offset lineArray
            movzx ebx, index
            add esi, ebx
            mov [esi], ah
            mov ah, 0
            jmp checkArray

        number: ;The byte has a number
            push eax
            mov ecx, 0
            mov cl, ah
            mov eax, ecx
            imul ecx, eax, 10 ;If the number is multiple digits the previous digits are stored in ah otherwise ah is 0
            pop eax
            add al, cl
            mov ah, al
            jmp nextByte

        checkArray: ;Check if line is safe
            movzx ecx, index
            add cl, 1
            mov lastIndex, cl
            mov index, 0
            arrayLoop: ;loop through a line
                push ecx
                mov prevNum, 0
                mov safeFlag, 1
                mov increasingFlag, 0
                mov decreasingFlag, 0
                mov innerIndex, 0
                movzx ecx, lastIndex

                ;check if removing the element at index will make the line safe         
                removeLoop:
                    push ecx
                    push eax
                    movzx eax, innerIndex
                    cmp al, index ;if this is the index to be removed go the the next iteration
                    pop eax
                    je skip

                    mov esi, offset lineArray
                    movzx ebx, innerIndex
                    add esi, ebx
                    mov al, [esi] ;al has the element at innerIndex
                    mov ah, al ;ah has a copy of that element that isnt touched

                    push eax
                    push ecx
                    ;printf ("Index: %u, Num: %d\n",bl, al)
                    pop ecx
                    pop eax

                    cmp prevNum, 0
                    je skip
                    cmp al, prevNum
                    jg greater

                    lesser:
                        mov al, prevNum
                        sub al, ah
                        jmp determineSafety
                    greater:
                        sub al, prevNum
                    determineSafety:
                        cmp al, 3
                        jg unsafe
                        cmp al, 0
                        je unsafe

                        ;Check if it swaps from increasing to decreasing or vice versa
                        cmp ah, prevNum
                        jg increasing

                        decreasing:
                            mov decreasingFlag, 1
                            jmp determineDirectionChange
                        increasing:
                            mov increasingFlag, 1
                        determineDirectionChange: ;if both flags are 1 then it is unsafe
                            cmp decreasingFlag, 0
                            je finishCompare
                            cmp increasingFlag, 0 
                            je finishCompare

                    unsafe:
                        mov safeFlag, 0 
                    finishCompare:

                    skip:
                    mov prevNum, ah
                    inc innerIndex
                    pop ecx
                dec ecx
                jne removeLoop

                cmp safeFlag, 1 ;If nothing was unsafe add 1 to safe counter and go to next line
                    jne notSafe
                        inc safeCount     
                        jmp endArrayLoop
                notSafe:

                inc index
                pop ecx
            dec ecx
            jne arrayLoop
            endArrayLoop:
            mov eax, 0
            mov index, 0

        nextByte:

        inc filePtr
        pop ecx
        inc ecx
        cmp ecx, ReadSize
        jne byteLoop

    ret
getSafteyLevel ENDP

start:
    invoke CreateFile, addr FileName, GENERIC_READ, FILE_SHARE_READ, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL
    mov hFile, eax

    invoke GlobalAlloc, GMEM_MOVEABLE or GMEM_ZEROINIT, MEMORYSIZE
    mov hMemory, eax
    invoke GlobalLock, hMemory
    mov pMemory, eax

    invoke ReadFile, hFile, pMemory, MEMORYSIZE-1, addr ReadSize, NULL

    mov eax, pMemory
    call getSafteyLevel
    printf ("Safe Count: %d\n",safeCount)

    invoke GlobalUnlock, pMemory
    invoke GlobalFree, hMemory
    invoke CloseHandle, hFile
    invoke ExitProcess, NULL
end start 