%{
#include <stdio.h>
#include "jcc.tab.hpp"
%}
%%

[\n\t ]+ {}
";" {
  return SEMI;
}
"+" {
  return PLUS;
}
"-" {
  return MINUS;
}
"&" {
  return AND;
}
"^" {
  return XOR;
}
"|" {
  return OR;
}
"(" {
  return LPAR;
}
")" {
  return RPAR;
}
">>" {
  return RSHIFT;
}
"<<" {
  return LSHIFT;
}
"int" {
  return INT;
}
"=" {
  return EQ;
}
[[:alpha:]][[:alnum:]]* {
  sscanf( yytext, "%s", yylval.str );
  return IDENTIFIER;
}
[+-]?[1-9][0-9]* {
  int temp;
  sscanf( yytext, "%d", &temp );
  yylval.val = (int16_t)temp;
  return NUM;
}
%%
