; P5 Assignment
; Author: Zachary Fuchs
; Date:   10/09/2020
; Email:  zachf@colostate.edu
; Class:  CS270
;
; Description: Implements the arithmetic, bitwise, and shift operations

;------------------------------------------------------------------------------
; Begin reserved section: do not change ANYTHING in reserved section!

                .ORIG x3000
                BR Main

Functions       .FILL IntAdd         ; Address of IntAdd routine     (option 0)
                .FILL IntSub         ; Address of IntSub routine     (option 1)
                .FILL IntMul         ; Address of IntMul routine     (option 2)
                .FILL BinaryOr       ; Address of BinaryOr routine   (option 3)
                .FILL LeftShift      ; Address of LeftShift routine  (option 4)
                .FILL RightShift     ; Address of RightShift routine (option 5)

Main            LEA R0,Functions     ; The main routine calls one of the 
                LD  R1,Option        ; subroutines below based on the value of
                ADD R0,R0,R1         ; the Option parameter.
                LDR R0,R0,0          ;
                JSRR R0              ;
EndProg         HALT                 ;

; Parameters and return values for all functions
; Try changing the .BLKW 1 to .FILL xNNNN where N is a hexadecimal value or #NNNN
; where N is a decimal value, this can save you time by not having to set these 
; values in the simulator every time you run your code. This is the only change 
; you should make to this section.
Option          .FILL #0             ; Which function to call
Param1          .BLKW 1              ; Space to specify first parameter
Param2          .BLKW 1              ; Space to specify second parameter
Result          .BLKW 1              ; Space to store result

; End reserved section: do not change ANYTHING in reserved section!
;------------------------------------------------------------------------------

; You may add variables and functions after here as you see fit.

;------------------------------------------------------------------------------
IntAdd                               ; Result is Param1 + Param2
                                     ; Your code goes here (~4 lines)
                LD R0,Param1         ; R0 holds Param1
                LD R1,Param2         ; R1 holds Param2
                ADD R1,R1,R0         ; Adding R0 to R1 then storing the result in R1
                ST R1,Result         ; Stores R1 in Result
                RET
;------------------------------------------------------------------------------
IntSub                               ; Result is Param1 - Param2
                                     ; Your code goes here (~6 lines)
                LD R0,Param1         ; R0 holds Param1
                LD R1,Param2         ; R1 holds Param2
                NOT R1,R1            ; Step 1 of twos complement
                ADD R1,R1,#1         ; Step 2 of twos complement
                ADD R1,R1,R0         ; Adds Param1 and -Param2
                ST R1,Result         ; Store R1 in Result
                RET
;------------------------------------------------------------------------------
IntMul                               ; Result is Param1 * Param2
                                     ; Your code goes here (~9 lines)
                .ZERO R2             ; Running total
                LD R0,Param1         ; R0 holds Param1
                LD R1,Param2         ; R1 holds Param2 used as counter for loop
mulLoopStart    BRnz mulLoopEnd      ; When counter is negative or zero branch to the mulLoopEnd
                ADD R2,R2,R0         ; 
                ADD R1,R1,#-1        ; Decrement counter
                BRnzp mulLoopStart
mulLoopEnd      
                ST R2,Result         ; Store the product of Param1 and Param 2 in Result
                RET
;------------------------------------------------------------------------------
BinaryOr                             ; Result is Param1 | Param2
                                     ; Your code goes here (~7 lines)
                LD R0,Param1         ; R0 Holds Param1
                LD R1,Param2         ; R1 Holds Param2
                NOT R0,R0            ; Step 1 of Demorgan 
                NOT R1,R1            ; Step 2 of Demorgan
                AND R2,R0,R1         ; Step 3 of Demorgan
                NOT R2,R2            ; Step 4 of Demorgan
                ST R2,Result
                RET
;------------------------------------------------------------------------------
LeftShift                            ; Result is Param1 << Param2
                                     ; (Fill vacant positions with 0's)
                                     ; Your code goes here (~7 lines)
                LD R0,Param1
                LD R1,Param2         ; Loop Counter
lSLoopStart     BRnz lSLoopEnd
                ADD R0,R0,R0
                ADD R1,R1,#-1
                BRnzp lsLoopStart
lSLoopEnd
                ST R0,Result
                RET
;------------------------------------------------------------------------------
RightShift                           ; Result is Param1 >> Param2
                                     ; (Fill vacant positions with 0's)
                                     ; Your code goes here (~16 lines)
                .ZERO R0             ; R0 is Result
                .ZERO R1             
                .ZERO R2
                LD R3,Param1
                LD R4,Param2
                ADD R1,R1,#1         ; Set source mask
                ADD R2,R2,#1         ; Set destination mask 
lsSource        BRnz lsSourceEnd
                ADD R1,R1,R1
                ADD R4,R4,#-1        ; Loop to leftshift source mask by Param2
                BRnzp lsSource       ; Everything above this is used to setup
lsSourceEnd                          ; both masks, and set R0 to 0 for result
            
checkStart      
                AND R4,R3,R1
                BRz over
                ADD R0,R0,R2
over            ADD R1,R1,R1         ; Left Shift Source mask once
                BRz checkEND
                ADD R2,R2,R2         ; Left Shift Destination mask once
                BRnzp checkStart
checkEnd
                ST R0,Result
                RET
;------------------------------------------------------------------------------
                .END
