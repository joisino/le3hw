%{
#include <stdio.h>
#include <stdlib.h>
#include <vector>
#include "lex.h"
#include "jcc.h"
%}
%union {
  int val;
 }
%token <val> NUM
%token SEMI PLUS MINUS AND XOR OR LPAR RPAR LSHIFT RSHIFT
%type <val> NTERM PRI PTERM STERM ATERM XTERM OTERM STATEMENT STATEMENTS
%%

STATEMENTS : STATEMENT {
  $$ = make_statements( $1 );
 }
| STATEMENTS STATEMENT {
  $$ = make_statements( $1, $2 );
 }

STATEMENT : OTERM SEMI {
  $$ = make_statement( $1 );
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
