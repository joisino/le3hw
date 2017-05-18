int abs( int a ){
  if( a < 0 ){
    return -a;
  }
  return a;
}
int umul( int a , int b ){
  int sgn = 0;
  int res = 0;
  while( b ){
    if( b & 1 ){
      res = res + a;
    }
    a = a + a;
    b = b >> 1;
  }
  return res;
}
int fmul( int a , int b ){
  int sgn = 0;
  if( a < 0 ){
    sgn = 1;
    a = -a;
  }
  if( b < 0 ){
    sgn = 1 - sgn;
    b = -b;
  }
  int la = a & 255;
  int ua = a >> 8;
  int lb = b & 255;
  int ub = b >> 8;
  int x = umul( la , lb );
  int y = umul( la , ub ) + umul( ua , lb );
  int z = umul( ua , ub );
  int res = ( x >> 12 ) + ( y >> 4 ) + ( z << 4 );
  if( sgn ){
    res = -res;
  }
  return res;
}
int isin( int x , int y ){
  int cx = 0;
  int cy = 0;
  int i = 0;
  while( i < 32 ){
    int nx = fmul( cx , cx ) - fmul( cy , cy ) + x;
    int ny = ( fmul( cx , cy ) << 1 ) + y;
    cx = nx;
    cy = ny;
    if( abs( cx ) > ( 2 << 12 ) ){
      return 1;
    }
    if( abs( cy ) > ( 2 << 12 ) ){
      return 1;
    }
    i = i + 1;
  }
  return 0;
}
int main(){
  int x = -6144;
  int y = -4096;
  int block[1024];
  int it = 0;
  while( y < 4096 ){
    x = -6144;
    int cnt = 0;
    int cur = 0;
    while( x < 2048 ){
      cnt = cnt + 1;
      cur = ( cur << 1 ) | isin( x , y );
      if( cnt == 16 ){
        block[it] = cur;
        it = it + 1;
        cnt = 0;
        cur = 0;
      }
      x = x + 64;
    }
    y = y + 64;
  }
  return it;
}
