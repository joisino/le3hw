#include <iostream>
#include <fstream>
#include <sstream>
#include <string>
#include <map>
#include <vector>
#include <algorithm>
#include <cassert>


std::string d_to_b( std::string s, int b ){
  int num = 0;
  for( char c : s ){
    assert( '0' <= c && c <= '9' );
    num = num * 10 + (int)( c - '0' );
  }
  assert( num < ( 1 << b ) );
  std::string res = "";
  for( int i = 0; i < b; i++ ){
    char c = '0' + num % 2;
    res += c;
    num /= 2;
  }
  reverse( res.begin(), res.end() );
  return res;
}

std::string extend( std::string s ){
  int b = 8;
  bool minus = false;
  if( s[0] == '-' ){
    minus = true;
    s = s.substr( 1 );
  }
  int num = 0;
  for( char c : s ){
    assert( '0' <= c && c <= '9' );
    num = num * 10 + (int)( c - '0' );
  }
  for( int i = 0; i < 8; i++ ){
    if( num == ( 1 << (i+7) ) ){
      return "10000" + d_to_b( std::to_string( i ), 3 );
    }
  }
  for( int i = 0; i < 8; i++ ){
    if( num == ( 1 << (i+8) ) - 1 ){
      return "10001" + d_to_b( std::to_string( i ), 3 );
    }
  }
  assert( num < ( 1 << (b-1) ) );
  if( minus ){
    num = ( 1 << b ) - num;
  }
  std::string res = "";
  for( int i = 0; i < b; i++ ){
    char c = '0' + num % 2;
    res += c;
    num /= 2;
  }
  reverse( res.begin(), res.end() );
  return res;
}

int inst_cnt = 0;
std::string decode( std::string inst ){
  std::vector<std::string> arithmetics = { "ADD", "SUB", "AND", "OR", "XOR", "CMP", "MOV"};
  std::vector<std::string> shifts = { "SLL", "SLR", "SRL", "SRA" };
  std::stringstream stin( inst );
  std::string op, res = "";
  std::cerr << inst_cnt++ << " " << inst << std::endl;
  stin >> op;
  if( find( arithmetics.begin(), arithmetics.end(), op ) != arithmetics.end() ){
    res += "11";

    std::string rd, rs;
    stin >> rd;
    stin >> rs;
    
    assert( rs[0] == 'r' );
    res += d_to_b( rs.substr( 1 ) , 3 );

    assert( rd[0] == 'r' );
    res += d_to_b( rd.substr( 1 ) , 3 );

    if( op == "ADD" ){
      res += "0000";
    } else if( op == "SUB" ){
      res += "0001";
    } else if( op == "AND" ){
      res += "0010";
    } else if( op == "OR" ){
      res += "0011";
    } else if( op == "XOR" ){
      res += "0100";
    } else if( op == "CMP" ){
      res += "0101";
    } else if( op == "MOV" ){
      res += "0110";
    }
    res += "0000";
  } else if( find( shifts.begin(), shifts.end(), op ) != shifts.end() ){
    res += "11000";

    std::string rd;
    stin >> rd;
    std::string d;
    stin >> d;

    assert( rd[0] == 'r' );
    res += d_to_b( rd.substr( 1 ) , 3 );

    if( op == "SLL" ){
      res += "1000";
    } else if( op == "SLR" ){
      res += "1001";
    } else if( op == "SRL" ){
      res += "1010";
    } else if( op == "SRA" ){
      res += "1011";
    }
    res += d_to_b( d , 4 );
  } else if( op == "IN" ){
    res += "11";

    res += "000";

    std::string rd;
    stin >> rd;
    
    assert( rd[0] == 'r' );
    res += d_to_b( rd.substr( 1 ) , 3 );

    res += "1100";
    
    res += "0000";
  } else if( op == "OUT" ){
    res += "11";

    std::string rs, rd;
    stin >> rs;
    stin >> rd;
    
    assert( rs[0] == 'r' );
    res += d_to_b( rs.substr( 1 ) , 3 );

    assert( rd[0] == 'r' );
    res += d_to_b( rd.substr( 1 ) , 3 );

    res += "1101";

    res += "0000";
  } else if( op == "HLT" ){
    res = "1100000011110000";
  } else if( op == "LD" || op == "ST" ){
    if( op == "LD" ){
      res += "00";
    } else if( op == "ST" ){
      res += "01";
    }

    std::string ra, rb, d;
    stin >> ra;
    stin >> rb;
    stin >> d;
    
    assert( ra[0] == 'r' );
    res += d_to_b( ra.substr( 1 ) , 3 );

    assert( rb[0] == 'r' );
    res += d_to_b( rb.substr( 1 ) , 3 );
    res += extend( d );
  } else if( op == "LI" || op == "ADDI" || op == "CMPI" ){
    res += "10";
    if( op == "LI" ){
      res += "000";
    } else if( op == "ADDI" ){
      res += "001";
    } else if( op == "CMPI" ){
      res += "010";
    }
    std::string rb, d;
    stin >> rb;
    stin >> d;

    assert( rb[0] == 'r' );
    res += d_to_b( rb.substr( 1 ) , 3 );

    if( ( '0' <= d[0] && d[0] <= '9' ) || d[0] == '+' || d[0] == '-' ){
      res += extend( d );
    } else {
      res += d;
      std::string par;
      stin >> par;
      res += par;
    }
  } else if( op == "LOCK" || op == "UNLOCK" ){
    res += "10011";
    std::string rb;
    stin >> rb;

    assert( rb[0] == 'r' );
    res += d_to_b( rb.substr( 1 ) , 3 );

    if( op == "LOCK" ){
      res += "00000000";
    } else if( op == "UNLOCK" ){
      res += "00000001";
    }
  } else if( op == "B" || op == "BAL" || op == "BE" || op == "BLT" || op == "BLE" || op == "BNE" ){
    if( op == "B" ){
      res += "10100000";
    } else if( op == "BAL" ){
      res += "10101000";
    } else if( op == "BE" ){
      res += "10111000";
    } else if( op == "BLT" ){
      res += "10111001";
    } else if( op == "BLE" ){
      res += "10111010";
    } else if( op == "BNE" ){
      res += "10111011";
    }
    std::string d;
    stin >> d;
    res += d;
  } else if( op == "BR" ){
    res += "10110";
    
    std::string rb;
    stin >> rb;
    assert( rb[0] == 'r' );
    res += d_to_b( rb.substr( 1 ) , 3 );

    res += "00000000";
  } else if( op == "NOP" ){
    res += "1000100000000000";
  } else {
    puts( "OP not exist" );
    assert( false );
  }
  return res;
}


int main( int argc, char **argv ){
  
  if( argc != 2 ){
    std::cout << "Usage: " << std::string(argv[0]) << " file" << std::endl;
    return 1;
  }
  
  std::ifstream ifs( argv[1] );

  if( ! ifs ){
    std::cout << "File Not Found" << std::endl;
    return 1;
  }

  std::string buffer;
  int cur_address = 0;
  std::map<std::string,int> label_to_address;
  std::vector<std::string> insts;
  while( std::getline( ifs, buffer ) ){
    for( int i = 0; i < (int)buffer.size(); i++ ){
      if( buffer[i] == '#' ){
        buffer = buffer.substr( 0 , i );
        break;
      }
    }
    while( ( ! buffer.empty() ) && buffer.back() == ' ' ){
      buffer.pop_back();
    }
    if( buffer.empty() ){
      continue;
    }
    if( buffer.back() == ':' ){
      buffer.pop_back();
      label_to_address[buffer] = cur_address;
    } else {
      insts.push_back( decode( buffer ) );
      cur_address++;
    }
  }

  // convert label to address
  for( int i = 0; i < (int)insts.size(); i++ ){
    std::string w = insts[i];
    std::string op2 = w.substr( 2 , 3 );
    if( w.substr( 0 , 2 ) == "10" ){
      if( op2 == "100" || op2 == "101" || op2 == "111" ){
        std::string label = w.substr( 8 );
        if( label_to_address.find( label ) == label_to_address.end() ){
          std::cout << "LAVEL " << label << " NOT FOUND" << std::endl;
          assert( false );
        }
        insts[i] = w.substr( 0 , 8 ) + extend( std::to_string( label_to_address[label] - ( i + 1 ) ) );
      } else if( op2 == "000" || op2 == "001" || op2 == "010" ){
        std::string label = w.substr( 8 );
        std::string par = label.substr( (int)(label.size()) - 1 );
        label = label.substr( 0 , (int)(label.size()) - 1 );
        if( '0' <= label[0] && label[0] <= '9' ){
          continue;
        }
        if( label_to_address.find( label ) == label_to_address.end() ){
          std::cout << "LAVEL " << label << " NOT FOUND" << std::endl;
          assert( false );
        }
        int adr = label_to_address[label];
        int imm = -1;
        if( par == "0" ){
          imm = adr >> 12;
        } else if( par == "1" ){
          imm = ( adr >> 6 ) % ( 1 << 6 );
        } else if( par == "2" ){
          imm = adr % ( 1 << 6 );
        }
        insts[i] = w.substr( 0 , 8 ) + extend( std::to_string( imm ) );
      }
    }
  }

  for( std::string &inst : insts ){
    std::cout << inst << std::endl;
  }
  
  return 0;
}
