MAIN:
        LI r1 0
        LI r2 1
        SLL r2 10 # size
        LI r4 1
        SUB r2 r4
        LI r0 0
        B QUICKSORT
BACK:
        LI r4 0
        LI r5 1
        SLL r5 10
OUTLOOP:
        CMP r2 r4
        BLT END
        LD r6 r5 0
        OUT r6
        LI r6 1
        ADD r5 r6
        ADD r4 r6
        B OUTLOOP
END:    
        HLT
QUICKSORT:
        LI r4 15
        OUT r4
        CMP r2 r1
        BLE RET
        ST r0 r7 0
        ST r1 r7 1
        ST r2 r7 2
        ST r5 r7 3
        ST r6 r7 4
        LI r4 5
        ADD r7 r4
        MOV r4 r1
        ADD r4 r2
        SRL r4 1
        LI r5 1
        SLL r5 10
        ADD r4 r5
        LD r4 r4 0 # pivot
LOOP:
LOOPI:  
        LI r5 1
        SLL r5 10
        ADD r5 r1
        LD r5 r5 0 # a[i]
        CMP r4 r5
        BLE LOOPIEND
        LI r3 1
        ADD r1 r3 # i++
        B LOOPI
LOOPIEND:
LOOPJ:
        LI r6 1
        SLL r6 10
        ADD r6 r2
        LD r6 r6 0 # a[j]
        CMP r6 r4
        BLE LOOPJEND
        LI r3 1
        SUB r2 r3 # j--
        B LOOPJ
LOOPJEND:
        CMP r2 r1
        BLE LOOPEND
        LI r3 1
        SLL r3 10
        ADD r3 r1
        ST r6 r3 0
        SUB r3 r1
        ADD r3 r2
        ST r5 r3 0
        LI r3 1
        ADD r1 r3
        SUB r2 r3
        B LOOP
LOOPEND:
        MOV r5 r1
        MOV r6 r2
        LD r1 r7 -4
        MOV r2 r5
        LI r3 1
        SUB r2 r3
        LI r0 1
        B QUICKSORT
BRFST:  
        MOV r1 r6
        LI r3 1
        ADD r1 r3
        LD r2 r7 -3
        LI r0 2
        B QUICKSORT
BRSND:
        LI r4 5
        SUB r7 r4
        LD r0 r7 0
        LD r1 r7 1
        LD r2 r7 2
        LD r5 r7 3
        LD r6 r7 4
        B RET
RET:
        LI r4 0
        CMP r4 r0
        BE BACK
        LI r4 1
        CMP r4 r0
        BE BRFST
        B BRSND
        
        
        
        
