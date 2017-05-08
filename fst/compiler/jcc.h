
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

void yyerror( const char *s );

int make_statements( int chl, int chr );
int make_statements( int ch );
int make_statement( int ch, int type );
int make_if( int chl, int chr  );
int make_stackvar( char *str );
int make_expr( char *str, int ch );
int make_expr( int ch );
int make_oterm( int chl, int chr );
int make_oterm( int ch );
int make_xterm( int chl, int chr );
int make_xterm( int ch );
int make_aterm( int chl, int chr );
int make_aterm( int ch );
int make_sterm( int chl, int num, int type );
int make_sterm( int ch );
int make_pterm( int chl, int chr, int type );
int make_pterm( int ch );
int make_pri( int ch, int type );
int make_pri( char *str, int type );
int make_num( int num );

void write_statements( int x );
void write_statement( int x );
void write_if( int x );
void write_stackvar( int x );
void write_expr( int x );
void write_oterm( int x );
void write_xterm( int x );
void write_aterm( int x );
void write_sterm( int x );
void write_pterm( int x );
void write_pri( int x );
void write_num( int x );

void load_num( int r , int a );
