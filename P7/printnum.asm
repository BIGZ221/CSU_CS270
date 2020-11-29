; Author: Fritz Sieker
;
; ------------------------------------------------------------------------
; Begin reserved section - do not change ANYTHING is this section
; except the .FILL values of option, data1, data2

               .ORIG x3000
               BR Main

option         .FILL 0          ; select routine to test
data1          .FILL 0          ; use ONLY for testing
data2          .FILL 0          ; use ONLY for testing

stackBase      .FILL X4000      ; initial sttack pointer

Main           LD R6,stackBase  ; initialize stack pointer
               LD R0,option     ; select routine to test
               BRZ testPrintNum ; option = 0 means test printNum

               ADD R0,R0,#-1
               BRZ testGetDigit ; option = 1 means test getDidit

               ADD R0,R0,#-1
               BRZ testDivRem   ; option = 2 means test divRem

               HALT             ; invalid option if here

testPrintNum                    ; call printNum(x, base)
               LD R0,data2
               PUSH R0          ; push base argument
               LD R0,data1
               PUSH R0          ; push value argument
               JSR printNum
               ADD R6,R6,#2     ; caller clean up 2 parameters
               BR endTest

testGetDigit                    ; call getChar(val)
               LD R0,data1
               PUSH R0          ; push argument (val to convert to ASCII)
               JSR getDigit     ; 
               POP R0           ; get the corresponding character
               ADD R6,R6,#1     ; caller clean up 1 parameter
               OUT              ; print the digit
               NEWLN
               BR endTest

testDivRem                      ; call divRem(num, denom, *quotient, *remainder)
               LEA R0,data2     ; get pointer to remainder (&data2)
               PUSH R0
               LEA R0,data1     ; get pointer to quotient (&data1)
               PUSH R0
               LD R0,data2
               PUSH R0          ; push demoninator
               LD R0,data1
               PUSH R0          ; push numerator
               JSR divRem       ; call routine
               ADD R6,R6,#4     ; caller clean up 4 parameters

endTest        LEA R0,endMsg
               PUTS
theEnd         HALT             ; look at data1/data2 for quotient/remainder

                                ; useful constants
endMsg         .STRINGz "\nTest complete!\n"

negSign        .FILL    x2D     ; ASCII '-'
digits         .STRINGZ "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ" ; up to base 36

; end reserved section

; ------------------------------------------------------------------------
; Author: Zachary Fuchs
; ------------------------------------------------------------------------
;
; C declaration: char getDigit (int val);

getDigit                        ; callee setup
               ADD R6,R6,#-1
               PUSH R7
               PUSH R5
               ADD R5,R6,#-1
                                ; code for getDigit
               LEA R0,digits    ; R0 = &digits
               LDR R1,R5,#4     ; R1 = val
               ADD R0,R1,R0
               LDR R0,R0,#0     ; R0 = *(R0+R1)
                                ; callee cleanup
               STR R0,R5,#3
               POP R5
               POP R7
               
               RET              ; return
; ------------------------------------------------------------------------
;
; C declaration: void divRem(int num, int denom, int*quotient, int*remainder);

divRem                          ; callee setup
               PUSH R7
               PUSH R5
               ADD R6,R6,#-1
               ADD R5,R6,#0
                                ; code for divRem
               AND R0,R0,#0     ; R0 = *quotient = 0
               LDR R3,R5,#5
               STR R0,R3,#0     ; 
               LDR R1,R5,#4
               NOT R1,R1
               ADD R1,R1,#1
               STR R1,R5,#0     ; R1 = negDenominator = -denom
               
               LDR R2,R5,#3     ; R2 = numerator
               BRn negDivRemLoop1
               
divRemLoop     ADD R3,R2,R1     ; R3 = num - denom, while num >= denom
               BRn endDivRem
               ADD R2,R2,R1     ; R2 = num -= denom
               ADD R0,R0,#1
               LDR R3,R5,#5
               STR R0,R3,#0     ; R0 = *quotient += 1
               BRnzp divRemLoop
               
negDivRemLoop1 LDR R1,R5,#4
negDivRemLoop2 ADD R2,R2,R1     ; R2 = num += denom
               ADD R0,R0,#-1
               LDR R3,R5,#5
               STR R0,R3,#0     ; R0 = *quotient -= 1
               ADD R3,R2,R1     ; R3 = num +denom, while num <= denom
               BRnz negDivRemLoop2
               ADD R2,R2,R1     ; R2= num += denom
               ADD R0,R0,#-1
               LDR R3,R5,#5
               STR R0,R3,#0     ; R0 = *quotient -= 1
endDivRem
               LDR R3,R5,#6
               STR R2,R3,#0     ; *remainder = num
                                ; callee cleanup
               ADD R6,R6,#1
               POP R5
               POP R7
               RET              ; return
; ------------------------------------------------------------------------
;
; C declaration: void printNum (int val, int base);

printNum                        ; callee setup
               PUSH R7
               PUSH R5
               ADD R5,R6,#-1
               ADD R6,R6,#-2
                                ; code for printNum
               LDR R0,R5,#3     ; R0 = num
               BRzp overNeg
               NOT R0,R0
               ADD R0,R0,#1
               STR R0,R5,#3
               LEA R0,negSign
               LDR R0,R0,#0
               OUT              ; If num is negative print negative sign
overNeg
               ADD R0,R5,#-1
               PUSH R0          ; Caller Push Ptr to Remainder
               ADD R0,R5,#0
               PUSH R0          ; Caller Push Ptr to Quotient
               LDR R0,R5,#4
               PUSH R0          ; Caller Push Denominator/Base
               LDR R0,R5,#3
               PUSH R0          ; Caller Push Numerator/val
breakste
               JSR divRem       ; call routine
               ADD R6,R6,#4     ; caller clean up 4 parameters
testingbreak
               LDR R0,R5,#0
               BRz printNumQZ  ; Test if quotient == 0 meaning
                                ; to stop calling printNum
               LDR R0,R5,#4
               PUSH R0          ; Caller push base argument
               LDR R0,R5,#0
               PUSH R0          ;  Callerpush value argument
               JSR printNum
               ADD R6,R6,#2     ; caller clean up 2 parameters
printNumQZ
               LDR R0,R5,#-1
               PUSH R0          ; push argument (val to convert to ASCII)
               JSR getDigit     ; 
               POP R0           ; get the corresponding character
               ADD R6,R6,#1     ; caller clean up 1 parameter
               OUT              ; print the digit
                                ; callee cleanup
               ADD R6,R6,#2
               POP R5
               POP R7
               RET              ; return
; ------------------------------------------------------------------------
               .END
