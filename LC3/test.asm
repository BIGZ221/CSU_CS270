    .ORIG x3000
    LEA R1, PROMPT
L1  LDR R0, R1, #0
    BRz FOO
L2  LDI R3, DSR
    BRzp L2
    STI R0, DDR
    ADD R1, R1, #1
    BRnzp L1
DSR .FILL xFE04
DDR .FILL xFE06
PROMPT .STRINGZ "Hello World"
FOO
    .END
