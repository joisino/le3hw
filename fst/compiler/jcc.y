%{
#include <stdio.h>
#include <stdlib.h>
#include <vector>
#include "lex.h"
#include "jcc.h"
%}
%union {
  int val;
  char str[256];
 }
%token <val> NUM
%token <str> IDENTIFIER
%token SEMI PLUS MINUS AND XOR OR LPAR RPAR LSHIFT RSHIFT INT EQ IF
%type <val> NTERM PRI PTERM STERM ATERM XTERM OTERM EXPR SVAR IFB STATEMENT STATEMENTS
%%

STATEMENTS : STATEMENT {
  $$ = make_statements( $1 );
 }
| STATEMENTS STATEMENT {
  $$ = make_statements( $1, $2 );
 }

STATEMENT : EXPR SEMI {
  $$ = make_statement( $1, EXP );
 }
| SVAR {
  $$ = make_statement( $1, VDEF );
  }
| IFB {
  $$ = make_statement( $1, IFBL );
  }

IFB : IF LPAR EXPR RPAR STATEMENT {
  $$ = make_if( $3, $5 );
 }

SVAR : INT IDENTIFIER SEMI {
  $$ = make_stackvar( $2 );
 }

EXPR : OTERM {
  $$ = make_expr( $1 );
 }
| IDENTIFIER EQ EXPR {
  $$ = make_expr( $1, $3 );
 }

OTERM : XTERM {
  $$ = make_oterm( $1 );
 }
| OTERM OR XTERM {
  $$ = make_oterm( $1, $3 );
 }

XTERM : ATERM {
  $$ = make_xterm( $1 );
 }
| XTERM XOR ATERM {
  $$ = make_xterm( $1, $3 );
 }

ATERM : STERM {
  $$ = make_aterm( $1 );
 }
| ATERM AND STERM {
  $$ = make_aterm( $1, $3 );
 }

STERM : PTERM {
  $$ = make_sterm( $1 );
 }
| STERM LSHIFT NUM {
  $$ = make_sterm( $1, $3, LSFT );
 }
| STERM RSHIFT NUM {
  $$ = make_sterm( $1, $3, RSFT );
 }

PTERM : PRI {
  $$ = make_pterm( $1 );
 }
| PTERM PLUS PRI {
  $$ = make_pterm( $1, $3, PLS );
 }
| PTERM MINUS PRI {
  $$ = make_pterm( $1, $3, MNS );
 }

PRI : NTERM {
  $$ = make_pri( $1, CST );
 }
| IDENTIFIER {
  $$ = make_pri( $1, VAR );
  }
| LPAR OTERM RPAR {
  $$ = make_pri( $2, OTM );
 }

NTERM : NUM {
  $$ = make_num( $1 );
 }
%%

void yyerror( const char *s ){
  extern char *yytext;
  fprintf( stderr, "parser error near %s\n", yytext );
}
