#ifndef _LEX
#define _LEX

extern "C"{
   int yyparse();
   int yylex();
   int yywrap(){
     return 1;
   }
 }

#endif
