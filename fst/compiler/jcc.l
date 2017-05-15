%{
#include <stdio.h>
#include "jcc.tab.hpp"
%}
%%

[\n\t ]+ {}
";" {
  return SEMI;
}
"," {
  return COMMA;
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
"{" {
  return LBRACE;
}
"}" {
  return RBRACE;
}
"[" {
  return LBRACK;
}
"]" {
  return RBRACK;
}
">>" {
  return RSHIFT;
}
"<<" {
  return LSHIFT;
}
"<" {
  return LT;
}
"<=" {
  return LE;
}
">" {
  return GT;
}
">=" {
  return GE;
}
"==" {
  return EQEQ;
}
"!=" {
  return NEQ;
}
"int" {
  return INT;
}
"=" {
  return EQ;
}
"if" {
  return IF;
}
"else" {
  return ELSE;
}
"while" {
  return WHILE;
}
"for" {
  return FOR;
}
"return" {
  return RETURN;
}
"continue" {
  return CONTINUE;
}
"break" {
  return BREAK;
}
"out" {
  return OUT;
}
"in" {
  return IN;
}
[[:alpha:]][[:alnum:]]* {
  sscanf( yytext, "%s", yylval.str );
  return IDENTIFIER;
}
[+-]?[0-9]+ {
  int temp;
  sscanf( yytext, "%d", &temp );
  yylval.val = (int16_t)temp;
  return NUM;
}
%%
