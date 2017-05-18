#include <cstdio>
#include <cstdlib>
#include <cassert>
#include <vector>
#include <iostream>
#include <algorithm>
#include <string>
#include <stack>
#include <map>
#include <set>
#include "jcc.h"

using namespace std;

extern "C"{
  int yyparse();
}

enum{
  NNODE, FCNODE, ARGNODE, PRINODE, MNODE, SHNODE, PNODE, LGNODE, EQEQNODE, ANODE, XNODE, ONODE, ENODE, ARRAYNODE, VNODE, BNODE, CNODE, RNODE, WNODE, FORNODE, FORINITNODE, INODE, SNODE, SSNODE, FNODE, PARAMNODE, PARAMSNODE, GARRAYNODE, GVARNODE, TNODE, PROGNODE
};

struct node{
  int type;
  int val;
  string str;
  vector<int> ch;
  node(){}
  node( int type, vector<int> ch ) :type(type), ch(ch), val(-1), str("") {}
  node( int type, vector<int> ch, int val ) :type(type), ch(ch), val(val), str("") {}
  node( int type, vector<int> ch, string str ) :type(type), ch(ch), val(-1), str(str) {}
  node( int type, vector<int> ch, int val ,string str ) :type(type), ch(ch), val(val), str(str) {}
};

node nodes[1000000];
int it;

int labelcnt;

int paramcnt, argcnt;

int svcnt = 0;
stack<vector<string> > vstack;
stack<int> svcntstack;
map<string,int> stackvars;

int gvcnt = 0;
map<string,int> globalvars;

set<string> funcs;
map<string,int> arity;

vector<string> initial_ops;

stack<string> breaklabel;
stack<string> continuelabel;

int make_program( int chl, int chr ){
  fprintf( stderr, "PROG %d %d\n", chl, chr ); 
  nodes[it] = node( PROGNODE, vector<int>({chl,chr}) );
  return it++;
}

int make_program( int ch ){
  fprintf( stderr, "PROG %d\n", ch ); 
  nodes[it] = node( PROGNODE, vector<int>({ch}) );
  return it++;
}

int make_top( int ch, int type ){
  fprintf( stderr, "TOP %d %d\n", ch, type ); 
  nodes[it] = node( TNODE, vector<int>({ch}), type );
  return it++;
}

int make_globalvar( char *str, int type ){
  fprintf( stderr, "GVAR %s %d\n", str , type ); 
  nodes[it] = node( GVARNODE, vector<int>({}), type, string(str) );
  return it++;
}

int make_globalvar( int ch, int type ){
  fprintf( stderr, "GVAR %d %d\n", ch, type ); 
  nodes[it] = node( GVARNODE, vector<int>({ch}), type );
  return it++;
}

int make_globalarray( char *str, int num ){
  fprintf( stderr, "GVAR %s %d\n", str , num ); 
  nodes[it] = node( GARRAYNODE, vector<int>({}), num, string(str) );
  return it++;
}

int make_params( int chl, int chr ){
  fprintf( stderr, "PARAMS %d %d\n", chl, chr ); 
  nodes[it] = node( PARAMSNODE, vector<int>({chl,chr}) );
  return it++;
}

int make_params( int ch ){
  fprintf( stderr, "PARAMS %d\n", ch ); 
  nodes[it] = node( PARAMSNODE, vector<int>({ch}) );
  return it++;
}

int make_param( char *str ){
  fprintf( stderr, "PARAM %s\n", str ); 
  nodes[it] = node( PARAMNODE, vector<int>({}), string(str) );
  return it++;
}

int make_function( char *str, int ch ){
  fprintf( stderr, "F %s %d\n", str, ch ); 
  nodes[it] = node( FNODE, vector<int>({ch}), string(str) );
  return it++;
}

int make_function( char *str, int chl, int chr ){
  fprintf( stderr, "F %s %d %d\n", str, chl, chr ); 
  nodes[it] = node( FNODE, vector<int>({chl,chr}), string(str) );
  return it++;
}

int make_statements( int chl, int chr ){
  fprintf( stderr, "SS %d %d\n", chl, chr ); 
  nodes[it] = node( SSNODE, vector<int>({chl,chr}) );
  return it++;
}

int make_statements( int ch ){
  fprintf( stderr, "SS %d\n", ch ); 
  nodes[it] = node( SSNODE, vector<int>({ch}) );
  return it++;
}

int make_statement( int ch, int type ){
  fprintf( stderr, "S %d\n", ch ); 
  nodes[it] = node( SNODE, vector<int>({ch}), type );
  return it++;
}

int make_if( int chexp, int cha, int chb ){
  fprintf( stderr, "I %d %d %d\n", chexp, cha, chb ); 
  nodes[it] = node( INODE, vector<int>({chexp,cha,chb}) );
  return it++;
}

int make_if( int chl, int chr ){
  fprintf( stderr, "I %d %d\n", chl, chr ); 
  nodes[it] = node( INODE, vector<int>({chl,chr}) );
  return it++;
}

int make_while( int chl, int chr ){
  fprintf( stderr, "W %d %d\n", chl, chr ); 
  nodes[it] = node( WNODE, vector<int>({chl,chr}) );
  return it++;
}

int make_for( int cha, int chb, int chc, int chd ){
  fprintf( stderr, "F %d %d %d %d\n", cha, chb, chc, chd ); 
  nodes[it] = node( FORNODE, vector<int>({cha,chb,chc,chd}) );
  return it++;
}

int make_forinit( int ch, int type ){
  fprintf( stderr, "FI %d %d\n", ch, type );
  nodes[it] = node( FORINITNODE, vector<int>({ch}), type );
  return it++;
}

int make_forinit( int type ){
  fprintf( stderr, "FI %d\n", type );
  nodes[it] = node( FORINITNODE, vector<int>({}), type );
  return it++;
}

int make_ret( int ch ){
  fprintf( stderr, "R %d\n", ch ); 
  nodes[it] = node( RNODE, vector<int>({ch}) );
  return it++;
}

int make_break(){
  fprintf( stderr, "B\n" ); 
  nodes[it] = node( BNODE, vector<int>({}) );
  return it++;
}

int make_continue(){
  fprintf( stderr, "C\n" ); 
  nodes[it] = node( CNODE, vector<int>({}) );
  return it++;
}

int make_stackvar( char *str, int type ){
  fprintf( stderr, "V %s %d\n", str, type ); 
  nodes[it] = node( VNODE, vector<int>({}), type, string(str) );
  return it++;
}

int make_stackvar( char *str, int ch, int type ){
  fprintf( stderr, "V %s %d %d\n", str, ch, type ); 
  nodes[it] = node( VNODE, vector<int>({ch}), type, string(str) );
  return it++;
}

int make_stackvar( int ch, int type ){
  fprintf( stderr, "V %d %d\n", ch, type ); 
  nodes[it] = node( VNODE, vector<int>({ch}), type );
  return it++;
}

int make_stackarray( char *str, int num ){
  assert( num > 0 );
  fprintf( stderr, "ARRAY %s %d\n", str, num ); 
  nodes[it] = node( ARRAYNODE, vector<int>({}), num, string(str) );
  return it++;
}

int make_expr( char *str, int chl, int chr ){
  fprintf( stderr, "E %s %d %d\n", str, chl, chr );
  nodes[it] = node( ENODE, vector<int>({chl,chr}), string(str) );
  return it++;
}

int make_expr( char *str, int ch ){
  fprintf( stderr, "E %s %d\n", str, ch );
  nodes[it] = node( ENODE, vector<int>({ch}), string(str) );
  return it++;
}

int make_expr( int chl, int chr ){
  fprintf( stderr, "E %d %d\n", chl, chr );
  nodes[it] = node( ENODE, vector<int>({chl,chr}) );
  return it++;
}

int make_expr( int ch ){
  fprintf( stderr, "E %d\n", ch );
  nodes[it] = node( ENODE, vector<int>({ch}) );
  return it++;
}

int make_oterm( int chl, int chr ){
  fprintf( stderr, "O %d %d\n", chl, chr );
  nodes[it] = node( ONODE, vector<int>({chl,chr}) );
  return it++;
}

int make_oterm( int ch ){
  fprintf( stderr, "O %d\n", ch );
  nodes[it] = node( ONODE, vector<int>({ch}) );
  return it++;
}

int make_xterm( int chl, int chr ){
  fprintf( stderr, "X %d %d\n", chl, chr );
  nodes[it] = node( XNODE, vector<int>({chl,chr}) );
  return it++;
}

int make_xterm( int ch ){
  fprintf( stderr, "X %d\n", ch );
  nodes[it] = node( XNODE, vector<int>({ch}) );
  return it++;
}

int make_aterm( int chl, int chr ){
  fprintf( stderr, "A %d %d\n", chl, chr );
  nodes[it] = node( ANODE, vector<int>({chl,chr}) );
  return it++;
}

int make_aterm( int ch ){
  fprintf( stderr, "A %d\n", ch );
  nodes[it] = node( ANODE, vector<int>({ch}) );
  return it++;
}

int make_eqeqterm( int chl, int chr, int type ){
  fprintf( stderr, "EQEQ %d %d %d\n", chl, chr, type );
  nodes[it] = node( EQEQNODE, vector<int>({chl,chr}), type );
  return it++;
}

int make_eqeqterm( int ch ){
  fprintf( stderr, "EQEQ %d\n", ch );
  nodes[it] = node( EQEQNODE, vector<int>({ch}) );
  return it++;
}

int make_lgterm( int chl, int chr, int type ){
  fprintf( stderr, "LG %d %d %d\n", chl, chr, type );
  nodes[it] = node( LGNODE, vector<int>({chl,chr}), type );
  return it++;
}

int make_lgterm( int ch ){
  fprintf( stderr, "LG %d\n", ch );
  nodes[it] = node( LGNODE, vector<int>({ch}) );
  return it++;
}

int make_sterm( int chl, int chr, int type ){
  fprintf( stderr, "S %d %d %d\n", chl, chr, type );
  nodes[it] = node( SHNODE, vector<int>({chl,chr}), type );
  return it++;
}

int make_sterm( int ch ){
  fprintf( stderr, "S %d\n", ch );
  nodes[it] = node( SHNODE, vector<int>({ch}) );
  return it++;
}

int make_pterm( int chl, int chr, int type ){
  fprintf( stderr, "P %d %d %d\n", chl, chr, type );
  nodes[it] = node( PNODE, vector<int>({chl,chr}), type );
  return it++;
}

int make_pterm( int ch ){
  fprintf( stderr, "P %d\n", ch );
  nodes[it] = node( PNODE, vector<int>({ch}) );
  return it++;
}

int make_mterm( int ch, int type ){
  fprintf( stderr, "M %d %d\n", ch, type );
  nodes[it] = node( MNODE, vector<int>({ch}), type );
  return it++;
}

int make_mterm( char *str, int type ){
  fprintf( stderr, "M %s %d\n", str, type );
  nodes[it] = node( MNODE, vector<int>({}), type, string(str) );
  return it++;
}

int make_pri( int ch, int type ){
  fprintf( stderr, "PRI %d\n", ch );
  nodes[it] = node( PRINODE, vector<int>({ch}), type );
  return it++;
}

int make_pri( char *str, int type ){
  fprintf( stderr, "PRI %s\n", str );
  nodes[it] = node( PRINODE, vector<int>({}), type, string(str) );
  return it++;
}

int make_pri( char *str, int ch, int type ){
  fprintf( stderr, "PRI %s %d\n", str, ch );
  nodes[it] = node( PRINODE, vector<int>({ch}), type, string(str) );
  return it++;
}

int make_args( int chl, int chr ){
  fprintf( stderr, "ARG %d %d\n", chl, chr );
  nodes[it] = node( ARGNODE, vector<int>({chl,chr}) );
  return it++;
}

int make_args( int ch ){
  fprintf( stderr, "ARG %d\n", ch );
  nodes[it] = node( ARGNODE, vector<int>({ch}) );
  return it++;
}

int make_funcall( char *str, int type ){
  fprintf( stderr, "FC %s %d\n", str, type );
  nodes[it] = node( FCNODE, vector<int>({}), type, string(str) );
  return it++;
}

int make_funcall( char *str, int ch, int type ){
  fprintf( stderr, "FC %s %d %d\n", str, ch, type );
  nodes[it] = node( FCNODE, vector<int>({ch}), type, string(str) );
  return it++;
}

int make_funcall( int type ){
  fprintf( stderr, "FC %d\n", type );
  nodes[it] = node( FCNODE, vector<int>({}), type );
  return it++;
}

int make_funcall( int chl, int chr, int type ){
  fprintf( stderr, "FC %d %d %d\n", chl, chr, type );
  nodes[it] = node( FCNODE, vector<int>({chl,chr}), type );
  return it++;
}

int make_num( int num ){
  fprintf( stderr, "N %d\n" , num );
  nodes[it] = node( NNODE, vector<int>({}), num );
  return it++;
}

void write_program( int x ){
  assert( nodes[x].type == PROGNODE );
  if( nodes[x].ch.size() == 1 ){
    write_top( nodes[x].ch.at( 0 ) );
  } else if( nodes[x].ch.size() == 2 ){
    write_program( nodes[x].ch.at( 0 ) );
    write_top( nodes[x].ch.at( 1 ) );
  } else {
    assert( false );
  }
}

void write_top( int x ){
  assert( nodes[x].type == TNODE );
  if( nodes[x].val == TFUN ){
    write_function( nodes[x].ch.at(0) );
  } else if( nodes[x].val == VAR ){
    write_globalvar( nodes[x].ch.at(0) );
  } else {
    assert( false );
  }
}
void write_globalvar( int x ){
  assert( nodes[x].type == GVARNODE );
  if( nodes[x].val == VAR ){
    if( nodes[x].ch.size() == 0 ){
      check_name( nodes[x].str );
      globalvars[ nodes[x].str ] = gvcnt++;
      printf( "ADDI r7 1\n" );
    } else {
      assert( false );
    }
  } else if( nodes[x].val == TARRAY ){
    write_globalarray( nodes[x].ch.at( 0 ) );
  } else {
    assert( false );
  }
}

void write_globalarray( int x ){
  assert( nodes[x].type == GARRAYNODE );
  check_name( nodes[x].str );
  globalvars[ nodes[x].str ] = gvcnt++;
  load_num( 1 , gvcnt );
  printf( "ST r1 r7 0\n" );
  load_num( 1 , nodes[x].val + 1 );
  printf( "ADD r7 r1\n" );
  gvcnt += nodes[x].val;
}

void write_params( int x ){
  assert( nodes[x].type == PARAMSNODE );
  paramcnt++;
  if( nodes[x].ch.size() == 1 ){
    write_param( nodes[x].ch.at( 0 ) );
  } else {
    write_params( nodes[x].ch.at( 0 ) );
    write_param( nodes[x].ch.at( 1 ) );
  }
}

void write_param( int x ){
  assert( nodes[x].type == PARAMNODE );
  check_name( nodes[x].str );
  vstack_add( nodes[x].str );
}

void write_function( int x ){
  assert( nodes[x].type == FNODE );
  check_name( nodes[x].str );
  funcs.insert( nodes[x].str );
  load_label( 1 , nodes[x].str + "_end" );
  printf( "BR r1\n" );
  printf( "%s:\n", nodes[x].str.c_str() );
  for( int i = 0; i < 7; i++ ){
    printf( "ST r%d r7 %d\n", i , i );
  }
  printf( "MOV r6 r7\n" );
  printf( "ADDI r7 7\n" );
  assert( svcnt == 0 );
  svcnt = 7;
  vstack_push();
  if( nodes[x].ch.size() == 1 ){
    arity[ nodes[x].str ] = 0;
    write_statements( nodes[x].ch.at( 0 ) );
  } else if( nodes[x].ch.size() == 2 ){
    paramcnt = 0;
    write_params( nodes[x].ch.at( 0 ) );
    arity[ nodes[x].str ] = paramcnt;
    write_statements( nodes[x].ch.at( 1 ) );
  }
  vstack_pop( 1 );
  svcnt -= 7;
  assert( svcnt == 0 );  
  printf( "ADDI r7 -7\n" );
  for( int i = 0; i < 7; i++ ){
    printf( "LD r%d r7 %d\n", i , i );
  }
  printf( "BR r0\n" );
  printf( "%s_end:\n", nodes[x].str.c_str() );
}

void write_statements( int x ){
  assert( nodes[x].type == SSNODE );
  if( nodes[x].ch.size() == 1 ){
    write_statement( nodes[x].ch.at( 0 ) );
  } else {
    write_statements( nodes[x].ch.at( 0 ) );
    write_statement( nodes[x].ch.at( 1 ) );
  }
}

void write_statement( int x ){
  assert( nodes[x].type == SNODE );
  if( nodes[x].val == EXP ){
    write_expr( nodes[x].ch.at( 0 ) );
    printf( "ADDI r7 -1\n" );
  } else if( nodes[x].val == IFBL ){
    write_if( nodes[x].ch.at( 0 ) );
  } else if( nodes[x].val == WHILEBL ){
    write_while( nodes[x].ch.at( 0 ) );
  } else if( nodes[x].val == FORBL ){
    write_for( nodes[x].ch.at( 0 ) );
  } else if( nodes[x].val == VDEF ){
    write_stackvar( nodes[x].ch.at( 0 ) );
  } else if( nodes[x].val == BRACE ){
    write_statements( nodes[x].ch.at( 0 ) );
  } else if( nodes[x].val == TRET ){
    write_ret( nodes[x].ch.at( 0 ) );
  } else if( nodes[x].val == TBREAK ){
    write_break( nodes[x].ch.at( 0 ) );
  } else if( nodes[x].val == TCONTINUE ){
    write_continue( nodes[x].ch.at( 0 ) );
  } else {
    assert( false );
  }
}

void write_while( int x ){
  assert( nodes[x].type == WNODE );
  int la = labelcnt++;
  int lb = labelcnt++;
  int lc = labelcnt++;
  continuelabel.push( "L" + to_string( la ) );
  breaklabel.push( "L" + to_string( lc ) );
  printf( "L%d:\n", la );  
  write_expr( nodes[x].ch.at( 0 ) );
  printf( "LD r1 r7 -1\n" );
  printf( "ADDI r7 -1\n" );
  printf( "CMPI r1 0\n" );
  printf( "BNE L%d\n" , lb );
  load_label( 1 , "L" + to_string( lc ) );
  printf( "BR r1\n" );
  printf( "L%d:\n", lb );
  vstack_push();
  write_statement( nodes[x].ch.at( 1 ) );
  vstack_pop( 1 );
  load_label( 1 , "L" + to_string( la ) );
  printf( "BR r1\n" );
  printf( "L%d:\n", lc );
  continuelabel.pop();
  breaklabel.pop();
}

void write_for( int x ){
  assert( nodes[x].type == FORNODE );
  int la = labelcnt++;
  int lb = labelcnt++;
  int lc = labelcnt++;
  continuelabel.push( "L" + to_string( la ) );
  breaklabel.push( "L" + to_string( lc ) );
  vstack_push();
  write_forinit( nodes[x].ch.at( 0 ) );
  printf( "L%d:\n", la );  
  write_expr( nodes[x].ch.at( 1 ) );
  printf( "LD r1 r7 -1\n" );
  printf( "ADDI r7 -1\n" );
  printf( "CMPI r1 0\n" );
  printf( "BNE L%d\n" , lb );
  load_label( 1 , "L" + to_string( lc ) );
  printf( "BR r1\n" );
  printf( "L%d:\n", lb );
  write_statement( nodes[x].ch.at( 3 ) );
  write_expr( nodes[x].ch.at( 2 ) );
  printf( "ADDI r7 -1\n" );
  load_label( 1 , "L" + to_string( la ) );
  printf( "BR r1\n" );
  printf( "L%d:\n", lc );
  vstack_pop( 1 );
  continuelabel.pop();
  breaklabel.pop();
}

void write_forinit( int x ){
  assert( nodes[x].type == FORINITNODE );
  if( nodes[x].ch.size() == 0 ){
    assert( nodes[x].val == TNONE );
  } else if( nodes[x].ch.size() == 1 ){
    if( nodes[x].val == EXP ){
      write_expr( nodes[x].ch.at(0) );
      printf( "ADDI r7 -1\n" );
    } else if( nodes[x].val == VAR ){
      write_stackvar( nodes[x].ch.at(0) );
    } else {
      assert( false );
    }
  } else {
    assert( false );
  }
}

void write_if( int x ){
  assert( nodes[x].type == INODE );
  if( nodes[x].ch.size() == 2 ){
    write_expr( nodes[x].ch.at( 0 ) );
    int la = labelcnt++;
    int lb = labelcnt++;
    printf( "LD r1 r7 -1\n" );
    printf( "ADDI r7 -1\n" );    
    printf( "CMPI r1 0\n" );
    printf( "BNE L%d\n" , la );
    load_label( 1 , "L" + to_string( lb ) );
    printf( "BR r1\n" );
    printf( "L%d:\n", la );
    write_statement( nodes[x].ch.at( 1 ) );
    printf( "L%d:\n", lb );
  } else if( nodes[x].ch.size() == 3 ){
    write_expr( nodes[x].ch.at( 0 ) );
    int la = labelcnt++;
    int lb = labelcnt++;
    int lc = labelcnt++;
    printf( "LD r1 r7 -1\n" );
    printf( "CMPI r1 0\n" );
    printf( "BNE L%d\n" , la );
    load_label( 1 , "L" + to_string( lb ) );
    printf( "BR r1\n" );
    printf( "L%d:\n", la );
    write_statement( nodes[x].ch.at( 1 ) );
    load_label( 1 , "L" + to_string( lc ) );
    printf( "BR r1\n" );
    printf( "L%d:\n", lb );
    write_statement( nodes[x].ch.at( 2 ) );
    printf( "L%d:\n", lc );
  }
}

void write_ret( int x ){
  assert( nodes[x].type == RNODE );
  write_expr( nodes[x].ch.at( 0 ) );
  printf( "LD r2 r7 -1\n" );
  load_num( 1, svcnt );
  printf( "SUB r7 r1\n" );
  printf( "LD r0 r7 -1\n" );
  printf( "ST r2 r7 -1\n" );  
  for( int i = 1; i < 7; i++ ){
    printf( "LD r%d r7 %d\n", i , i-1 );
  }
  printf( "BR r0\n" );  
}

void write_break( int x ){
  assert( nodes[x].type == BNODE );
  assert( !breaklabel.empty() );
  load_label( 1 , breaklabel.top() );
  printf( "BR r1\n" );  
}

void write_continue( int x ){
  assert( nodes[x].type == CNODE );
  assert( !continuelabel.empty() );
  load_label( 1 , continuelabel.top() );
  printf( "BR r1\n" );  
}

void write_stackvar( int x ){
  assert( nodes[x].type == VNODE );
  if( nodes[x].val == VAR ){
    if( nodes[x].ch.size() == 0 ){
      check_name( nodes[x].str );
      vstack_add( nodes[x].str );
    } else if( nodes[x].ch.size() == 1 ){
      write_expr( nodes[x].ch.at( 0 ) );
      check_name( nodes[x].str );
      stackvars[ nodes[x].str ] = svcnt++;
      vstack.top().push_back( nodes[x].str );
    } else {
      assert( false );
    }
  } else if( nodes[x].val == TARRAY ){
    write_stackarray( nodes[x].ch.at( 0 ) );
  } else {
    assert( false );
  }
}

void write_stackarray( int x ){
  assert( nodes[x].type == ARRAYNODE );
  check_name( nodes[x].str );
  vstack_add( nodes[x].str );
  load_num( 1 , svcnt );
  printf( "ADD r1 r6\n" );
  printf( "ST r1 r7 -1\n" );
  load_num( 1 , nodes[x].val );
  printf( "ADD r7 r1\n" );
  svcnt += nodes[x].val;
}

void write_expr( int x ){
  assert( nodes[x].type == ENODE );
  if( nodes[x].str.size() == 0 ){
    if( nodes[x].ch.size() == 1 ){
      write_oterm( nodes[x].ch.at( 0 ) );
    } else if( nodes[x].ch.size() == 2 ){
      write_expr( nodes[x].ch.at( 1 ) );
      write_mterm( nodes[x].ch.at( 0 ) );
      printf( "LD r1 r7 -2\n" );
      printf( "LD r2 r7 -1\n" );
      printf( "ST r1 r2 0\n" );
      printf( "ADDI r7 -1\n" );
    } else {
      assert( false );
    }
  } else if( nodes[x].ch.size() == 1 ){
    write_expr( nodes[x].ch.at( 0 ) );
    load_adr( 1, nodes[x].str );
    printf( "LD r2 r7 -1\n" );
    printf( "ST r2 r1 0\n" );
  } else if( nodes[x].ch.size() == 2 ){
    write_expr( nodes[x].ch.at( 1 ) );
    write_expr( nodes[x].ch.at( 0 ) );
    printf( "ADDI r7 -1\n" );
    printf( "LD r2 r7 0\n" );
    load_adr( 1, nodes[x].str );
    printf( "LD r1 r1 0\n" );
    printf( "ADD r1 r2\n" );
    printf( "LD r2 r7 -1\n" );
    printf( "ST r2 r1 0\n" );
  } else {
    assert( false );
  }
}

void write_oterm( int x ){
  assert( nodes[x].type == ONODE );
  if( nodes[x].ch.size() == 1 ){
    write_xterm( nodes[x].ch.at( 0 ) );
  } else {
    write_oterm( nodes[x].ch.at( 0 ) );
    write_xterm( nodes[x].ch.at( 1 ) );
    printf( "LD r1 r7 -1\n" );
    printf( "LD r2 r7 -2\n" );
    printf( "OR r1 r2\n" );
    printf( "ST r1 r7 -2\n" );
    printf( "ADDI r7 -1\n" );
  }
}

void write_xterm( int x ){
  assert( nodes[x].type == XNODE );
  if( nodes[x].ch.size() == 1 ){
    write_aterm( nodes[x].ch.at( 0 ) );
  } else {
    write_xterm( nodes[x].ch.at( 0 ) );
    write_aterm( nodes[x].ch.at( 1 ) );
    printf( "LD r1 r7 -1\n" );
    printf( "LD r2 r7 -2\n" );
    printf( "XOR r1 r2\n" );
    printf( "ST r1 r7 -2\n" );
    printf( "ADDI r7 -1\n" );
  }
}

void write_aterm( int x ){
  assert( nodes[x].type == ANODE );
  if( nodes[x].ch.size() == 1 ){
    write_eqeqterm( nodes[x].ch.at( 0 ) );
  } else {
    write_aterm( nodes[x].ch.at( 0 ) );
    write_eqeqterm( nodes[x].ch.at( 1 ) );
    printf( "LD r1 r7 -1\n" );
    printf( "LD r2 r7 -2\n" );
    printf( "AND r1 r2\n" );
    printf( "ST r1 r7 -2\n" );
    printf( "ADDI r7 -1\n" );
  }
}

void write_eqeqterm( int x ){
  assert( nodes[x].type == EQEQNODE );
  if( nodes[x].ch.size() == 1 ){
    write_lgterm( nodes[x].ch.at( 0 ) );
  } else {
    write_eqeqterm( nodes[x].ch.at( 0 ) );
    write_lgterm( nodes[x].ch.at( 1 ) );
    printf( "LD r1 r7 -2\n" );
    printf( "LD r2 r7 -1\n" );
    int la = labelcnt++;
    int lb = labelcnt++;
    if( nodes[x].val == TEQEQ ){
      printf( "CMP r1 r2\n" );
      printf( "BE L%d\n", la );
      printf( "LI r1 0\n" );
      printf( "B L%d\n", lb );
      printf( "L%d:\n", la );
      printf( "LI r1 1\n" );
      printf( "L%d:\n", lb );
    } else if( nodes[x].val == TNEQ ){
      printf( "CMP r1 r2\n" );
      printf( "BNE L%d\n", la );
      printf( "LI r1 0\n" );
      printf( "B L%d\n", lb );
      printf( "L%d:\n", la );
      printf( "LI r1 1\n" );
      printf( "L%d:\n", lb );
    }
    printf( "ADDI r7 -1\n" );
    printf( "ST r1 r7 -1\n" );
  }
}

void write_lgterm( int x ){
  assert( nodes[x].type == LGNODE );
  if( nodes[x].ch.size() == 1 ){
    write_sterm( nodes[x].ch.at( 0 ) );
  } else {
    write_lgterm( nodes[x].ch.at( 0 ) );
    write_sterm( nodes[x].ch.at( 1 ) );
    printf( "LD r1 r7 -2\n" );
    printf( "LD r2 r7 -1\n" );
    int la = labelcnt++;
    int lb = labelcnt++;
    if( nodes[x].val == TLT ){
      printf( "CMP r1 r2\n" );
      printf( "BLT L%d\n", la );
      printf( "LI r1 0\n" );
      printf( "B L%d\n", lb );
      printf( "L%d:\n", la );
      printf( "LI r1 1\n" );
      printf( "L%d:\n", lb );
    } else if( nodes[x].val == TLE ){
      printf( "CMP r1 r2\n" );
      printf( "BLE L%d\n", la );
      printf( "LI r1 0\n" );
      printf( "B L%d\n", lb );
      printf( "L%d:\n", la );
      printf( "LI r1 1\n" );
      printf( "L%d:\n", lb );
    } else if( nodes[x].val == TGT ){
      printf( "CMP r1 r2\n" );
      printf( "BLE L%d\n", la );
      printf( "LI r1 1\n" );
      printf( "B L%d\n", lb );
      printf( "L%d:\n", la );
      printf( "LI r1 0\n" );
      printf( "L%d:\n", lb );
    } else if( nodes[x].val == TGE ){
      printf( "CMP r1 r2\n" );
      printf( "BLT L%d\n", la );
      printf( "LI r1 1\n" );
      printf( "B L%d\n", lb );
      printf( "L%d:\n", la );
      printf( "LI r1 0\n" );
      printf( "L%d:\n", lb );
    }
    printf( "ADDI r7 -1\n" );
    printf( "ST r1 r7 -1\n" );
  }
}

void write_sterm( int x ){
  assert( nodes[x].type == SHNODE );
  if( nodes[x].ch.size() == 1 ){
    write_pterm( nodes[x].ch.at( 0 ) );
  } else if( nodes[x].ch.size() == 2 ){
    write_sterm( nodes[x].ch.at( 0 ) );
    write_pterm( nodes[x].ch.at( 1 ) );
    printf( "LD r1 r7 -2\n" );
    printf( "LD r2 r7 -1\n" );
    if( nodes[x].val == LSFT ){
      printf( "SLL r1 r2\n" );
    } else if( nodes[x].val == RSFT ){
      printf( "SRA r1 r2\n" );
    }
    printf( "ST r1 r7 -2\n" );
    printf( "ADDI r7 -1\n" );
  } else {
    assert( false );
  }
}

void write_pterm( int x ){
  assert( nodes[x].type == PNODE );
  if( nodes[x].ch.size() == 1 ){
    write_mterm( nodes[x].ch.at( 0 ) );
  } else {
    write_pterm( nodes[x].ch.at( 0 ) );
    write_mterm( nodes[x].ch.at( 1 ) );
    printf( "LD r1 r7 -2\n" );
    printf( "LD r2 r7 -1\n" );
    if( nodes[x].val == PLS ){
      printf( "ADD r1 r2\n" );
    } else if( nodes[x].val == MNS ){
      printf( "SUB r1 r2\n" );
    }
    printf( "ST r1 r7 -2\n" );
    printf( "ADDI r7 -1\n" );
  }
}

void write_mterm( int x ){
  assert( nodes[x].type == MNODE );
  if( nodes[x].val == TPRI ){
    write_pri( nodes[x].ch.at( 0 ) );
  } else if( nodes[x].val == MNS ){
    write_mterm( nodes[x].ch.at( 0 ) );
    printf( "LI r1 0\n" );
    printf( "LD r2 r7 -1\n" );
    printf( "SUB r1 r2\n" );
    printf( "ST r1 r7 -1\n" );
  } else if( nodes[x].val == TAND ){
    load_adr( 1 , nodes[x].str );
    printf( "ST r1 r7 0\n" );
    printf( "ADDI r7 1\n" );
  } else if( nodes[x].val == TASTA ){
    write_mterm( nodes[x].ch.at( 0 ) );
    printf( "LD r1 r7 -1\n" );
    printf( "LD r2 r1 0\n" );
    printf( "ST r2 r7 -1\n" );
  } else {
    assert( false );
  }
}

void write_pri( int x ){
  assert( nodes[x].type == PRINODE );
  if( nodes[x].val == CST ){
    write_num( nodes[x].ch.at( 0 ) );
  } else if( nodes[x].val == TFC ){
    write_funcall( nodes[x].ch.at( 0 ) );
  } else if( nodes[x].val == TARRAY ){
    write_expr( nodes[x].ch.at( 0 ) );
    printf( "LD r2 r7 -1\n" );
    load_adr( 1, nodes[x].str );
    printf( "LD r1 r1 0\n" );
    printf( "ADD r1 r2\n" );
    printf( "LD r1 r1 0\n" );
    printf( "ST r1 r7 -1\n" );
  } else if( nodes[x].val == VAR ){
    load_adr( 1 , nodes[x].str );
    printf( "LD r2 r1 0\n" );
    printf( "ST r2 r7 0\n" );
    printf( "ADDI r7 1\n" );
  } else if( nodes[x].val == OTM ){
    write_oterm( nodes[x].ch.at( 0 ) );
  } else {
    assert( false );
  }
}

void write_args( int x ){
  assert( nodes[x].type == ARGNODE );
  argcnt++;
  if( nodes[x].ch.size() == 1 ){
    write_expr( nodes[x].ch.at( 0 ) );
  } else if( nodes[x].ch.size() == 2 ){
    write_args( nodes[x].ch.at( 0 ) );
    write_expr( nodes[x].ch.at( 1 ) );
  }
}

void write_funcall( int x ){
  assert( nodes[x].type == FCNODE );
  if( nodes[x].val == TFUNC ){
    if( nodes[x].ch.size() == 0 ){
      assert( funcs.find( nodes[x].str ) != funcs.end() );
      assert( arity[ nodes[x].str ] == 0 );
      call_func( nodes[x].str, 1, 2 );
    } else if( nodes[x].ch.size() == 1 ){
      assert( funcs.find( nodes[x].str ) != funcs.end() );
      printf( "ADDI r7 7\n" );
      argcnt = 0;
      write_args( nodes[x].ch.at( 0 ) );
      assert( arity[ nodes[x].str ] == argcnt );
      load_num( 1 , 7 + argcnt );
      printf( "SUB r7 r1\n" );
      call_func( nodes[x].str, 1, 2 );
    } else {
      assert( false );
    }
  } else if( nodes[x].val == TIN ){
    printf( "IN r1\n" );
    printf( "ST r1 r7 0\n" );
    printf( "ADDI r7 1\n" );
  } else if( nodes[x].val == TOUT ){
    write_expr( nodes[x].ch.at( 1 ) );
    write_expr( nodes[x].ch.at( 0 ) );
    printf( "LD r1 r7 -2\n" );
    printf( "LD r2 r7 -1\n" );
    printf( "OUT r1 r2\n" );
    printf( "ADDI r7 -1\n" );
  } else {
    assert( false );
  }
}

void write_num( int x ){
  assert( nodes[x].type == NNODE );
  load_num( 1, nodes[x].val );
  printf( "ST r1 r7 0\n" );
  printf( "ADDI r7 1\n" );
}

void load_num( int r, int a ){
  if( a < 0 ){
    a = ( 1 << 16 ) + a;
  }
  assert( a >= 0 );
  if( a == 0 ){
    printf( "LI r%d 0\n", r );
    return;
  }
  vector<int> v(0);
  while( a > 0 ){
    v.push_back( a % 64 );
    a /= 64;
  }
  reverse( v.begin(), v.end() );
  bool f = false;
  for( int b : v ){
    if( !f ){
      f = true;
      printf( "LI r%d %d\n", r , b );
    } else {
      printf( "SLL r%d 6\n", r );
      printf( "ADDI r%d %d\n", r, b );
    }
  }
}

void load_adr( int r, string &s ){
  if( globalvars.find( s ) != globalvars.end() ){
    load_num( 1, globalvars[s] );
  } else if( stackvars.find( s ) != stackvars.end() ){
    load_num( 1, stackvars[s] );
    printf( "ADD r1 r6\n" );
  } else {
    printf( "identifier %s NOT FOUND\n", s.c_str() );
    assert( false );
  }
}

void load_label( int r , string label ){
  printf( "LI r%d %s 0\n", r, label.c_str() );
  printf( "SLL r%d 6\n", r );
  printf( "ADDI r%d %s 1\n", r, label.c_str() );
  printf( "SLL r%d 6\n", r );
  printf( "ADDI r%d %s 2\n", r, label.c_str() );
}

void check_name( string &s ){
  if( funcs.find( s ) != funcs.end() || stackvars.find( s ) != stackvars.end() || globalvars.find( s ) != globalvars.end() ){
    printf( "%s is already decleared\n", s.c_str() );
    exit( 1 );
  }
}

void vstack_add( string &s ){
  cerr << "ADD " << s << endl;
  stackvars[s] = svcnt++;
  vstack.top().push_back( s );
  printf( "ADDI r7 1\n" );
}

void vstack_push(){
  vstack.push( vector<string>(0) );
  svcntstack.push( svcnt );
}

void vstack_pop( int r ){
  load_num( r, vstack.top().size() );
  printf( "SUB r7 r%d\n",r );
  while( !vstack.top().empty() ){
    cerr << "DEL " << vstack.top().back() << endl;
    stackvars.erase( stackvars.find( vstack.top().back() ) );
    vstack.top().pop_back();
  }
  svcnt = svcntstack.top();
  svcntstack.pop();
  vstack.pop();
}

void call_func( string s, int ra, int rb ){
  int la = labelcnt++;
  int lb = labelcnt++;
  printf( "LI r%d 0\n", ra );
  printf( "BAL L%d\n", la );
  printf( "L%d:\n", la );
  printf( "CMPI r%d 1\n", ra );
  printf( "BE L%d\n", lb );
  printf( "LI r%d 1\n", ra );
  load_label( rb, s );
  printf( "BR r%d\n", rb );
  printf( "L%d:\n", lb );
}

int main(){
  extern FILE *yyin;
  yyin = stdin;
  yyparse();
  write_program( it - 1 );
  call_func( "main", 1, 2 );
  printf( "HLT\n" );
  return 0;
}
