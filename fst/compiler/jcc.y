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
%token SEMI COMMA PLUS MINUS AND XOR OR ASTA LPAR RPAR LBRACE RBRACE LBRACK RBRACK LSHIFT RSHIFT LT LE GT GE EQEQ NEQ INT EQ IF ELSE WHILE FOR IN OUT RETURN CONTINUE BREAK
%type <val> NTERM FUNCALL ARGS PRI MTERM PTERM STERM LGTERM EQEQTERM ATERM XTERM OTERM EXPR SARRAY SVAR RET CON BRE WHILEB FORB FORINIT IFB STATEMENT STATEMENTS FUNC PARAM PARAMS GARRAY GVAR TOP PROGRAM
%%

PROGRAM: TOP {
  $$ = make_program( $1 );
 }
| PROGRAM TOP {
  $$ = make_program( $1, $2 );
 }

TOP: FUNC {
  $$ = make_top( $1, TFUN );
 }
| GVAR {
  $$ = make_top( $1, VAR );
  }

GVAR: INT IDENTIFIER SEMI {
  $$ = make_globalvar( $2, VAR );
 }
| GARRAY {
  $$ = make_globalvar( $1, TARRAY );
  }

GARRAY: INT IDENTIFIER LBRACK NUM RBRACK SEMI {
  $$ = make_globalarray( $2, $4 );
 }

PARAMS: PARAM {
  $$ = make_params( $1 );
 }
| PARAMS COMMA PARAM {
  $$ = make_params( $1, $3 );
 }

PARAM: INT IDENTIFIER {
  $$ = make_param( $2 );
 }

FUNC: INT IDENTIFIER LPAR RPAR LBRACE STATEMENTS RBRACE {
  $$ = make_function( $2, $6 );
 }
| INT IDENTIFIER LPAR PARAMS RPAR LBRACE STATEMENTS RBRACE {
  $$ = make_function( $2, $4, $7 );
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
| FORB {
  $$ = make_statement( $1, FORBL );
  }
| LBRACE STATEMENTS RBRACE {
  $$ = make_statement( $2, BRACE );
 }
| RET {
  $$ = make_statement( $1, TRET );
 }
| CON {
  $$ = make_statement( $1, TCONTINUE );
  }
| BRE {
  $$ = make_statement( $1, TBREAK );
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

FORB : FOR LPAR FORINIT EXPR SEMI EXPR RPAR STATEMENT {
  $$ = make_for( $3, $4, $6, $8 );
 }

FORINIT : SEMI {
  $$ = make_forinit( TNONE );
 }
| EXPR SEMI {
  $$ = make_forinit( $1 , EXP );
 }
| SVAR {
  $$ = make_forinit( $1 , VAR );
  }

RET  : RETURN EXPR SEMI {
  $$ = make_ret( $2 );
}

BRE : BREAK SEMI {
  $$ = make_break();
 }

CON : CONTINUE SEMI {
  $$ = make_continue();
 }

SVAR : INT IDENTIFIER SEMI {
  $$ = make_stackvar( $2, VAR );
 }
| INT IDENTIFIER EQ EXPR SEMI {
  $$ = make_stackvar( $2, $4, VAR );
 }
| SARRAY {
  $$ = make_stackvar( $1, TARRAY );
  }

SARRAY :  INT IDENTIFIER LBRACK NUM RBRACK SEMI {
  $$ = make_stackarray( $2, $4 );
 }

EXPR : OTERM {
  $$ = make_expr( $1 );
 }
| IDENTIFIER EQ EXPR {
  $$ = make_expr( $1, $3 );
 }
| IDENTIFIER LBRACK EXPR RBRACK EQ EXPR {
  $$ = make_expr( $1, $3, $6 );
 }
| ASTA MTERM EQ EXPR {
  $$ = make_expr( $2, $4 );
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
| ATERM AND EQEQTERM {
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
| STERM LSHIFT PTERM {
  $$ = make_sterm( $1, $3, LSFT );
 }
| STERM RSHIFT PTERM {
  $$ = make_sterm( $1, $3, RSFT );
 }

PTERM : MTERM {
  $$ = make_pterm( $1 );
 }
| PTERM PLUS MTERM {
  $$ = make_pterm( $1, $3, PLS );
 }
| PTERM MINUS MTERM {
  $$ = make_pterm( $1, $3, MNS );
 }

MTERM: PRI {
  $$ = make_mterm( $1, TPRI );
 }
| MINUS MTERM {
  $$ = make_mterm( $2, MNS );
 }
| AND IDENTIFIER {
  $$ = make_mterm( $2, TAND );
 }
| ASTA MTERM {
  $$ = make_mterm( $2, TASTA );
 }

PRI : NTERM {
  $$ = make_pri( $1, CST );
 }
| FUNCALL {
  $$ = make_pri( $1, TFC );
  }
| IDENTIFIER LBRACK EXPR RBRACK {
  $$ = make_pri( $1, $3, TARRAY );
  }
| IDENTIFIER {
  $$ = make_pri( $1, VAR );
  }
| LPAR OTERM RPAR {
  $$ = make_pri( $2, OTM );
 }

ARGS : EXPR {
  $$ = make_args( $1 );
}
| ARGS COMMA EXPR {
  $$ = make_args( $1, $3 );
 }

FUNCALL : IDENTIFIER LPAR ARGS RPAR {
  $$ = make_funcall( $1, $3, TFUNC );
 }
| IDENTIFIER LPAR RPAR {
  $$ = make_funcall( $1, TFUNC );
 }
| IN LPAR RPAR {
  $$ = make_funcall( TIN );
 }
| OUT LPAR EXPR COMMA EXPR RPAR {
  $$ = make_funcall( $3, $5, TOUT );
 }

NTERM : NUM {
  $$ = make_num( $1 );
 }
%%

void yyerror( const char *s ){
  extern char *yytext;
  fprintf( stderr, "parser error near %s\n", yytext );
}
