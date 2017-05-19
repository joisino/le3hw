int MINOSIZE;
int MINOCENTERH;
int MINOCENTERW;
int STAGEWIDE;

int dx[4];
int dy[4];

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
	for (int i = 0; i < 64; i = i + 1) {
		digital[i] = -1;
	}
	for (int h = 4; h <20; h = h + 1) {
		for (int w = 0; w < 4; w = w + 1) {
			int fieldindex = multi(h, STAGEWIDE) + w;
			int digindex = multi(h - 4, STAGEWIDE) + w;
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
	showled(digital);
	return 0;
}

int show(int mp, int nh, int nw, int mino) {
	int ans[84];
	for (int i = 0; i < 84; i = i + 1)ans[i] = 0;
	for (int h = 4; h <20; h = h + 1) {
		for (int w = 0; w <STAGEWIDE; w = w + 1) {
			ans[multi(h, STAGEWIDE) + w] = mp[multi(h, STAGEWIDE) + w];
		}
	}
	for (int y = 0; y < MINOSIZE; y = y + 1) {
		for (int x = 0; x < MINOSIZE; x = x + 1) {
			if (mino[multi(y, MINOSIZE) + x]) {
				int h = y + nh - MINOCENTERH;
				int w = x + nw - MINOCENTERW;
				ans[multi(h, STAGEWIDE) + w] = 2;
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
	for (int y = 0; y < MINOSIZE; y = y + 1) {
		for (int x = 0; x < MINOSIZE; x = x + 1) {
			if (mino[multi(y, MINOSIZE) + x]) {
				int nexth = y + nh - MINOCENTERH + dy[way];
				int nextw = x + nw - MINOCENTERW + dx[way];
				if (nexth > 19)return 0;
				if (nexth < 0)return 0;
				if (nextw >= STAGEWIDE)return 0;
				if (nextw < 0)return 0;
				if (mp[multi(nexth, STAGEWIDE) + nextw]) {
					return 0;
				}
			}
		}
	}
	return 1;
}
int canrotate(int mp, int nh, int nw, int mino, int clockwise) {
	for (int y = 0; y < MINOSIZE; y = y + 1) {
		for (int x = 0; x < MINOSIZE; x = x + 1) {
			int  nowh = y + nh - MINOCENTERH;
			int noww = x + nw - MINOCENTERW;
			if (mino[multi(y, MINOSIZE) + x]) {
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
				if ((nexth > 19) | (nexth < 0)) {
					return 0;
				}
				if ((nextw >= STAGEWIDE) | (nextw < 0)) {
					return 0;
				}
				if (mp[multi(nexth, STAGEWIDE) + nextw]) {
					return 0;
				}
			}
		}
	}
	return 1;
}

int land(int mp, int nh, int nw, int mino) {
	for (int y = 0; y < MINOSIZE; y = y + 1) {
		for (int x = 0; x < MINOSIZE; x = x + 1) {
			int  nowh = y + nh - MINOCENTERH;
			int noww = x + nw - MINOCENTERW;
			if (mino[multi(y, MINOSIZE) + x]) {
				mp[multi(nowh, STAGEWIDE) + noww] = 1;
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
	for (int y = 0; y < 20; y = y + 1) {
		int flag = 1;
		for (int x = 0; x < STAGEWIDE; x = x + 1) {
			if (mp[multi(y, STAGEWIDE) + x] == 0) {
				flag = 0;
			}
		}
		if (flag == 1) {
			for (int x = 0; x < STAGEWIDE; x = x + 1) {
				mp[multi(y, STAGEWIDE) + x] = 42;
			}
			sum = sum + 1;
		}
	}
	return sum > 0;
}
int fall(int mp) {
	int nextmp[84];
	for (int i = 0; i < 84; i = i + 1) {
		nextmp[i] = mp[i];
	}
	for (int k = 0; k < 24; k = k + 1) {
		for (int y = 19; y >= 1; y = y - 1) {
			int flag = 1;
			for (int x = 0; x < STAGEWIDE; x = x + 1) {
				if (mp[multi(y, STAGEWIDE) + x]) {
					flag = 0;
				}
			}
			if (flag == 1) {
				for (int x = 0; x < STAGEWIDE; x = x + 1) {
					int t = nextmp[multi(y, STAGEWIDE) + x];
					nextmp[multi(y, STAGEWIDE) + x] = nextmp[multi(y - 1, STAGEWIDE) + x];
					nextmp[multi(y - 1, STAGEWIDE) + x] = t;
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
	MINOSIZE = 5;
	MINOCENTERH = 2;
	MINOCENTERW = 2;
	STAGEWIDE = 4;
	int tetonum = 3;
	dx[0] = -1;
        dx[1] = 0;
	dx[2] = 1;
        dx[3] = 0;
        dy[0] = 0;
	dy[1] = 1;
        dy[2] = 0;
	dy[3] = -1;
        int B[75];
	int Dummy[25];
	for (int i = 0; i < 25; i = i + 1) {
		Dummy[i] = 0;
	}
        for( int i = 0; i < 75; i = i + 1 ){
          B[i] = 0;
        }
	B[6] = 1; B[7] = 1; B[8] = 1; B[12] = 1;
	B[25 + 11] = 1; B[25 + 7] = 1; B[25 + 8] = 1; B[25 + 12] = 1;
	B[50 + 2] = 1; B[50 + 7] = 1; B[50 + 12] = 1; B[50 + 17] = 1;

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
	while (1) {
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
                                for( int i = 0; i < 25; i = i + 1 ) {
                                  mino[i] = B[multi(25,k)+i];
                                }
				k = k + 1;
				if (k >= 3) {
					k = k - 3;
				}

			}
			if (input(4)) {
				if (canmove(stage, nh, nw, mino, 0)) {
					nw = nw - 1;
				}
			}
			else if (input(0)) {
				if (canmove(stage, nh, nw, mino, 2)) {
					nw = nw + 1;
				}
			}
			else if (input(12)) {
				if (canrotate(stage, nh, nw, mino, 1)) {
					for (int y = 0; y < MINOSIZE; y = y + 1) {
						for (int x = 0; x < MINOSIZE; x = x + 1) {
							nextmino[multi(MINOCENTERH + (x - MINOCENTERW), MINOSIZE) + MINOCENTERW + (MINOCENTERH - y)] = mino[multi(y, MINOSIZE) + x];
						}
					}
					for (int y = 0; y < MINOSIZE; y = y + 1) {
						for (int x = 0; x < MINOSIZE; x = x + 1) {
							mino[multi(y, MINOSIZE) + x] = nextmino[multi(y, MINOSIZE) + x];
						}
					}
				}
			}
			if (canmove(stage, nh, nw, mino, 1)) {
				nh = nh + 1;
			}
			else {
				land(stage, nh, nw, mino);
				int flag = del(stage);
				for (int i = 0; i < 25; i = i + 1) {
					mino[i] = 0;
				}
				nh = 1;
				nw = 1;
				if (flag == 0) {
					status = 0;
				}
				else {
					status = 3;
				}
			}
		}

		show(stage, nh, nw, mino);
                
                for( int i = 0; i < 30000; i = i + 1 ){
                  for( int j = 0; j < 10; j = j + 1 ){
                    1;
                  }
                }
                
	}
	return 0;
}

