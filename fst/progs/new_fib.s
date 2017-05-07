FIBTWO:
        LI r1 10
        BAL FIB
        OUT r2
        HLT
FIB:
        CMPI r1 2
        BLT FIBLEAF
        ST r0 r7 0
        ST r1 r7 1
        ST r3 r7 2
        ADDI r7 3
        ADDI r1 -1
        BAL FIB
        ADDI r1 -1
        MOV r3 r2
        BAL FIB
        ADD r2 r3
        ADDI r7 -3
        LD r0 r7 0
        LD r1 r7 1
        LD r3 r7 2
        BR r0
FIBLEAF:
        MOV r2 r1
        BR r0
        
