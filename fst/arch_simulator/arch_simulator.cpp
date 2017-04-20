#include <iostream>
#include  <iomanip>
#include <fstream>
#include <sstream>
#include <string>
#include <memory>
#include <vector>
#include <functional>
#include <algorithm>
#include <cassert>
#include <random>

const bool DEBUG = true;


int two_to_i(std::string st) {
	int sum = 0;
	for (size_t i = 0; i < st.size(); ++i) {
		sum *= 2;
		sum += st[i] - '0';
	}
	return sum;
}

struct Operation {
	enum Name {
		Calc_put,
		Load_store,
		Imme_goto,
		If,
	};
	Name name;
	enum Op1 {
		LD = 0,
		ST = 1,
		IS_IMME_LOAD_OR_IF = 2,
		IS_CALC_PUT = 3,
	};
	Op1 op1;
	enum Op2 {
		LI = 0,



		B  =4,


		IS_IF =7,
	};
	int d;
	virtual void play(int &pc, std::vector<int>&r, std::vector<int>&m, int& Z, int& S, int& V, bool& finish_flag) {
		pc++;
	}
};
struct Calc_put :Operation {
	int rs;
	int rd;
	enum Op3 {
		ADD = 0,
		SUB = 1,
		AND=2,
		OR=3,
		XOR=4,
		CMP=5,
		MOV=6,

		SLL=8,
		SLR=9,
		SRL=10,
		SRA=11,
		IN =12,
		OUT=13,

		HLT=15,
	};
	Op3 op3;
	Calc_put(const std::string&st) {
		name = Name::Calc_put;
		Op1 op1_ = static_cast<Op1>(two_to_i(st.substr(0, 2)));
		int rs_ = two_to_i(st.substr(2, 3));
		int rd_ = two_to_i(st.substr(5, 3));
		Op3 op3_ = static_cast<Op3>(two_to_i(st.substr(8, 4)));
		int d_ = two_to_i(st.substr(12, 4));
		op1 = op1_; rs = rs_; rd = rd_;
		op3 = op3_; d = d_;
	}

	virtual void play(int &pc, std::vector<int>&r, std::vector<int>&m,int& Z,int& S,int& V,bool& finish_flag) {
		Z = false;
		S = false;
		V = false;
		assert(op1 == 3);
		switch (op3){
		case ADD:
			r[rd] += r[rs];
			break;
		case SUB:
			r[rd] -= r[rs];
			break;
		case AND:
			r[rd] &= r[rs];
			break;
		case OR:
			r[rd] |= r[rs];
			break;
		case XOR:
			r[rd] ^= r[rs];
			break;
		case CMP: {
			int num = r[rd] - r[rs];
			if (num < 0)S = true;
			if (num == 0)Z = true;
			if (abs(V) >= 1 << 15)V = true;
			break;
		}
		case MOV:
			r[rd] = r[rs];
			break;
		case SLL:
			r[rd] <<= d;
			break;
		case SLR:
			assert(d <= 16);
			r[rd] = (short(r[rd] << d) | short(r[rd] >> (16 - d)));
			break;
		case SRL:
			r[rd] = static_cast<unsigned int>(r[rd]) >> d;
			break;
		case SRA:
			r[rd] >>= d;
			assert(false);
			break;
		case IN:
			assert(false);
			break;
		case OUT:
			break;

		case HLT:
			finish_flag = true;
			break;
		default:
			assert(false);
			break;
		}
		Operation::play(pc,r,m,Z,S,V,finish_flag);
	}
};
struct Load_store :Operation {
	int ra;
	int rb;
	Load_store(const std::string&st) {
		name = Name::Load_store;
		Op1 op1_ = static_cast<Op1>(two_to_i(st.substr(0, 2)));
		int ra_ = two_to_i(st.substr(2, 3));
		int rb_ = two_to_i(st.substr(5, 3));
		int d_ = two_to_i(st.substr(8, 8));
		if (d_ >= 128)d_ = d_ - 256;
		op1 = op1_; ra = ra_;
		rb = rb_; d = d_;
	}
	virtual void play(int &pc, std::vector<int>&r, std::vector<int>&m, int& Z, int& S, int& V, bool& finish_flag) {
		switch (op1) {
		case LD:
			r[ra] = m[r[rb] + d];
			break;
		case ST:
			m[r[rb] + d] = r[ra];
			break;
		default:
			assert(false);
		}
		Operation::play(pc, r, m, Z, S, V, finish_flag);
	}

};
struct Imme_goto : Operation {
	Op2 op2;
	int rb;


	Imme_goto(const std::string&st) {
		name = Name::Imme_goto;
		Op1 op1_ = static_cast<Op1>(two_to_i(st.substr(0, 2)));
		assert(op1_ == 2);
		Op2 op2_ = static_cast<Op2>(two_to_i(st.substr(2, 3)));
		int rb_ = two_to_i(st.substr(5, 3));
		int d_ = two_to_i(st.substr(8, 8));
		if (d_ >= 128)d_ = d_ - 256;
		op1 = op1_; op2 = op2_;
		rb = rb_; d = d_;
	}
	virtual void play(int &pc, std::vector<int>&r, std::vector<int>&m, int& Z, int& S, int& V, bool& finish_flag) {
		switch (op2) {
		case LI:
			r[rb] = d;
			break;
		case B:
			pc += d;
			break;
		default:
			assert(false);
		}
		Operation::play(pc, r, m, Z, S, V, finish_flag);
	}
};
struct If : Operation {
	Op2 op2;
	enum Cond {
		BE = 0,
		BLT = 1,
		BLE = 2,
		BNE = 3,




	};
	Cond cond;
	If(const std::string&st) {
		name = Name::If;
		Op1 op1_ = static_cast<Op1>(two_to_i(st.substr(0, 2)));
		assert(op1_ == IS_IMME_LOAD_OR_IF);
		Op2 op2_ = static_cast<Op2>(two_to_i(st.substr(2, 3)));
		assert(op2_ == IS_IF);
		Cond cond_ = static_cast<Cond>(two_to_i(st.substr(5, 3)));
		int d_ = two_to_i(st.substr(8, 8));
		if (d_ >= 128)d_ = d_ - 256;
		op1 = op1_; op2 = op2_;
		cond = cond_; d = d_;
	}
	virtual void play(int &pc, std::vector<int>&r, std::vector<int>&m, int& Z, int& S, int& V, bool& finish_flag) {
		switch (cond) {
		case BE:
			if (Z)pc += d;
			break;
		case BLT:
			if (S^V)pc += d;
			break;
		case BLE:
			if (Z || (S^V))pc += d;
			break;
		case BNE:
			if (!Z)pc += d;
			break;
		default:
			assert(false);
		}
		Operation::play(pc, r, m, Z, S, V, finish_flag);
	}
};



int main(int argc, char **argv) {
	if (argc != 2) {
		std::cout << "Usage: " << std::string(argv[0]) << " file" << std::endl;
		if (!DEBUG) {
			return 1;
		}
	}
	std::cout << argv[1] << std::endl;
	std::ifstream ifs(argv[1]);

	if (!ifs) {
		std::cout << "File not Found" << std::endl;
		return 1;
	}

	std::string buffer;
	int cur_address = 0;
	std::vector<std::shared_ptr<Operation>>ops;

	while (std::getline(ifs, buffer)) {
		if (buffer.size() > 16) {
			std::cout << "Line " << cur_address << " : size is bigger than 16" << std::endl;
			return 1;
		}
		else if (buffer.size() < 16) {
			std::cout << "Line " << cur_address << " : size is smaller than 16" << std::endl;
			std::cout << "Filled with 0 " << std::endl;
			while (buffer.size() < 16)buffer += '0';
		}
		else {
			if (all_of(buffer.begin(), buffer.end(), [](const char a) {
				return a == '0' || a == '1';
			})) {
				std::shared_ptr<Calc_put> op;
				int op1 = two_to_i(buffer.substr(0, 2));
				if (op1 == 3) {
					ops.push_back(std::make_shared<Calc_put>(buffer));
				}
				else if (op1 == 2) {
					int op2 = two_to_i(buffer.substr(2, 3));
					if (op2 == 7) {
						ops.push_back(std::make_shared<If>(buffer));
					}
					else {
						ops.push_back(std::make_shared<Imme_goto>(buffer));
					}
				}
				else {
					ops.push_back(std::make_shared<Load_store>(buffer));
				}
			}
			else {
				std::cout << "Please use binary file";
				return 1;
			}
		}
		cur_address++;
	}
	int nowclock = 0;
	int pc = 0;
	int Z, S, V;
	std::vector<int>r(8);
	std::vector<int>m(2048);
	std::random_device rnd;
	std::mt19937 mt(rnd());
	std::uniform_int_distribution<> randomizer(-32768, 32767);
	
	for (size_t k = 0; k < 3; ++k) {
		for (int i = 0; i < 1024; ++i) {
			m[i + 1024] = randomizer(mt);
		}
		if (k == 1)sort(m.begin() + 1024, m.begin() + 2048);
		if (k == 2)sort(m.begin() + 1024, m.begin() + 2048, std::greater<int>());
		if (k == 0)std::cout << "-----RANDOM -----" << std::endl;
		if (k == 1)std::cout << "-----GREATER-----" << std::endl;
		if (k == 2)std::cout << "-----LESS   -----" << std::endl;
		while (1) {
			bool finish_flag = false;
			if (pc >= static_cast<int>(ops.size())) {
				assert(false);
			}
			std::shared_ptr<Operation> nowop = ops[pc];
			nowop->play(pc, r, m, Z, S, V, finish_flag);
			nowclock++;

			if (finish_flag) {
				break;
			}
			if (nowclock > 1e7) {
				std::cout << "Infinite loop? over" << nowclock << " clock!" << std::endl;
				return 1;
			}
		}

		if (is_sorted(m.begin() + 1024, m.begin() + 1024 * 2)) {
			std::cout << "**Sorted**" << std::endl;
			std::cout << "Clock is " << nowclock << std::endl;
		}
		else {
			for (int i = 0; i < 1024; ++i) {
				std::cout << std::setw(6) << std::right << m[i + 1024];
				if (i % 8 == 7)std::cout << std::endl;
				else std::cout << " ";
			}
			std::cout << "Not Sorted" << std::endl;
			std::cout << "Clock is " << nowclock << std::endl;
			return 0;
		}
	}
	

	return 0;
}