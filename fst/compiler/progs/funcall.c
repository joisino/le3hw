int dbl( int x ){
  return x + x;
}
int main(){
  int i;
  int sum;
  sum = 0;
  i = 0;
  while( i <= 20 ){
    sum = sum + i;
    if( i == dbl( 6 ) ){
      return 0;
    }
    i = i + 1;
  }
  int y;
  y = 2;
  int x;
  x = 5;
}
