#include <bits/stdc++.h>
      
#define FOR(i,a,b) for( ll i = (a); i < (ll)(b); i++ )
#define REP(i,n) FOR(i,0,n)
#define YYS(x,arr) for(auto& x:arr)
#define ALL(x) (x).begin(),(x).end()
#define SORT(x) sort( (x).begin(),(x).end() )
#define REVERSE(x) reverse( (x).begin(),(x).end() )
#define UNIQUE(x) (x).erase( unique( ALL( (x) ) ) , (x).end() )
#define PW(x) (1LL<<(x))
#define SZ(x) ((ll)(x).size())
#define SHOW(x) cout << #x << " = " << x << endl
#define SHOWA(x,n) for( int yui = 0; yui < n; yui++ ){ cout << x[yui] << " "; } cout << endl

#define pb emplace_back
#define fi first
#define se second

using namespace std;

typedef long double ld;
typedef long long int ll;
typedef pair<int,int> pi;
typedef pair<ll,ll> pl;
typedef vector<int> vi;
typedef vector<ll> vl;
typedef vector<bool> vb;
typedef vector<ld> vd;
typedef vector<pi> vpi;
typedef vector<pl> vpl;
typedef vector<vpl> gr;
typedef vector<vl> ml;
typedef vector<vd> md;
typedef vector<vi> mi;
     
const ll INF = (ll)1e9 + 10;
const ll INFLL = (ll)1e18 + 10;
const ld EPS = 1e-12;
const ll MOD = 1e9+7;
     
template<class T> T &chmin( T &a , const T &b ){ return a = min(a,b); }
template<class T> T &chmax( T &a , const T &b ){ return a = max(a,b); }
template<class T> inline T sq( T a ){ return a * a; }

ll in(){ long long int x; scanf( "%lld" , &x ); return x; }
char yuyushiki[1000010]; string stin(){ scanf( "%s" , yuyushiki ); return yuyushiki; }

// head


void print_binary( ll x, int sz = INF, bool nl = true, bool err = false ){
  if( x < 0 ){
    x = PW(sz) + x;
  }
  vi res(0);
  REP( i , sz ){
    res.pb( x % 2 );
    x /= 2;
    if( sz == INF && x == 0 ) break;
  }
  REVERSE( res );
  if( err ){
    YYS( w , res ) cerr << w;
    if( nl ) cerr << endl;
  } else {
    YYS( w , res ) printf( "%d" , w );
    if( nl ) printf( "\n" );
  }
}


int hextoint( string s ){
  int res = 0;
  YYS( w , s ){
    int c = 0;
    if( '0' <= w && w <= '9' ){
      c = w - '0';
    } else {
      c = w - 'a' + 10;
    }
    res = res * 16 + c;
  }
  return res;
}

int main( int argc, char *argv[] ){

  if( argc != 2 ){
    cout << "Usage: " << argv[0] << " miffile" << endl;
    exit( 1 );
  }

  ifstream ifs( argv[1] );

  REP( i , 1024 ){
    cout << "0000000000000000" << endl;
  }
  
  REP( i , 1024 ){
    string s, t, u;
    ifs >> s >> t >> u;
    u = u.substr( 0 , SZ(u)-1 );
    if( s[0] == '[' ){
      string x = s.substr( 1 , 3 );
      string y = s.substr( 6 , 3 );
      int a = hextoint( x );
      int b = hextoint( y );
      REP( j , b - a + 1 ){
        print_binary( stoi( u ), 16 );
      }
      i += b - a;
    } else {
      print_binary( stoi( u ), 16 );
    }
  }
  

  REP( i , 65536-2048 ){
    cout << "0000000000000000" << endl;
  }


  return 0;
}
