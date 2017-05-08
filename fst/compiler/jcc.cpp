#include <cstdio>
#include <cstdlib>
#include <cassert>
#include <vector>
#include <iostream>
#include <algorithm>
#include "jcc.h"

using namespace std;

extern "C"{
  int yyparse();
}

enum{
  NNODE, PRINODE, SNODE, PNODE, ANODE, XNODE, ONODE
};

struct node{
  int type;
  int val;
  vector<int> ch;
  node(){}
  node( int type, vector<int> ch ) :type(type), ch(ch), val(-1) {}
  node( int type, vector<int> ch, int val ) :type(type), ch(ch), val(val) {}
};

node nodes[100000];
int it;

int make_statement( int ch ){
  fprintf( stderr, "S %d\n" , ch ); 
  nodes[it] = node( SNODE, vector<int>({ch}) );
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

int make_sterm( int chl, int chr, int type ){
  assert( 0 < chr && chr < 16 );
  fprintf( stderr, "S %d %d %d\n", chl, chr, type );
  nodes[it] = node( SNODE, vector<int>({chl,chr}), type );
  return it++;
}

int make_sterm( int ch ){
  fprintf( stderr, "S %d\n", ch );
  nodes[it] = node( SNODE, vector<int>({ch}) );
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

int make_pri( int ch, int type ){
  fprintf( stderr, "PRI %d\n", ch );
  nodes[it] = node( PRINODE, vector<int>({ch}), type );
  return it++;
}

int make_num( int num ){
  fprintf( stderr, "N %d\n" , num );
  nodes[it] = node( NNODE, vector<int>({}), num );
  return it++;
}

void write_statement( int x ){
  assert( nodes[x].type == SNODE );
  write_oterm( nodes[x].ch.at( 0 ) );
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
    write_sterm( nodes[x].ch.at( 0 ) );
  } else {
    write_aterm( nodes[x].ch.at( 0 ) );
    write_sterm( nodes[x].ch.at( 1 ) );
    printf( "LD r1 r7 -1\n" );
    printf( "LD r2 r7 -2\n" );
    printf( "AND r1 r2\n" );
    printf( "ST r1 r7 -2\n" );
    printf( "ADDI r7 -1\n" );
  }
}

void write_sterm( int x ){
  assert( nodes[x].type == SNODE );
  if( nodes[x].ch.size() == 1 ){
    write_pterm( nodes[x].ch.at( 0 ) );
  } else {
    write_sterm( nodes[x].ch.at( 0 ) );
    printf( "LD r1 r7 -1\n" );
    if( nodes[x].type == LSFT ){
      printf( "SLL r1 %d\n", nodes[x].ch.at(1) );
    } else if( nodes[x].type == RSFT ){
      printf( "SRA r1 %d\n", nodes[x].ch.at(1) );
    }
    printf( "ST r1 r7 -1\n" );
  }
}

void write_pterm( int x ){
  assert( nodes[x].type == PNODE );
  if( nodes[x].ch.size() == 1 ){
    write_pri( nodes[x].ch.at( 0 ) );
  } else {
    write_pterm( nodes[x].ch.at( 0 ) );
    write_pri( nodes[x].ch.at( 1 ) );
    printf( "LD r1 r7 -1\n" );
    printf( "LD r2 r7 -2\n" );
    if( nodes[x].val == PLS ){
      printf( "ADD r1 r2\n" );
    } else if( nodes[x].val == MNS ){
      printf( "SUB r1 r2\n" );
    }
    printf( "ST r1 r7 -2\n" );
    printf( "ADDI r7 -1\n" );
  }
}

void write_pri( int x ){
  assert( nodes[x].type == PRINODE );
  if( nodes[x].val == CST ){
    write_num( nodes[x].ch.at( 0 ) );
  } else if( nodes[x].val == OTM ){
    write_oterm( nodes[x].ch.at( 0 ) );
  }
}

void write_num( int x ){
  assert( nodes[x].type == NNODE );
  int a = nodes[x].val;
  if( a < 0 ){
    a = ( 1 << 16 ) + a;
  }
  assert( a >= 0 );
  vector<int> v(0);
  while( a > 0 ){
    v.push_back( a % 16 );
    a /= 16;
  }
  reverse( v.begin(), v.end() );
  bool f = false;
  for( int b : v ){
    if( !f ){
      f = true;
      printf( "LI r1 %d\n" , b );
    } else {
      printf( "SLL r1 4\n" );
      printf( "ADDI r1 %d\n" , b );
    }
  }
  printf( "ST r1 r7 0\n" );
  printf( "ADDI r7 1\n" );
}


int main(){
  extern FILE *yyin;
  yyin = stdin;
  yyparse();
  write_statement( it - 1 );
  printf( "HLT\n" );
  return 0;
}
