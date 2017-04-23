MAIN:
        LI r7 0
        LI r1 0
        LI r2 1023
        LI r3 1
JUN:
        LD r5 r3 1023
        LD r6 r3 1024
        CMP r6 r5
        BLT JUNEND
        ADDI r3 1
        CMP r3 r2
        BLE JUN
JUNOK:
        HLT
JUNEND:
        LI r3 1
GYAKU:
        LD r5 r3 1023
        LD r6 r3 1024
        CMP r5 r6
        BLT GYAKUEND
        ADDI r3 1
        CMP r3 r2
        BLE GYAKU
GYAKUOK:
        MOV r3 r2
        ADD r3 r1
        SRL r3 1
REV:
        LD r5 r2 1024
        LD r6 r1 1024
        ST r5 r1 1024
        ST r6 r2 1024
        ADDI r1 1
        ADDI r2 -1
        CMP r1 r3
        BLE REV
REVEND:
        HLT
GYAKUEND:
        BAL QUICKSORT
BACK:
        HLT
QUICKSORT:
        ST r0 r7 0
        ST r1 r7 1
        ST r2 r7 2
        ST r5 r7 3
        ST r6 r7 4
        ADDI r7 5
        MOV r3 r2  # r2 - r1 <= 16 -> insert sort
        SUB r3 r1  # 
        CMPI r3 16 #
        BLE INSERT #
        MOV r4 r1
        ADD r4 r2
        SRL r4 1
        LD r4 r4 1024 # pivot
LOOP:
LOOPI:
        LD r5 r1 1024 # a[i]
        ADDI r1 1 # i++
        CMP r5 r4
        BLT LOOPI
LOOPIEND:
        ADDI r1 -1
LOOPJ:
        LD r6 r2 1024 # a[j]
        ADDI r2 -1 # j--
        CMP r4 r6
        BLT LOOPJ
LOOPJEND:
        ADDI r2 1
        CMP r2 r1
        BLE LOOPEND
        ST r6 r1 1024
        ST r5 r2 1024
        ADDI r1 1
        ADDI r2 -1
        B LOOP
LOOPEND:
        MOV r5 r1
        MOV r6 r2
        LD r1 r7 -4
        MOV r2 r5
        ADDI r2 -1
        BAL QUICKSORT
        MOV r1 r6
        ADDI r1 1
        LD r2 r7 -3
        BAL QUICKSORT
RET:    
        ADDI r7 -5
        LD r0 r7 0
        LD r1 r7 1
        LD r2 r7 2
        LD r5 r7 3
        LD r6 r7 4
        BR r0
INSERT:
        MOV r3 r1
        ADDI r3 1
        CMP r2 r3
        BLT INSERTLOOPEND       # if the size <= 1, do nothing
INSERTLOOP:
        LD r4 r3 1024           # r4(tmp) <- data[i]
        MOV r5 r3               # j
INSERTLOOPIN:    
        LD r6 r5 1023           # r6 <- data[j-1]
        CMP r6 r4               
        BLE INSERTLOOPINEND     # if data[j-1] <= tmp, break
        ST r6 r5 1024           # data[j] <- data[j-1]
        ADDI r5 -1              # j--
        CMP r1 r5
        BLT INSERTLOOPIN        # if r1 < j, continue
INSERTLOOPINEND:
        ST r4 r5 1024           # data[j] <- r4(tmp)
        ADDI r3 1
        CMP r3 r2
        BLE INSERTLOOP
INSERTLOOPEND:  
        B RET
        NOP
        NOP
        NOP
        NOP
