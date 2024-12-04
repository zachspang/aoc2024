.386
.model flat, stdcall
option casemap :none
INCLUDELIB C:\masm32\lib\masm32.lib
INCLUDE C:\masm32\include\masm32rt.inc

.data
    FileName db "C:\Users\spang\Desktop\Projects\aoc2024\2\input.txt", 0
    safeCount dword 0

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
    LOCAL lastNumInLineFlag :byte
    mov filePtr, eax
    mov prevNum, 0
    mov safeFlag, 1
    mov increasingFlag, 0
    mov decreasingFlag, 0
    mov eax, 0 
    mov ecx, 0

    byteLoop: ;Loop through each byte of the file
        push ecx
        mov ebx, filePtr
        mov al, [ebx]
        sub al, 30h ;Subtract 30 to turn into decimal from ascii
        push eax
        ;printf ("Iteration: %u, Num: %d\n",bl, al)
        pop eax

        cmp al, 240 ;If the byte is a space compare the last two numbers
        je comparePrev

        cmp al, 218 ;If byte is a new line set the flag to reset things after this compare
        jne number  ;If the byte is a number skip comparing
            mov lastNumInLineFlag, 1
           
        comparePrev:
            mov al, ah
            cmp prevNum, 0 ;If this is the first number on a line we dont need to compare it to the previous
            je finishCompare
            cmp al, prevNum ;I dont want to deal with negatives so swap the operands depending on which is larger
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
                mov prevNum, ah
                mov ah, 0
                jmp finishIteration

        number: ;The byte has a number
            push eax
            mov ecx, 0
            mov cl, ah
            mov eax, ecx
            imul ecx, eax, 10 ;If the number is multiple digits the previous digits are stored in ah otherwisw ah is 0
            pop eax
            add al, cl
            mov ah, al
            
        finishIteration:
        cmp lastNumInLineFlag, 1
        jne notLastNum
            mov prevNum, 0
            mov eax, 0
            mov increasingFlag, 0
            mov decreasingFlag, 0
            mov lastNumInLineFlag, 0
            cmp safeFlag, 1
            jne dontIncSafeCount 
                inc safeCount
            dontIncSafeCount:
                mov safeFlag, 1
        notLastNum:
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