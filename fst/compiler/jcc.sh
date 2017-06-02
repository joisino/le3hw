if [ $# != 2 ]; then
    echo "Usage $0 filename"
fi

./jcc < $1 > a.s
../assembler/asm a.s > a.o
