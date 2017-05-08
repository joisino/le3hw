
#define PLS 1
#define MNS 2

#define CST 3
#define OTM 4

#define LSFT 5
#define RSFT 6

void yyerror( const char *s );

int make_statements( int chl, int chr );
int make_statements( int ch );
int make_statement( int ch );
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
int make_num( int num );

void write_statements( int x );
void write_statement( int x );
void write_oterm( int x );
void write_xterm( int x );
void write_aterm( int x );
void write_sterm( int x );
void write_pterm( int x );
void write_pri( int x );
void write_num( int x );
