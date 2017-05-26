int dx[4];
int dy[4];

int moveflag;
int rotateflag;
int downflag;
int rooptime;

int score;
int scoremp[5];


int multi( int a , int b ){
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

int output(int led) {
	for (int x = 3; x >= 0; x = x - 1) {
		for (int y = 0; y < 4; y = y + 1) {
			int index = multi(x, 4) + y;
			out(index,led[index]);
		}
	}
	return 0;
}

int showled(int digital) {
	int led[16];
	for (int y = 0; y < 4; y = y + 1) {
		for (int x = 0; x < 4; x = x + 1) {
			int num = 0;
			for (int h = 0; h < 4; h = h + 1) {
				num = num << 4;
				int index = multi((y << 2) + h, 4) + x;
				num = num + digital[index];
			}
			led[multi(x, 4) + y] = num;

			
		}
	}
	output(led);
	return 0;
}

int showdigital(int ans) {
	int digital[64];

	for (int h = 4; h <19; h = h + 1) {
		for (int w = 0; w < 4; w = w + 1) {
			int fieldindex = multi(h,  4 ) + w;
			int digindex = multi(h - 4,  4 ) + w;
			if (ans[fieldindex] == 1) {
				digital[digindex] = 8;
			}
			else if (ans[fieldindex] == 2) {
				digital[digindex] = 5;
			}
			else if (ans[fieldindex] == 42) {
				digital[digindex] = 2;
			}
			else {
				digital[digindex] = 1;
			}
		}
	}
	for(int i = 60 ; i < 64 ; i = i + 1){
	  
	  digital[i] = (score >> ((63 - i) << 2 )) & 15;
	}
	showled(digital);
	return 0;
}

int show(int mp, int nh, int nw, int mino) {
	int ans[84];
	for (int i = 0; i < 84; i = i + 1)ans[i] = 0;
	for (int h = 4; h < 19; h = h + 1) {
		for (int w = 0; w < 4; w = w + 1) {
			ans[multi(h,  4 ) + w] = mp[multi(h,  4 ) + w];
		}
	}
	for (int y = 0; y < 5; y = y + 1) {
		for (int x = 0; x < 5; x = x + 1) {
			if (mino[multi(y, 5) + x]) {
				int h = y + nh -  2 ;
				int w = x + nw -  2 ;
				ans[multi(h,  4 ) + w] = 2;
			}
		}
	}
	showdigital(ans);
	return 0;

}

int input(int k) {
  return ( in() & ( 1 << k ) ) == 0;
}
int canmove(int mp, int nh, int nw, int mino, int way) {
	for (int y = 0; y <  5 ; y = y + 1) {
		for (int x = 0; x <  5 ; x = x + 1) {
			if (mino[multi(y,  5 ) + x]) {
				int nexth = y + nh -  2  + dy[way];
				int nextw = x + nw -  2  + dx[way];
				if ((nexth > 18)|(nexth < 0)|(nextw >=  4 )|(nextw < 0))return 0;
				if (mp[multi(nexth,  4 ) + nextw]) {
					return 0;
				}
			}
		}
	}
	return 1;
}
int canrotate(int mp, int nh, int nw, int mino, int clockwise) {
	for (int y = 0; y <  5 ; y = y + 1) {
		for (int x = 0; x <  5 ; x = x + 1) {
			int nowh = y + nh -  2 ;
			int noww = x + nw -  2 ;
			if (mino[multi(y,  5 ) + x]) {
				int nexth = 0;
				int nextw = 0;
				if (clockwise) {
					nexth = nh + (noww - nw);
					nextw = nw + (nh - nowh);
				}
				else {
					nexth = nh - (noww - nw);
					nextw = nw - (nh - nowh);
				}
				if ((nexth > 18) | (nexth < 0)|(nextw >=  4 )|(nextw < 0)) {
					return 0;
				}
				if (mp[multi(nexth,  4 ) + nextw]) {
					return 0;
				}
			}
		}
	}
	return 1;
}

int land(int mp, int nh, int nw, int mino) {
	for (int y = 0; y <  5 ; y = y + 1) {
		for (int x = 0; x <  5 ; x = x + 1) {
			int  nowh = y + nh -  2 ;
			int noww = x + nw -  2 ;
			if (mino[multi(y,  5 ) + x]) {
				mp[multi(nowh,  4 ) + noww] = 1;
			}
		}
	}
	return 0;
}

int del(int mp) {
	int nextmp[84];
	int sum = 0;
	for (int i = 0; i < 84; i = i + 1) {
		nextmp[i] = mp[i];
	}
	for (int y = 0; y < 19; y = y + 1) {
		int flag = 1;
		for (int x = 0; x <  4 ; x = x + 1) {
			if (mp[multi(y,  4 ) + x] == 0) {
				flag = 0;
			}
		}
		if (flag == 1) {
			for (int x = 0; x <  4 ; x = x + 1) {
				mp[multi(y,  4 ) + x] = 42;
			}
			sum = sum + 1;
		}
	}
	return sum;
}
int fall(int mp) {
	int nextmp[84];
	for (int i = 0; i < 84; i = i + 1) {
		nextmp[i] = mp[i];
	}
	for (int k = 0; k < 24; k = k + 1) {
		for (int y = 18; y >= 1; y = y - 1) {
			int flag = 1;
			for (int x = 0; x <  4 ; x = x + 1) {
				if (mp[multi(y,  4 ) + x]) {
					flag = 0;
				}
			}
			if (flag == 1) {
				for (int x = 0; x <  4 ; x = x + 1) {
					int t = nextmp[multi(y,  4 ) + x];
					nextmp[multi(y,  4 ) + x] = nextmp[multi(y - 1,  4 ) + x];
					nextmp[multi(y - 1,  4 ) + x] = t;
				}
			}
		}
		for (int i = 0; i < 84; i = i + 1) {
			mp[i] = nextmp[i];
		}
	}
	int k[84];
	for (int i = 0; i < 84; i = i + 1) {
		k[i] = mp[i];
	}
	return 1;
}

int main() {
  rooptime=10;
        moveflag=0;
        rotateflag=0;
        downflag=0;
	int tetonum = 3;
	dx[0] = -1;
        dx[1] = 0;
	dx[2] = 1;
        dx[3] = 0;
        dy[0] = 0;
	dy[1] = 1;
        dy[2] = 0;
	dy[3] = -1;
	scoremp[0]=0;
	scoremp[1]=1;
	scoremp[2]=3;
	scoremp[3]=7;
	scoremp[4]=20;
	score=0;
        int B[100];
	int Dummy[25];
	for (int i = 0; i < 25; i = i + 1) {
		Dummy[i] = 0;
	}
        for( int i = 0; i < 100; i = i + 1 ){
          B[i] = 0;
        }
	B[6] = 1; B[7] = 1; B[8] = 1; B[12] = 1;
	B[36] = 1; B[32] = 1; B[33] = 1; B[37] = 1;
	B[52] = 1; B[57] = 1; B[62] = 1; B[67] = 1;
	B[83] = 1; B[82] = 1; B[88] = 1; B[87] = 1;

	int stage[84];
	for (int i = 0; i < 80; i = i + 1) {
		stage[i] = 0;
	}
	for (int i = 80; i < 84; i = i + 1) {
		stage[i] = 9;
	}
	int nh = 1;
	int nw = 1;
	int mino[25];
        int nextmino[25];
	for (int i = 0; i < 25; i = i + 1) {
		mino[i] = 0;
	}
	int status = 0;
	int k = 0;
	int pretime = ( * ( -32768 ) );
	while (1) {
	        for (int i = 0; i < 16; i = i + 1) {
			if (stage[i] == 1) {
				return 0;
			}
		}
		if (status == 3) {
			status = 4;
		}
		else if (status == 4) {
			for (int i = 0; i < 84; i = i + 1) {
				if (stage[i] == 42) {
					stage[i] = 0;
				}
			}
			fall(stage);
			status = 0;
		}
		else if (status == 0 | status == 1) {
			if (status == 0) {
				nh = 1;
				nw = 1;
				status = 1;
			        k = (multi(k,123) + 22);
				k = (k & 16383) >> 3;
			
				for( int i = 0; i < 25; i = i + 1 ) {
                                  mino[i] = B[multi(25,(k&3))+i];
                                }

			}
			if (moveflag!=0) {
				if (canmove(stage, nh, nw, mino, moveflag + 1)) {
					nw = nw + moveflag;
				}
			}
		        if (rotateflag!=0) {
			  
			  if (canrotate(stage, nh, nw, mino, (rotateflag + 1) >> 1 )) {
					for (int y = 0; y <  5 ; y = y + 1) {
						for (int x = 0; x <  5 ; x = x + 1) {
						  int nextplace = multi( 2  + (x -  2 ),  5 ) +  2  + ( 2  - y);
						  if(rotateflag == -1 ){
						    nextplace = 24 - nextplace;
						  }
						  nextmino[nextplace] = mino[multi(y,  5 ) + x];
						}
					}
					for (int y = 0; y <  5 ; y = y + 1) {
						for (int x = 0; x <  5 ; x = x + 1) {
							mino[multi(y,  5 ) + x] = nextmino[multi(y,  5 ) + x];
						}
					}
				}
			}
			if (canmove(stage, nh, nw, mino, 1)) {
				nh = nh + 1;
			}
			else {
				land(stage, nh, nw, mino);
				int dellinecount = del(stage);
				for (int i = 0; i < 25; i = i + 1) {
					mino[i] = 0;
				}
				nh = 1;
				nw = 1;
				score = score + scoremp[dellinecount];
				if (dellinecount == 0) {
					status = 0;
				}
				else {
					status = 3;
				}
			}
		}

		show(stage, nh, nw, mino);
                moveflag=0;
		rotateflag=0;
		if(downflag==1){
		  rooptime=2;
		}else{
		  rooptime=10;
		}
		downflag=0;
		while( ( ( *( -32768 ) ) - pretime) < (rooptime << 6)){
		  if(input(4)){
		      moveflag=-1;
		    }
		    if(input(0)){
		      moveflag=1;
		    }
		    if(input(12)){
		      rotateflag=1;
		    }
		    if(input(13)){
		      downflag=1;
		    }
		    if(input(8)){
		      rotateflag=-1;
		    }
		}
		  pretime = (*(-32768));
                
	}
	return 0;
}

