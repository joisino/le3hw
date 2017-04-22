MAIN:
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
RADIX:  
        LI r4 2048      # r4 is the start position of buckets
        LI r1 0         # r1 is an iterator
ITSET:
        ST r4 r1 0      # bucket_iterator[r1] <- 2048 + r1 * 16
        ADDI r4 16
        ADDI r1 1
        CMPI r1 1024    # M: bucket size
        BLT ITSET
        LI r4 0         # r4 is an iterator
RADIXSORT:
        LD r1 r4 1024   # M: array offset
        ADDI r4 1
        MOV r2 r1
        SRL r2 6
        LD r3 r2 0
        ST r1 r3 0      # bucket[a[r4][16..6]][it] <- a[r4]
        ADDI r3 1
        ST r3 r2 0      # it++
        CMPI r4 1024    # M: array size
        BLT RADIXSORT
        LI r4 0         # r4 is an iterator for array position
        LI r3 512       # r3 is an iterator for bucket
        LI r1 8192      # 8192 = 512 * 16
        ADDI r1 2048    # r1 is the start position
MINUS:  
        LD r2 r3 0      # r2 is the end position
        CMP r1 r2
        BE MINUSNEXT    # if empty, go next
        BAL INSERT
        MOV r5 r1
MINUSMOV:
        LD r6 r5 0
        ST r6 r4 1024   # a[r4] <- bucket[r3][r5]
        ADDI r5 1
        ADDI r4 1
        CMP r5 r2
        BLT MINUSMOV
MINUSNEXT:      
        ADDI r3 1
        ADDI r1 16
        CMPI r3 1024    # bucket size
        BLT MINUS
        LI r3 0         # r3 is an iterator for bucket
        LI r1 2048      # r1 is the start position
PLUS:
        LD r2 r3 0      # r2 is the end position
        CMP r1 r2
        BE PLUSNEXT     # if empty, go next
        BAL INSERT
        MOV r5 r1
PLUSMOV:
        LD r6 r5 0
        ST r6 r4 1024
        ADDI r5 1
        ADDI r4 1
        CMP r5 r2
        BLT PLUSMOV
PLUSNEXT:       
        ADDI r3 1
        ADDI r1 16
        CMPI r3 512    # bucket size
        BLT PLUS
        HLT
        NOP
        NOP
        NOP
INSERT:
        MOV r5 r1
        ADDI r5 1
        CMP r2 r5
        BLE INSERTLOOPEND       # if the size <= 1, do nothing
INSERTLOOP:
        LD r6 r5 0              # r6(tmp) <- data[i]
        MOV r7 r5               # j
INSERTLOOPIN:    
        LD r2 r7 -1             # r2 <- data[j-1]
        CMP r2 r6               # !!CAUTION!!: r2 is destroyed
        BLE INSERTLOOPINEND     # if data[j-1] <= tmp, break
        ST r2 r7 0              # data[j] <- data[j-1]
        ADDI r7 -1              # j--
        CMP r1 r7
        BLT INSERTLOOPIN        # if r1 < j, continue
INSERTLOOPINEND:
        ST r6 r7 0              # data[j] <- r6(tmp)
        LD r2 r3 0              # r2 is recovered
        ADDI r5 1
        CMP r5 r2
        BLT INSERTLOOP
INSERTLOOPEND:  
        BR r0
        NOP
        NOP
        NOP
        NOP
