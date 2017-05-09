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
%token SEMI PLUS MINUS AND XOR OR LPAR RPAR LBRACE RBRACE LSHIFT RSHIFT LT LE GT GE EQEQ NEQ INT EQ IF ELSE WHILE
%type <val> NTERM PRI PTERM STERM LGTERM EQEQTERM ATERM XTERM OTERM EXPR SVAR WHILEB IFB STATEMENT STATEMENTS FUNC
%%

FUNC: INT IDENTIFIER LPAR RPAR LBRACE STATEMENTS RBRACE {
  $$ = make_function( $2, $6 );
 }

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
| WHILEB {
  $$ = make_statement( $1, WHILEBL );
  }
| LBRACE STATEMENTS RBRACE {
  $$ = make_statement( $2, BRACE );
 }

IFB : IF LPAR EXPR RPAR STATEMENT ELSE STATEMENT {
  $$ = make_if( $3, $5, $7 );
 }
| IF LPAR EXPR RPAR STATEMENT {
  $$ = make_if( $3, $5 );
 }

WHILEB : WHILE LPAR EXPR RPAR STATEMENT {
  $$ = make_while( $3, $5 );
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

ATERM : EQEQTERM {
  $$ = make_aterm( $1 );
 }
| ATERM AND LGTERM {
  $$ = make_aterm( $1, $3 );
 }

EQEQTERM : LGTERM {
  $$ = make_eqeqterm( $1 );
 }
| EQEQTERM EQEQ LGTERM {
  $$ = make_eqeqterm( $1, $3, TEQEQ );
 }
| EQEQTERM NEQ LGTERM {
  $$ = make_eqeqterm( $1, $3, TNEQ );
 }

LGTERM : STERM {
  $$ = make_lgterm( $1 );
 }
| LGTERM LT STERM {
  $$ = make_lgterm( $1, $3, TLT );
 }
| LGTERM LE STERM {
  $$ = make_lgterm( $1, $3, TLE );
 }
| LGTERM GT STERM {
  $$ = make_lgterm( $1, $3, TGT );
 }
| LGTERM GE STERM {
  $$ = make_lgterm( $1, $3, TGE );
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
