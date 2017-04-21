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

const int REGISTER_SIZE = 8;
const int MAIN_MEMORY_SIZE = 2048;

const int REGISTER_BIT = 16;
const int REGISTER_MAX = (1 << (REGISTER_BIT - 1)) - 1;
const int REGISTER_MIN = -(1 << (REGISTER_BIT - 1));



int two_to_i(std::string st) {
	int sum = 0;
	for (size_t i = 0; i < st.size(); ++i) {
		sum *= 2;
		sum += st[i] - '0';
	}
	return sum;
}

struct Data {
	int pc;
	std::vector<int>reg;
	std::vector<int>main_mem;
	struct Flags {
		bool z;//is zero?
		bool s;//is smaller than zero?
		bool c;//is carried over?
		bool v;//is overflow?
		Flags() :z(false), s(false), c(false), v(false) {

		}
	}flags;
	bool finish_flag;
	Data() :pc(0),reg(REGISTER_SIZE), main_mem(MAIN_MEMORY_SIZE),flags(),finish_flag(false) {

	}
};

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
	virtual void play(Data&mem) {
		mem.pc++;
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

	void f_check(int& result,Data::Flags&flags) {
		if (result > REGISTER_MAX) {
			result -= (REGISTER_MAX - REGISTER_MIN + 1);
			flags.v = true; flags.c = true;
		}
		if (result < REGISTER_MIN) {
			result += (REGISTER_MAX - REGISTER_MIN + 1);
			flags.v = true; flags.c = true;
		}
		if (result < 0)flags.s = true;
		if (result == 0)flags.z = true;
	}

	int f_add(const int l,const int r,Data::Flags&flags) {
		int result = l + r;
		f_check(result, flags);
		return result;
	}
	int f_sub(const int l, const int r, Data::Flags&flags) {
		int result = l - r;
		f_check(result, flags);
		return result;
	}
	int f_and(const int l, const int r, Data::Flags&flags) {
		int result = l&r;
		f_check(result, flags);
		return result;
	}
	int f_or(const int l, const int r, Data::Flags&flags) {
		int result = l | r;
		f_check(result, flags);
		return result;
	}
	int f_xor(const int l, const int r, Data::Flags&flags) {
		int result = l^r;
		f_check(result, flags);
		return result;
	}
	int f_mov(const int l, const int r, Data::Flags&flags) {
		int result = r;
		f_check(result, flags);
		return result;
	}
	int f_sll(const int l,  Data::Flags&flags) {
		int result = l<<d;
		flags.c = static_cast<bool>(l&(1 << (REGISTER_BIT-d)));
		if (result < 0)flags.s = true;
		if (result == 0)flags.z = true;
		return result;
	}
	int f_slr(const int l,  Data::Flags&flags) {
		assert(REGISTER_BIT == 16);
		int result = (short(l << d) | short(l >> (REGISTER_BIT - d)));
		if (result < 0)flags.s = true;
		if (result == 0)flags.z = true;
		return result;
	}
	int f_srl(const int l,  Data::Flags&flags) {
		int result= static_cast<unsigned int>(l) >> d;
		flags.c = d>0?static_cast<bool>(l&(1 << ( d-1))):false;
		if (result < 0)flags.s = true;
		if (result == 0)flags.z = true;
		return result;
	}
	int f_sra(const int l, Data::Flags&flags) {
		int result = l >> d;
		flags.c = d>0 ? static_cast<bool>(l&(1 << (d - 1))) : false;
		if (result < 0)flags.s = true;
		if (result == 0)flags.z = true;
		return result;
	}

	virtual void play(Data&mem) {
		mem.flags.z = false;
		mem.flags.s = false;
		mem.flags.v = false;
		mem.flags.c = false;
		assert(op1 == IS_CALC_PUT);
		switch (op3){
		case ADD:
			mem.reg[rd] = f_add(mem.reg[rd], mem.reg[rs], mem.flags);
			break;

		case SUB:
			mem.reg[rd] = f_sub(mem.reg[rd], mem.reg[rs], mem.flags);
			break;

		case AND:
			mem.reg[rd] = f_and(mem.reg[rd], mem.reg[rs], mem.flags);
			break;

		case OR:
			mem.reg[rd] = f_or(mem.reg[rd], mem.reg[rs], mem.flags);
			break;

		case XOR:
			mem.reg[rd] = f_xor(mem.reg[rd], mem.reg[rs], mem.flags);
			break;

		case CMP: 
			f_sub(mem.reg[rd], mem.reg[rs], mem.flags);
			break;
				   
		case MOV:
			mem.reg[rd]=f_mov(mem.reg[rd], mem.reg[rs], mem.flags);
			break;

		case SLL:
			mem.reg[rd]=f_sll(mem.reg[rd],mem.flags);
			break;

		case SLR:
			mem.reg[rd] = f_slr(mem.reg[rd], mem.flags);
			break;

		case SRL:
			mem.reg[rd] = f_srl(mem.reg[rd], mem.flags);
			break;

		case SRA:
			mem.reg[rd] = f_sra(mem.reg[rd], mem.flags);
			break;

		case IN:
			assert(false);
			break;

		case OUT:
			break;

		case HLT:
			mem.finish_flag = true;
			break;

		default:
			assert(false);
			break;
		}
		
		Operation::play(mem);
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
	virtual void play(Data&mem) {
		mem.flags.z = false;
		mem.flags.s = false;
		mem.flags.v = false;
		mem.flags.c = false;
		switch (op1) {
		case LD:
			mem.reg[ra] = mem.main_mem[mem.reg[rb] + d];
			break;

		case ST:
			mem.main_mem[mem.reg[rb] + d] = mem.reg[ra];
			break;

		default:
			assert(false);
		}
		Operation::play(mem);
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
	virtual void play(Data&mem) {
		switch (op2) {
		case LI:
			mem.reg[rb] = d;
			break;

		case B:
			mem.pc += d;
			break;

		default:
			assert(false);
		}
		Operation::play(mem);
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
	virtual void play(Data&mem) {
		switch (cond) {
		case BE:
			if (mem.flags.z)mem.pc += d;
			break;

		case BLT:
			if (mem.flags.s^mem.flags.v)mem.pc += d;
			break;

		case BLE:
			if (mem.flags.z || (mem.flags.s^mem.flags.v))mem.pc += d;
			break;

		case BNE:
			if (!mem.flags.z)mem.pc += d;
			break;

		default:
			assert(false);
		}
		Operation::play(mem);
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
	//std::vector<int>r(8);
	std::random_device rnd;
	std::mt19937 mt(rnd());
	std::uniform_int_distribution<> randomizer(-32768, 32767);
	
	for (size_t k = 0; k < 3; ++k) {
		Data data;
		{

			std::vector<int>m(2048);
			for (int i = 0; i < 1024; ++i) {
				m[i + 1024] = randomizer(mt);
			}
			if (k == 1)sort(m.begin() + 1024, m.begin() + 2048);
			if (k == 2)sort(m.begin() + 1024, m.begin() + 2048, std::greater<int>());
			data.main_mem = m;
		}
		if (k == 0)std::cout << "-----RANDOM -----" << std::endl;
		if (k == 1)std::cout << "-----GREATER-----" << std::endl;
		if (k == 2)std::cout << "-----LESS   -----" << std::endl;
		while (1) {
			data.flags.c = false;
			assert(pc < static_cast<int>(ops.size()));
			std::shared_ptr<Operation> nowop = ops[data.pc];
			nowop->play(data);
			nowclock++;

			if (data.finish_flag) {
				break;
			}
			if (nowclock > 1e7) {
				std::cout << "Infinite loop? over" << nowclock << " clock!" << std::endl;
				return 1;
			}
		}

		if (is_sorted(data.main_mem.begin() + 1024, data.main_mem.begin() + 1024 * 2)) {
			std::cout << "**Sorted**" << std::endl;
			std::cout << "Clock is " << nowclock << std::endl;
		}
		else {
			for (int i = 0; i < 1024; ++i) {
				std::cout << std::setw(6) << std::right << data.main_mem[i + 1024];
				if (i % 8 == 7)std::cout << std::endl;
				else std::cout << " ";
			}
			std::cout << "Not Sorted" << std::endl;
			std::cout << "Clock is " << nowclock << std::endl;
			//return 0;
		}
	}
	

	return 0;
}