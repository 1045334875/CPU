//`ifndef ALUOP_H
//`define ALUOP_H
parameter   ADD  = 4'b0000,
            SUB  = 4'b1000,
			SLL  = 4'b0001,
			SLT  = 4'b0010,
			SLTU = 4'b0011,
			XOR  = 4'b0100,
			SRL  = 4'b0101,
			SRA  = 4'b1101,
			OR   = 4'b0110,
			AND  = 4'b0111,
			LUI  = 4'b1111;

//parameter  S_IDLE = 3'b000,
 //           S_BACK = 3'b001,
//            S_BACK_WAIT = 3'b010,
 //           S_FILL = 3'b011,
 //           S_FILL_WAIT = 3'b100;*/
//`endif