#include <string>

#define PLS 1
#define MNS 2

#define CST 3
#define OTM 4

#define LSFT 5
#define RSFT 6

#define EXP 7
#define VDEF 8

#define VAR 9

#define IFBL 10

#define BRACE 11

#define WHILEBL 12

#define TLT 13
#define TLE 14
#define TGT 15
#define TGE 16

#define TEQEQ 17
#define TNEQ 18

#define TRET 19

#define TFC 20

#define TARRAY 21

#define TPRI 22

#define TIN 23
#define TOUT 24

#define TFUNC 25

#define TFUN 26

#define TBREAK 27
#define TCONTINUE 28

#define FORBL 29

#define TNONE 30

#define TAND 31
#define TASTA 32

void yyerror( const char *s );

int make_program( int chl, int chr );
int make_program( int ch );
int make_top( int ch, int type );
int make_globalvar( char *str, int type );
int make_globalvar( int ch, int type );
int make_globalarray( char *str, int num );
int make_params( int chl, int chr );
int make_params( int ch );
int make_param( char *str );
int make_function( char *str, int ch );
int make_function( char *str, int chl, int chr );
int make_statements( int chl, int chr );
int make_statements( int ch );
int make_statement( int ch, int type );
int make_if( int chl, int chr );
int make_if( int chexp, int cha, int chb );
int make_while( int chl, int chr );
int make_for( int cha, int chb, int chc, int chd );
int make_forinit( int type );
int make_forinit( int ch, int type );
int make_ret( int ch );
int make_break();
int make_continue();
int make_stackvar( char *str, int type );
int make_stackvar( char *str, int ch, int type );
int make_stackvar( int ch, int type );
int make_stackarray( char *str, int num );
int make_expr( char *str, int chl, int chr );
int make_expr( char *str, int ch );
int make_expr( int chl, int chr );
int make_expr( int ch );
int make_oterm( int chl, int chr );
int make_oterm( int ch );
int make_xterm( int chl, int chr );
int make_xterm( int ch );
int make_aterm( int chl, int chr );
int make_aterm( int ch );
int make_eqeqterm( int chl, int num, int type );
int make_eqeqterm( int ch );
int make_lgterm( int chl, int num, int type );
int make_lgterm( int ch );
int make_sterm( int chl, int chr, int type );
int make_sterm( int ch );
int make_pterm( int chl, int chr, int type );
int make_pterm( int ch );
int make_mterm( int ch, int type );
int make_mterm( char *str, int type );
int make_pri( int ch, int type );
int make_pri( char *str, int type );
int make_pri( char *str, int ch, int type );
int make_args( int ch );
int make_args( int chl, int chr );
int make_funcall( char *str, int type );
int make_funcall( char *str, int ch, int type );
int make_funcall( int type );
int make_funcall( int chl, int chr, int type );
int make_num( int num );

void write_program( int x );
void write_params( int x );
void write_top( int x );
void write_globalvar( int x );
void write_globalarray( int x );
void write_param( int x );
void write_function( int x );
void write_statements( int x );
void write_statement( int x );
void write_if( int x );
void write_while( int x );
void write_for( int x );
void write_forinit( int x );
void write_ret( int x );
void write_break( int x );
void write_continue( int x );
void write_stackvar( int x );
void write_stackarray( int x );
void write_expr( int x );
void write_oterm( int x );
void write_xterm( int x );
void write_aterm( int x );
void write_eqeqterm( int x );
void write_lgterm( int x );
void write_sterm( int x );
void write_pterm( int x );
void write_mterm( int x );
void write_pri( int x );
void write_args( int x );
void write_funcall( int x );
void write_num( int x );

void load_num( int r , int a );
void load_adr( int r , std::string &s );
void load_label( int r , std::string label );

void check_name( std::string &s );

void vstack_add( std::string &s );
void vstack_push();
void vstack_pop( int r );

void call_func( std::string s, int ra, int rb );
 
