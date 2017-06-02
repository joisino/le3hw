# jcc

C っぽい言語のコンパイラ

## インストール方法

bison -dv jcc.y -o jcc.tab.cpp
flex jcc.l
gcc -c lex.yy.c -o lex.yy.o
g++ lex.yy.o jcc.cpp jcc.tab.cpp -o jcc -std=gnu++11

## 使い方

./jcc < program.c

or

./jcc.sh program.c