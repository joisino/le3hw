int main(){

  int x = 1;
  int y;
  for( int i = 0; i < 8; i = i + 1 ){
    y = x << i;
    if( i < 2 ){
      out( i , y );
    }
  }

  return 0;
}
