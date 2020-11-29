; Begin reserved section: do not change ANYTHING in reserved section!
; The ONLY exception to this is that you MAY change the .FILL values for
; Option, Value1 and Value2. This makes it easy to initialize the values in the
; program, so that you do not need to continually re-enter them. This
; makes debugging easier as you need only change your code and re-assemble.
; Your test value(s) will already be set.
;------------------------------------------------------------------------------
; Author: Fritz Sieker
;
; Description: Tests the implementation of a simple string library and I/O
;

            .ORIG x3000
            BR Main
Functions
            .FILL Test_pack         ; (option 0)
            .FILL Test_unpack       ; (option 1)
            .FILL Test_printCC      ; (option 2)
            .FILL Test_strlen       ; (option 3)
            .FILL Test_strcpy       ; (option 4)
            .FILL Test_strcat       ; (option 5)
            .FILL Test_strcmp       ; (option 6)

; Parameters and return values for all functions
Option      .FILL 0                 ; which function to call
String1     .FILL x4000             ; default location of 1st string
String2     .FILL x4100             ; default location of 2nd string
Result      .BLKW 1                 ; space to store result
Value1      .FILL 0                 ; used for testing pack/unpack
Value2      .FILL 0                 ; used for testing pack/unpack
lowerMask   .FILL 0x00FF            ; mask for lower 8 bits
upperMask   .FILL 0xFF00            ; mask for upper 8 bits

Main        LEA R0,Functions        ; get base of jump table
            LD  R1,Option           ; get option to use, no error checking
            ADD R0,R0,R1            ; add index of array
            LDR R0,R0,#0            ; get address to test
            JMP R0                  ; execute test

Test_pack   
            LD R0,Value1            ; load first character
            LD R1,Value2            ; load second character
            JSR pack                ; pack characters
            ST R0,Result            ; save packed result
End_pack    HALT                    ; done - examine Result

Test_unpack 
            LD R0,Value1            ; value to unpack
            JSR unpack              ; test unpack
            ST R0,Value1            ; save upper 8 bits
            ST R1,Value2            ; save lower 8 bits
End_unpack  HALT                    ; done - examine Value1 and Value2

Test_printCC    
            LD R0,Value1            ; get the test value
            .ZERO R1                ; reset condition codes
            JSR printCC             ; print condition code
End_printCC HALT                    ; done - examine output

Test_strlen 
            LD R0,String1           ; load string pointer
            GETS                    ; get string
            LD R0,String1           ; load string pointer
            JSR strlen              ; calculate length
            ST R0,Result            ; save result
End_strlen  HALT                    ; done - examine memory[Result]

Test_strcpy 
            LD R0,String1           ; load string pointer
            GETS                    ; get string
            LD R0,String2           ; R0 is dest
            LD R1,String1           ; R1 is src
            JSR strcpy              ; copy string
            PUTS                    ; print result of strcpy
            NEWLN                   ; add newline
End_strcpy  HALT                    ; done - examine output

Test_strcat 
            LD R0,String1           ; load first pointer
            GETS                    ; get first string
            LD R0,String2           ; load second pointer
            GETS                    ; get second string
            LD R0,String1           ; dest is first string
            LD R1,String2           ; src is second string
            JSR strcat              ; concatenate string
            PUTS                    ; print result of strcat
            NEWLN                   ; add newline
End_strcat  HALT                    ; done - examine output

Test_strcmp 
            LD R0,String1           ; load first pointer
            GETS                    ; get first string
            LD R0,String2           ; load second pointer
            GETS                    ; get second string
            LD R0,String1           ; dest is first string
            LD R1,String2           ; src is second string
            JSR strcmp              ; compare strings
            JSR printCC             ; print result of strcmp
End_strcmp  HALT                    ; done - examine output

;------------------------------------------------------------------------------
; End of reserved section
;------------------------------------------------------------------------------

;------------------------------------------------------------------------------
; on entry R0 contains first value, R1 contains second value
; on exit  R0 = (R0 << 8) | (R1 & 0xFF)
ffMask      .FILL xFF
pack        ; fill in your code, ~11 lines of code
            .ZERO R2
            LD R3,ffMask
            ADD R2,R2,#8
lsStart     BRz lsEnd
            ADD R0,R0,R0
            ADD R2,R2,#-1
            BRnzp lsStart
lsEnd       AND R1,R1,R3            ; R1 & 0xFF
            NOT R0,R0
            NOT R1,R1
            AND R0,R1,R0
            NOT R0,R0               ; Line 117 to 121 Demorgan
            RET

;------------------------------------------------------------------------------
; on entry R0 contains a value
; on exit  (see instructions)
dMask       .FILL x100
saveR1      .BLKW 1
unpack      ; fill in your code, ~14 lines of code
            LD R2,dMask             ; R2 will hold 0x100 used for rightshift
            LD R3,ffMask            ; R3 will hold 0xFF
            .ZERO R4                ; R4 will be a placeholder while RShift
            ADD R4,R4,R0            ; Sets R4 = R0
            .ZERO R0                ; Zero out R0
            AND R1,R4,R3            ; Put bits [7:0] of R4 into R1
            ST R1,saveR1            ; Store R1 in saveR1 so R1 can be used
            .ZERO R3
            ADD R3,R3,#1            ; R3 is the source mask for Rshift
rsStart     AND R1,R2,R4
            BRz overUnPack
            ADD R0,R0,R3            ; When the bit specified in R2 is set in R4
                                    ; Set the bit right shifted 8 times in R0
overUnPack  ADD R2,R2,R2
            ADD R3,R3,R3
            BRnp rsStart
            LD R1,saveR1
            RET

;------------------------------------------------------------------------------
; on entry R0 contains value
; on exit  (see instructions)

StringNEG   .STRINGZ "NEGATIVE\n"   ; output strings
StringZERO  .STRINGZ "ZERO\n"
StringPOS   .STRINGZ "POSITIVE\n"
saveR0      .BLKW 1
saveR7      .BLKW 1
printCC     ; fill in your code, ~11 lines of code
            ST R7,saveR7
            ST R0,saveR0
            ADD R0,R0,#0            ; Set the condition codes
ccStart     BRzp nonNeg
            LEA R0,StringNEG
            BRnzp endOfCC
nonNeg      BRnp nonZer
            LEA R0,StringZERO
            BRnzp endOfCC
nonZer      BRnz ccStart
            LEA R0,StringPOS
endOfCC     PUTS
            LD R0,saveR0
            LD R7,saveR7
            RET

;------------------------------------------------------------------------------
; size_t strlen(char *s)
; on entry R0 points to string
; on exit  (see instructions)
            
strlen      ; fill in your code, ~7 lines of code
            .ZERO R1                ; R1 holds length so far
startStrLen
            LDR R2,R0,#0
            BRz endStrLen
            ADD R1,R1,#1
            ADD R0,R0,#1
            BRnzp startStrLen
endStrLen   .ZERO R0
            ADD R0,R0,R1
            RET

;------------------------------------------------------------------------------
; char *strcpy(char *dest, char *src)
; on entry R0 points to destination string, R1 points to source string
; on exit  (see instructions)
strcpyR0     .BLKW 1
strCpyStart ADD R0,R0,#1
            ADD R1,R1,#1
            BRnzp lazy
strcpy      ; fill in your code, ~8 lines of code
            ST R0,strcpyR0
lazy
            LDR R2,R1,#0            ; Load the character R1 points to in R2
            STR R2,R0,#0            ; Store contents of R2 to where R0 points
            BRnp strCpyStart        ; Since STR doesn't change CC will run till
                                    ; R2 contains the null terminated character
                                    ; of R1 which gets copied then we return
            LD R0,strcpyR0
            RET

;------------------------------------------------------------------------------
; char *strcat(char *dest, char *src)
; on entry R0 points to destination string, R1 points to source string
; on exit  (see instructions)

strcat_RA   .BLKW 1                 ; space for return address
strcat_dest .BLKW 1                 ; space for dest
strcat_src  .BLKW 1                 ; space for src

strcat      ST R7,strcat_RA         ; save return address
            ST R0,strcat_dest       ; save dest
            ST R1,strcat_src        ; save src

            ; fill in your code, ~5 lines of code
            .ZERO R2
            JSR strlen
            LD R2,strcat_dest
            ADD R0,R0,R2
            LD R1,strcat_src
            JSR strcpy
            ; HINT: call strlen and strcpy

            LD R0,strcat_dest       ; restore dest
            LD R7,strcat_RA         ; restore return address
            RET

;------------------------------------------------------------------------------
; int strcmp(char *s1, char *s2)
; on entry R0 points to first string, R1 points to second string
; on exit  (see instructions)
strcmp      ; fill in your code, ~12 lines of code
            LDR R2,R0,#0
            BRz over1
            ADD R0,R0,#1
over1
            LDR R3,R1,#0
            BRz over2
            ADD R1,R1,#1
over2
            ADD R4,R2,R3
            BRz strCmpEnd
            NOT R3,R3
            ADD R3,R3,#1           ; 2's Complement
            ADD R4,R2,R3
            BRz strcmp             ; If the r2,r3 are different, we are done
strCmpEnd   ADD R0,R4,#0
            RET
;------------------------------------------------------------------------------
            .END
