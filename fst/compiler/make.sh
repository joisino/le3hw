bison -dv jcc.y -o jcc.tab.cpp
if [ $? != 0 ]; then
   exit 1;
fi
flex jcc.l
if [ $? != 0 ]; then
   exit 1;
fi
gcc -c lex.yy.c -o lex.yy.o
if [ $? != 0 ]; then
   exit 1;
fi
g++ lex.yy.o jcc.cpp jcc.tab.cpp -o jcc -std=gnu++11
if [ $? != 0 ]; then
   exit 1;
fi
