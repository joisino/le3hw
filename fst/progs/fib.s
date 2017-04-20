FIBSTART:
        LI r1 9
        LI r0 0
        B FIB
FIBBACK:
        OUT r2
        HLT
FIB:
        LI r3 2
        CMP r1 r3
        BLT FIBLEAF
        LI r3 1
        SUB r1 r3
        ST r0 r7 0
        ST r1 r7 1
        LI r3 2
        ADD r7 r3
        LI r0 1
        B FIB
FIBBRFST:       
        LI r3 2
        SUB r7 r3
        LD r1 r7 1
        LD r0 r7 0
        LI r3 1
        SUB r1 r3
        ST r0 r7 0
        ST r2 r7 1
        LI r3 2
        ADD r7 r3
        LI r0 2
        B FIB
FIBBRSND:       
        LI r3 2
        SUB r7 r3
        LD r1 r7 1
        LD r0 r7 0
        ADD r2 r1
        B FIBRET
FIBLEAF:
        MOV r2 r1
FIBRET:    
        LI r3 0
        CMP r0 r3
        BE FIBTOBACK
        LI r3 1
        CMP r0 r3
        BE FIBTOFST
        B FIBBRSND
FIBTOBACK:
        B FIBBACK
FIBTOFST:
        B FIBBRFST
        
