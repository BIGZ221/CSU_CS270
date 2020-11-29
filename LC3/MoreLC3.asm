    ; Recitation MoreLC3
    ; Author: Zachary Fuchs
    ; Date:   10/09/2020
    ; Email:  zachf@colostate.edu
    ; Class:  CS270
    ; Description: Mirrors least significant byte to most significant

                    .ORIG x3000

                    JSR mirror           ; call function
                    HALT

    ; Parameter and return value
    Param           .BLKW 1              ; space to specify parameter
    Result          .BLKW 1              ; space to store result

    ; Constants
    One             .FILL #1             ; the number 1       
    Eight           .FILL #8             ; the number 8
    Mask            .FILL x00ff          ; mask top bits

    ;--------------------------------------------------------------------------
    mirror                               ; Mirrors bits 7:0 to 15:8
                                         ; ~20 lines of assembly code
     
                    LD R0,Param          ; load pattern
                    .COPY R1,R0          ; Copy R0 into R1
                    LD R2,Mask           ; R2 is the mask
                    AND R1,R1,R2         ; Clear bits 15:8 in R1
                    LD R2,One            ; Source mask R2 is now 1
                    LD R3,One            ; Destination mask R3 is now 1
                    LD R4,Eight          ; Counter
                    
    LSloopbegin     BRnz LSloopend       ; if R4 is negative or zero exit the loop
                    ADD R3,R3,R3         ; Left shift 1
                    ADD R4,R4,#-1
                    BRnzp LSloopbegin
    LSloopend
                    LD R4,Eight          ; Reset Counter back to 8
    loopStart       BRnz loopEnd
                    AND R5,R0,R2         ; Check if bit in source mask (R2) is set in the parameter (R0)
                    BRnz skipLine
                    ADD R1,R1,R3         ; Add Destination mask to Result
    skipLine        ADD R2,R2,R2         ; Left Shift 1
                    ADD R3,R3,R3
                    ADD R4,R4,#-1
                    BRnzp loopStart
    loopEnd         
                    
                    ST R1,Result         ; store result
                    RET
    ;--------------------------------------------------------------------------
                   .END
