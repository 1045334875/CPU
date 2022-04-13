module Control(
input clk,
input rst,
input [6:0] op_code,
input [2:0] funct3,
input funct7_5,
input [4:0] mfunct24_20,

output reg [2:0] pc_src,
output reg reg_write,
output reg reg1_read,
output reg reg2_read,
output reg alu_src_b,
output reg [3:0] alu_op,
output reg [1:0] mem_to_reg,
output reg mem_write,//
output reg [1:0] b_type,
output reg is_ld,
output reg [2:0] csraddr,
output reg [31:0] mcause,
output reg [1:0] dinsrc,
output reg csr_read,
output reg csr_write,
output reg [2:0] readcsraddr,
output reg illegal,
output reg mem_valid
);
`include "AluOp.vh"
always @* begin
    pc_src = 3'b000;
    // 2'b00 表示pc的数据来自pc+4, 2'b01 表示数据来自JALR跳转地址, 
    //2'b10表示数据来自JAL跳转地址(包括branch). branch 跳转根据条件决定,2'b11表示bne，看不为0就跳
    //3'b100表示数据来自ecall
    alu_src_b = 1'b0;//0是read_data2,1是imm
    alu_op = ADD;
    mem_to_reg = 2'b00;
     // 2'b00 表示写回rd的数据来自ALU, 2'b01表示数据来自imm, 
     //2'b10表示数据来自pc+4, 2'b11 表示数据来自data memory
    mem_write = 1'b0;
    reg_write = 1'b0;//默认要写寄存器
    reg1_read = 1'b0;
    reg2_read = 1'b0;
    b_type = 2'b00;
    is_ld = 1'b0;
    csraddr = 3'b000;
    mcause = 32'b0;
    dinsrc = 2'b01;
    csr_read = 1'b0;
    csr_write = 1'b0;
    readcsraddr = 3'b111;
    illegal = 1'b0;
    mem_valid = 1'b0; 
   
    case (op_code)
        7'b0010011: begin alu_src_b <= 1'b1; pc_src = 3'b000; reg_write = 1'b1; reg1_read = 1'b1; //addi,ori,slti,andi,xori,slli,sltu
            if(funct3 == 3'b000) alu_op = ADD;
            if(funct3 == 3'b001) alu_op = SLL;
            if(funct3 == 3'b010) alu_op = SLT;
            if(funct3 == 3'b011) alu_op = SLTU;
            if(funct3 == 3'b100) alu_op = XOR;
            if(funct3 == 3'b101) 
            begin   if(funct7_5 == 1'b0) alu_op = SRL;
                    if(funct7_5 == 1'b1) alu_op = SRA;
            end
            if(funct3 == 3'b110) alu_op = OR;
            if(funct3 == 3'b111) alu_op = AND;
            end // ADDI I
        
        7'b0110111: begin alu_src_b <= 1'b1; mem_to_reg = 2'b00; alu_op = LUI; reg1_read = 1'b0; reg_write = 1'b1; end // LUI  U
        7'b0110011: begin  alu_src_b = 1'b0; mem_to_reg = 2'b00; reg1_read = 1'b1; reg2_read = 1'b1; reg_write = 1'b1;//add or and slt sll xor,sltiu
            if(funct3 == 3'b000)
                begin   if(funct7_5 == 1'b0) alu_op = ADD;
                        if(funct7_5 == 1'b1) alu_op = SUB;
                end
            if(funct3 == 3'b001) alu_op = SLL;
            if(funct3 == 3'b010) alu_op = SLT;
            if(funct3 == 3'b011) alu_op = SLTU;
            if(funct3 == 3'b100) alu_op = XOR; 
            if(funct3 == 3'b101)
                begin   if(funct7_5 == 1'b0) alu_op = SRL;
                        if(funct7_5 == 1'b1) alu_op = SRA;
                end
            if(funct3 == 3'b110) alu_op = OR;
            if(funct3 == 3'b111) alu_op = AND;
            end 
        7'b0000011: begin pc_src = 3'b000; reg_write = 1'b1; alu_src_b = 1'b1; mem_to_reg = 2'b11; reg1_read = 1'b1; is_ld = 1'b1; mem_valid = 1'b1; end // LW   I
        7'b0100011: begin pc_src = 3'b000; reg_write = 1'b0; alu_src_b = 1'b1; mem_write = 1'b1; mem_to_reg = 2'b00; reg1_read = 1'b1; reg2_read = 1'b1; mem_valid = 1'b1; end // SW   S
        7'b0010111: begin pc_src = 3'b000; reg_write = 1'b1; alu_src_b = 1'b1; mem_to_reg = 2'b01; alu_op = ADD; reg1_read = 1'b0; end//auipc
        7'b1100111: begin pc_src = 3'b001; reg_write = 1'b1; alu_src_b = 1'b1;  mem_to_reg = 2'b10;alu_op = ADD; reg1_read = 1'b1; end//jalr
        7'b1101111: begin pc_src = 3'b010; reg_write = 1'b1; alu_op = ADD; alu_src_b = 1'b1; mem_to_reg = 2'b10; reg1_read = 1'b0; end // JAL
        7'b1100011: begin alu_op = SUB; reg_write = 1'b0; pc_src = 3'b011; alu_src_b = 1'b0; mem_to_reg = 2'b10; reg1_read = 1'b1; reg2_read = 1'b1;
            if(funct3 == 000)  b_type = 2'b00;//beq
            else if(funct3 == 001) b_type = 2'b01; // bne
            else if(funct3 == 111) b_type = 2'b10; alu_op=SLTU; end //bgeu end
        7'b1110011: begin
            if(funct3 == 3'b000)
            begin  if(mfunct24_20 == 5'b00000) 
                    begin pc_src = 3'b100;dinsrc=2'b00; csraddr = 3'b010; readcsraddr=3'b001; mcause = 32'b1000000000000101;
                        csr_read = 1'b1;csr_write = 1'b1;end //ecall
                   else if(mfunct24_20 == 5'b00010) begin pc_src=3'b100; csraddr = 3'b010;
                    csr_read = 1'b1;csr_write = 1'b1;dinsrc=2'b01;mcause = 32'b1011;/*readcsraddr=3'b010; */end// mret;
            end//dinsrc 2'b00 来自pc，ecall里面, 2'b01 表示来自wb_write_data，ecall里面
            else if(funct3 == 3'b001) begin csr_write = 1'b1; csr_read = 1'b0;pc_src = 2'b00; reg_write = 1'b0;dinsrc=2'b01;reg1_read = 1'b1;alu_op = ADD; alu_src_b = 1'b1; mem_to_reg = 2'b00; end//csrw
            else if(funct3 == 3'b010) begin csr_read = 1'b1;reg_write = 1'b1;pc_src = 2'b00;reg1_read = 1'b1; end//csrr
            else if(funct3 == 3'b011) begin csr_read = 1'b1;csr_write = 1'b1; alu_op = OR; reg1_read = 1'b1; end//csrc
            /*else if(funct3 == 3'b101) begin end//csrwi
            else if(funct3 == 3'b110) begin end//csrri
            else if(funct3 == 3'b111) begin end//csrci*/
            end 
            
        default: begin mcause = 32'b10; csraddr = 3'b010;/* readcsraddr=3'b001;*/end//读mtvec，写mepc
    endcase
     
end
endmodule