START:
        LI r3 1
        SLL r3 7        # ! iterator
        LI r2 2         # i+1
        SLL r2 7        # [1,128)
        LD r6 r3 1023
JUN:
        MOV r5 r6
        LD r6 r3 1024
        ADDI r3 1
        CMP r6 r5
        BLT JUNNG
        CMP r3 r2
        BLT JUN
JUNOK:
        LI r5 18
        SLL r5 10
        LOCK r5         #
        LD r6 r5 0      # set 0
        ADDI r6 1       #
        ST r6 r5 0      #
        UNLOCK r5       #
JUNWAIT:
        LI r6 0
JUNNOP:
        ADDI r6 1       #
        CMPI r6 32      #
        BLT JUNNOP      # NOP
        LD r6 r5 0
        CMPI r6 0
        BLT JUNEND
        CMPI r6 8       # #core
        BLT JUNWAIT
        HLT
JUNNG:
        LI r5 18
        SLL r5 10
        LI r6 -72       # set 0
        LOCK r5         #
        ST r6 r5 0      #
        UNLOCK r5       #
JUNEND:
        LI r3 1
        SLL r3 7        # ! iterator
        LD r6 r3 1023   # initial value
GYAKU:
        MOV r5 r6
        LD r6 r3 1024
        ADDI r3 1
        CMP r5 r6
        BLT GYAKUNG
        CMP r3 r2
        BLT GYAKU
GYAKUOK:
        LI r5 18
        SLL r5 10
        LOCK r5         #
        LD r6 r5 1      # set at 1
        ADDI r6 1       #
        ST r6 r5 1      #
        UNLOCK r5       #
GYAKUWAIT:
        LI r6 0
GYAKUNOP:
        ADDI r6 1       #
        CMPI r6 32      #
        BLT GYAKUNOP    # NOP
        LD r6 r5 1
        CMPI r6 0
        BLT GYAKUEND
        CMPI r6 8       # #core
        BLT GYAKUWAIT
REVSTART:               
        LI r1 1         # ! start i
        SLL r1 6
        LI r2 15        # 16 - i
        SLL r2 6        # ! start at 1024
        LI r3 2         # i + 1
        SLL r3 6        # ! [0, 64)
REV:
        LD r5 r2 1023
        LD r6 r1 1024
        ST r5 r1 1024
        ST r6 r2 1023
        ADDI r1 1
        ADDI r2 -1
        CMP r1 r3
        BLT REV
        LI r5 18
        SLL r5 10
        LOCK r5         #
        LD r6 r5 2      # set at 2
        ADDI r6 1       #
        ST r6 r5 2      #
        UNLOCK r5       #
REVWAIT:
        LI r6 0
REVNOP:
        ADDI r6 1       #
        CMPI r6 32      #
        BLT REVNOP      # NOP
        LD r6 r5 2
        CMPI r6 0
        BLT GYAKUEND
        CMPI r6 8       # #core
        BLT REVWAIT
        HLT
GYAKUNG:
        LI r5 18
        SLL r5 10
        LI r6 -72       # set at 2
        LOCK r5         #
        ST r6 r5 2      #
        UNLOCK r5       #
GYAKUEND:
RADIX:
        LI r1 1         # ! r1 is an iterator (i)
        MOV r4 r1
        SLL r4 4
        ADDI r4 2048    # r4 is the start position of buckets
ITSET:
        NOP
        NOP
        ST r4 r1 0      # bucket_iterator[r1] <- 2048 + r1 * 16
        ADDI r4 128
        ADDI r1 8
        CMPI r1 1024    # M: bucket size
        BLT ITSET
        LI r5 18
        SLL r5 10
        LOCK r5         #
        LD r6 r5 3      # set at 3
        ADDI r6 1       #
        ST r6 r5 3      #
        UNLOCK r5       #
ITWAIT:
        LI r6 0
ITNOP:
        ADDI r6 1       #
        CMPI r6 32      #
        BLT ITNOP       # NOP
        LD r6 r5 3
        CMPI r6 8       # #core
        BLT ITWAIT
        LI r4 1         # ! r4 is an iterator (i)
RADIXSORT:
        LD r1 r4 1024   # M: array offset
        ADDI r4 8
        MOV r2 r1
        SRL r2 6
        LOCK r2
        LD r3 r2 0
        ST r1 r3 0      # bucket[a[r4][16..6]][it] <- a[r4]
        ADDI r3 1
        ST r3 r2 0      # it++
        UNLOCK r2
        CMPI r4 1024    # M: array size
        BLT RADIXSORT
        LI r5 18
        SLL r5 10
        LOCK r5         #
        LD r6 r5 4      # set at 4
        ADDI r6 1       #
        ST r6 r5 4      #
        UNLOCK r5       #
RADIXWAIT:
        LI r6 0
RADIXNOP:
        ADDI r6 1       #
        CMPI r6 32      #
        BLT RADIXNOP    # NOP
        LD r6 r5 4
        CMPI r6 8       # #core
        BLT RADIXWAIT
CALCINDEX:
        LI r2 0         # accumulator
        LI r3 2         # ! initial pos (i+1)
        SLL r3 11
        LI r5 1         # ! i
        SLL r5 7        # start
        LI r6 2         # ! i+1
        SLL r6 7        # end backet
CALCLOOP:
        LD r4 r5 0
        ADDI r5 1
        SUB r4 r3
        ADD r2 r4
        ADDI r3 16
        CMP r5 r6
        BLT CALCLOOP
        LI r3 19
        SLL r3 10
        ST r2 r3 1      # ! save pos i
        LI r5 18
        SLL r5 10
        LOCK r5         #
        LD r6 r5 5      # set at 5
        ADDI r6 1       #
        ST r6 r5 5      #
        UNLOCK r5       #
CALCWAIT:
        LI r6 0
CALCNOP:
        ADDI r6 1       #
        CMPI r6 32      #
        BLT CALCNOP     # NOP
        LD r6 r5 5
        CMPI r6 8       # #core
        BLT CALCWAIT
        LD r4 r3 4      # ! r4 is an iterator for array position
        LI r3 5         # ! i + 4
        SLL r3 7        # r3 is an iterator for bucket
        LI r1 6         # ! i + 5
        SLL r1 11       # r1 is the start position
FINAL:
FINAL:
        LD r2 r3 0      # r2 is the end position
        CMP r1 r2
        BE FINALNEXT    # if empty, go next
        MOV r5 r2
        SUB r5 r1
        CMPI r5 1
        BE INSERTEND    # if size == 1, skip insert sort
        BAL INSERT
INSERTEND:      
        MOV r5 r1
FINALMOV:
        LD r6 r5 0
        ADDI r5 1
        ST r6 r4 1024   # a[r4] <- bucket[r3][r5]
        ADDI r4 1
        CMP r5 r2
        BLT FINALMOV
FINALNEXT:      
        ADDI r3 1
        ADDI r1 16
        LI r7 6         # ! i + 5
        SLL r7 7        # r7 is end bucket
        CMP r3 r7
        BLT FINAL
        LI r5 18
        SLL r5 10
        LOCK r5         #
        LD r6 r5 6      # set at 6
        ADDI r6 1       #
        ST r6 r5 6      #
        UNLOCK r5       #
FINALWAIT:
        LI r6 0
FINALNOP:
        ADDI r6 1       #
        CMPI r6 32      #
        BLT FINALNOP    # NOP
        LD r6 r5 6
        CMPI r6 8       # #core
        BLT FINALWAIT
        HLT
        NOP
        NOP
        NOP
INSERT:                         # size must be >= 2
        MOV r5 r1
        ADDI r5 1
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
