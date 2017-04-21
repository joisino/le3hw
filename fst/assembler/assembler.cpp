#include <iostream>
#include <fstream>
#include <sstream>
#include <string>
#include <map>
#include <vector>
#include <algorithm>
#include <cassert>

std::string d_to_b( std::string s, int b, bool sign = false ){
  bool minus = false;
  if( s[0] == '-' ){
    minus = true;
    s = s.substr( 1 );
  }
  int num = 0;
  for( char c : s ){
    num = num * 10 + (int)( c - '0' );
  }
  assert( num < ( 1 << b ) );
  if( sign ){
    assert( num < ( 1 << (b-1) ) );
  }
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

    std::string rs;
    stin >> rs;
    
    assert( rs[0] == 'r' );
    res += d_to_b( rs.substr( 1 ) , 3 );

    res += "000";

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
    res += d_to_b( d, 8, true );
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

    res += d_to_b( d, 8, true );
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
    if( w.substr( 0 , 2 ) == "10" && ( op2 == "100" || op2 == "101" || op2 == "111" ) ){
      std::string label = w.substr( 8 );
      if( label_to_address.find( label ) == label_to_address.end() ){
        std::cout << "LAVEL " << label << " NOT FOUND" << std::endl;
        assert( false );
      }
      insts[i] = w.substr( 0 , 8 ) + d_to_b( std::to_string( label_to_address[label] - ( i + 1 ) ) , 8, true );
    }
  }

  for( std::string &inst : insts ){
    std::cout << inst << std::endl;
  }
  
  return 0;
}
