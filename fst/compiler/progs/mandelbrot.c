int abs( int a ){
  if( a < 0 ){
    return -a;
  }
  return a;
}
int mul( int a , int b ){
  int sgn = 0;
  int res = 0;
  if( b < 0 ){
    sgn = 1;
    b = -b;
  }
  while( b ){
    if( b & 1 ){
      res = res + a;
    }
    a = a + a;
    b = b >> 1;
  }
  if( sgn ){
    res = -res;
  }
  return res;
}
int fmul( int a , int b ){
  return mul( a , b ) >> 6;
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
    if( abs( cx ) > ( 2 << 6 ) ){
      return 1;
    }
    if( abs( cy ) > ( 2 << 6 ) ){
      return 1;
    }
    i = i + 1;
  }
  return 0;
}
int p( int x , int y ){
  return ( y << 5 ) + x;
}
int main(){
  int x = -96;
  int y = -64;
  int block[1024];
  while( x < 32 ){
    y = -64;
    while( y < 64 ){
      block[ p( ( x + 96 ) >> 2 , ( y + 64 ) >> 2 ) ] = isin( x , y );
      y = y + 4;
    }
    x = x + 4;
  }
  return 0;
}
