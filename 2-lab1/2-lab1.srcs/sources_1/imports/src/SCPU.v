`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/17 14:47:40
// Design Name: 
// Module Name: Datapath
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module SCPU(
    input   clk,
    input   rst,
    input  [31:0] if_inst,
    input  [31:0] data_in,  // data from data memory\
    input cache_stall,
    input [5:0] debug_reg_addr,
    
    output [31:0] addr_out, // data memory address
    output [31:0] data_out, // data to data memory
    output [31:0] pc_out,   // connect to instruction memory
    output        mem_write,
    output        mem_valid,
    output [31:0] TAread_data,
    output [31:0] register_write
    
);

    //---------------Define start line------------------
    
    wire [31:0] if_pcc;
    wire [31:0] if_nextpcc;
    wire [31:0] if_nextaddr;
    
    wire bubble_stop;
    wire jmp_clear;
    wire [1:0] forwardA, forwardB;
    //---------------ID define start line------------------
    wire [31:0] id_pc, id_inst;
    wire [3:0] id_alu_op;
    wire [1:0] id_mem_reg;
    wire [2:0] id_pc_src;
    wire id_alu_src,  id_reg_write;
    wire [1:0] id_b_type;
    wire id_mem_read, id_mem_write,id_reg1_read, id_reg2_read;
    wire [31:0] id_read_data_1, id_read_data_2;
    wire [31:0] id_extend;
    wire [4:0] id_write_register;
    wire id_is_ld,id_mem_valid;
    wire id_bubble_clear;
    
 
    //---------------EX Define start line------------------
    wire [3:0] ex_alu_op;
    wire [1:0] ex_mem_reg;
    wire [2:0] ex_pc_src;
    wire ex_alu_src, ex_reg_write;
    wire [1:0]  ex_b_type;
    wire ex_mem_read,  ex_mem_write, ex_reg1_read, ex_reg2_read;
    wire [31:0] ex_read_data_1, ex_read_data_2, ex_pc;
    wire [31:0] ex_extend;
    wire [4:0] ex_write_register;
    wire [31:0] ex_alu2res,ex_ALUres,ex_mux1_out;
    wire ex_ALUzero;
    wire [31:0] aluMux1,aluMux2;
    wire [4:0] ex_read_reg_1, ex_read_reg_2;
    wire ex_is_ld,ex_mem_valid;
    wire ex_bubble_clear;
    
    //---------------MEM Define start line------------------
    wire [31:0] mem_alu2res, mem_mux1_out;
    wire mem_ALUzero;
    wire [1:0] mem_b_type;
    wire [31:0] mem_pc, mem_read_data, mem_write_data;
    wire [31:0] mem_ALUres;
    wire [4:0] mem_write_register;
    wire [1:0] mem_mem_reg;
    wire [2:0] mem_pc_src;
    wire mem_reg_write, mem_mem_write, mem_mem_read;
    wire [31:0] mem_nextpc;
    wire mem_is_ld, mem_mem_valid;
    wire mem_bubble_clear;
    
    //---------------WB Define start line------------------
    wire [31:0] wb_pc, wb_read_data, wb_write_data;
    wire [31:0] wb_ALUres,wb_alu2res;
    wire [4:0] wb_write_register;
    wire wb_reg_write;
    wire [1:0] wb_mem_reg;
    wire wb_bubble_clear;
    
    //---------------Define end line------------------
    
    wire [1:0] din_src;
    
    
    wire [31:0] id_din,id_csr_dout; 
    //wire [31:0] ex_din, mem_din, wb_din;
    wire [31:0] forwardBin;
    wire [31:0] ex_csr_dout,mem_csr_dout,wb_csr_dout;//读出的值
    wire [31:0] csr_forward;
    wire id_csr_write,id_csr_read;  
    wire ex_csr_write,ex_csr_read;
    wire mem_csr_write,mem_csr_read;
    wire wb_csr_write,wb_csr_read;
    wire [2:0] id_addrCSR,ex_addrCSR,mem_addrCSR,wb_addrCSR;
    wire [31:0] id_mcause,ex_mcause,mem_mcause,wb_mcause;
    reg [31:0] id_csr_out;
    wire [2:0] csraddr_ecall,id_ecall,ex_ecall,mem_ecall;
    wire [2:0] readcsraddr,ex_readcsraddr,mem_readcsraddr;
   //---------------IF start line------------------

    
assign pc_out = if_pcc;
IF IF(
   .clk(clk),
   .rst(rst),
   .if_nextpcc(if_nextpcc),
   .bubble_stop(bubble_stop),
   .if_pcc(if_pcc),
   .jmp_clear(jmp_clear),
   .cache_stall(cache_stall)
); 
    
    //choose pc

pcmux pcmux(
    .s(mem_pc_src),
    .zero(mem_ALUzero),
    .b_byte(mem_b_type),
    .I0(if_pcc+4),
    .I1(mem_ALUres),
    .I2(mem_alu2res),//pc+ext
    .I3(mem_alu2res),
    .I4(mem_ALUres),
    .ecall(mem_ecall),
    .bubble(mem_bubble_clear),
    .o(if_nextpcc),
    .clear_out(jmp_clear)  
    );

    // 2'b00 表示pc的数据来自pc+4, 2'b01 表示数据来自JALR跳转地址, 
    // 2'b10表示数据来自JAL跳转地址(包括branch). branch 跳转根据条件决定,2'b11表示bne，看不为0就跳

    
 //---------------IF end line------------------

IF_ID IF_ID(
    .clk(clk),
    .rst(rst),
    .if_pc(if_pcc),
    .if_inst(if_inst),
    .id_pc(id_pc),
    .id_inst(id_inst),
    .bubble_stop(bubble_stop),
    .jmp_clear(jmp_clear),
    .id_bubble_clear(id_bubble_clear),
    .cache_stall(cache_stall)
);

//---------------ID start line------------------
//wire [31:0] TAread_data;
Regs Regs(
    .clk(clk),
    .rst(rst),
    .we(wb_reg_write),
    .read_addr_1(id_inst[19:15]),//4:0
    .read_addr_2(id_inst[24:20]),
    .write_addr(wb_write_register),//4:0
    .write_data(wb_write_data),//31:0
    .read_data_1(id_read_data_1),//output,31:0
    .read_data_2(id_read_data_2),
    .debug_reg_addr(debug_reg_addr),
    .TAread_data(TAread_data)
);
    
    assign  id_write_register = id_inst[11:7];

Control control ( 
    .clk(clk),
    .rst(rst),
    .op_code(id_inst[6:0]),
    .funct7_5(id_inst[30]),
    .funct3(id_inst[14:12]),
    .mfunct24_20(id_inst[24:20]),
    // 2'b00 表示pc的数据来自pc+4, 2'b01 表示数据来自JALR跳转地址, 2'b10表示数据来自JAL跳转地址(包括branch). branch 跳转根据条件决定
    .reg_write(id_reg_write),   // 1'b1 表示写寄存器
    .pc_src(id_pc_src),
    .alu_src_b(id_alu_src),   // 1'b1 表示ALU B口的数据源来自imm, 1'b0表示数据来自Reg[rs2]
    .alu_op(id_alu_op),         // 用来控制ALU操作，具体请看AluOp.vh中对各个操作的编码
    .mem_to_reg(id_mem_reg), // 2'b00 表示写回rd的数据来自ALU, 2'b01表示数据来自imm, 2'b10表示数据来自pc+4, 2'b11 表示数据来自data memory
    .mem_write(id_mem_write),   // 1'b1 表示写data memory, 1'b0表示读data memory
    .b_type(id_b_type),          // 1'b1 表示beq, 1'b0 表示bne
    .reg1_read(id_reg1_read),
    .reg2_read(id_reg2_read),
    .is_ld(id_is_ld), //ld need to insert 3 bubbles
   // .mstatus(id_mstatus),
    .dinsrc(din_src),
    .csraddr(csraddr_ecall),
    .csr_read(id_csr_read),
    .csr_write(id_csr_write),
    .readcsraddr(readcsraddr),
    .mem_valid(id_mem_valid)
);


stallControl stallControl(
    .clk(clk),
    .rst(rst),
    .ex_is_ld(ex_is_ld),
    //.jmp_clear(jmp_clear),
   // .mem_pc_src(mem_pc_src),
   // .zero(mem_ALUzero),
    .id_reg1_read(id_reg1_read),
    .id_reg2_read(id_reg2_read),
    .id_read_reg_1(id_inst[19:15]),
    .id_read_reg_2(id_inst[24:20]),
    .ex_reg_write(ex_reg_write),
    .ex_write_register(ex_write_register),
    .readcsraddr(mem_readcsraddr),
    .bubble_stop(bubble_stop)
);
    
Extend Extend(
    .inst(id_inst),
    .instruction(id_extend)
);

    
mux2 dinmux(
    // 2'b00 来自pc，ecall里面, 2'b01 表示来自wb_write_data，里面
    // 2'b10表示数据来mcause,ecall
    .s(din_src),
    .I0(wb_pc),//
    .I1(wb_write_data),
    .I2(wb_pc),
    .I3(wb_pc),
    .o(id_din)
);
 
trans_addrCSR trans_addrCSR(
    .clk(clk),
    .rst(rst),
    .id_inst(id_inst[31:20]) ,
    .csraddr_ecall(csraddr_ecall),
    .id_addrCSR(id_addrCSR)
); 
//forwarding,如果读csr的但是还没写入

wire [2:0] readcsr;
assign readcsr = (readcsraddr==3'b111 ? id_addrCSR : readcsraddr);

wire [31:0] new_id_csr_dout;                    
CSR CSR(
    .clk(clk),
    .rst(rst),
    .read_addrCSR(readcsr),
    .csr_read(id_csr_read),
    
    .write_addrCSR(wb_addrCSR),
    .csr_write(wb_csr_write),
    .din(wb_write_data),
    .mcause(mem_mcause),
    .dout(new_id_csr_dout),
    .readcsraddr(mem_readcsraddr),
    .ex_pc(mem_pc)
);



//---------------ID end line------------------

ID_EX id_ex(
    .clk(clk),
    .rst(rst),
    .id_extend(id_extend),
    .id_read_data_1(id_read_data_1[31:0]),
    .id_read_data_2(id_read_data_2[31:0]),
    .id_pc(id_pc),//32
    .id_write_register(id_write_register),//32
    .id_pc_src(id_pc_src),//2
    .id_reg_write(id_reg_write),//1
    .id_alu_src(id_alu_src),//1
    .id_alu_op(id_alu_op),//4
    .id_mem_reg(id_mem_reg),//2
    .id_mem_write(id_mem_write),//1
    .id_b_type(id_b_type), //1
    .id_reg1_read(id_reg1_read),
    .id_reg2_read(id_reg2_read),
    .id_read_reg_1(id_inst[19:15]),
    .id_read_reg_2(id_inst[24:20]),
    .id_is_ld(id_is_ld),
    .id_readcsraddr(readcsraddr),
    .id_bubble_clear(bubble_stop),
    
    .id_mcause(id_mcause),
    .id_addrCSR(id_addrCSR),
    .id_csr_read(id_csr_read),
    .id_csr_write(id_csr_write),
    .id_csr_dout(new_id_csr_dout),
    .id_ecall(csraddr_ecall),
    .jmp_clear(jmp_clear),
    .id_mem_valid(id_mem_valid),

    .ex_extend(ex_extend),
    .ex_read_data_1(ex_read_data_1),
    .ex_read_data_2(ex_read_data_2),
    .ex_pc(ex_pc),
    .ex_write_register(ex_write_register),
    .ex_pc_src(ex_pc_src),
    .ex_reg_write(ex_reg_write),
    .ex_alu_src(ex_alu_src),
    .ex_alu_op(ex_alu_op),
    .ex_mem_reg(ex_mem_reg),
    .ex_mem_write(ex_mem_write),
    .ex_b_type(ex_b_type),
    .ex_reg1_read(ex_reg1_read), 
    .ex_reg2_read(ex_reg2_read),
    .ex_read_reg_1(ex_read_reg_1),
    .ex_read_reg_2(ex_read_reg_2),
    .ex_is_ld(ex_is_ld),
    .ex_bubble_clear(ex_bubble_clear),
    
    .ex_addrCSR(ex_addrCSR),
    .ex_csr_read(ex_csr_read),
    .ex_csr_write(ex_csr_write),
    .ex_csr_dout(ex_csr_dout),
    .ex_ecall(ex_ecall),
    .ex_readcsraddr(ex_readcsraddr),
    .ex_mcause(ex_mcause),
    .cache_stall(cache_stall),
    .ex_mem_valid(ex_mem_valid)
);

//---------------EX start line------------------
  
  wire [1:0] forwardCSR;
   
forwardingControl forward(
    .clk(clk),
    .rst(rst),
    .ex_read_reg_1(ex_read_reg_1),
    .ex_read_reg_2(ex_read_reg_2),
    .ex_reg1_read(ex_reg1_read),
    .ex_reg2_read(ex_reg2_read),
    .ex_bubble_clear(ex_bubble_clear),
    .wb_write_reg(wb_write_register),
    .wb_reg_write(wb_reg_write),
    .wb_bubble_clear(wb_bubble_clear),
    .mem_write_reg(mem_write_register),
    .mem_reg_write(mem_reg_write),
    .mem_bubble_clear(mem_bubble_clear),
    .forwardA(forwardA),
    .forwardB(forwardB),
    .ex_csr_read(ex_csr_read),
    .ex_csr_read_addr(ex_addrCSR),
    .mem_csr_write(mem_csr_write),
    .mem_csr_write_addr(mem_addrCSR),
    .wb_csr_write(mem_csr_write),
    .wb_csr_write_addr(mem_addrCSR),
    .forwardCSR(forwardCSR)
);
wire [31:0] forward_memdata;
assign forward_memdata=(mem_mem_reg==2'b01 ? mem_alu2res : mem_ALUres);

mux2 forwardMuxA(
    // 2'b00 表示ALU的第一个操作数来自寄存器, 2'b01 表示数据来自mem冒险
    // 2'b10表示数据来自mem的alures即ex阶段冒险, 2'b11
    .s(forwardA),
    .I0(ex_read_data_1),//
    .I1(wb_write_data),
    .I2(forward_memdata),
    .I3(wb_read_data),
    .o(aluMux1)
);


mux2 forwardMuxCSR(
    .s(forwardCSR),
    .I0(ex_csr_dout),
    .I1(wb_write_data),
    .I2(forward_memdata),
    .I3(ex_csr_dout),
    .o(csr_forward)
    );
    
assign forwardBin=(ex_csr_read)?csr_forward:ex_read_data_2;    

mux2 forwardMuxB(
    .s(forwardB),
    .I0(forwardBin),//alures 
    .I1(wb_write_data),
    .I2(forward_memdata),
    .I3(ex_csr_dout),
    .o(aluMux2)
);
   assign  ex_mux1_out = (ex_alu_src)? ex_extend : aluMux2;     
   
ALU alu1(
    .a(aluMux1),
    .b(ex_mux1_out),
    .alu_op(ex_alu_op),
    .res(ex_ALUres),
    .zero(ex_ALUzero)
);

    assign ex_alu2res = ex_pc + ex_extend; 
    

//---------------EX end line------------------

EX_MEM ex_mem(
    .clk(clk),
    .rst(rst),
    .ex_pc(ex_pc),
    .ex_alu2res(ex_alu2res),
    .ex_write_data(aluMux2),
    .ex_ALUres(ex_ALUres),
    .ex_ALUzero(ex_ALUzero),
    .ex_write_register(ex_write_register),
    .ex_pc_src(ex_pc_src),
    .ex_reg_write(ex_reg_write),
    .ex_mem_reg(ex_mem_reg),
    .ex_mem_write(ex_mem_write),
    .ex_b_type(ex_b_type),
    .ex_bubble_clear(ex_bubble_clear),
    .ex_addrCSR(ex_addrCSR),
    .ex_csr_read(ex_csr_read),
    .ex_csr_write(ex_csr_write),
    .ex_csr_dout(ex_csr_dout),
    .ex_ecall(ex_ecall),
    .ex_mcause(ex_mcause),
    .ex_readcsraddr(ex_readcsraddr),
    .jmp_clear(jmp_clear),
    .ex_mem_valid(ex_mem_valid),
    
    
    .mem_alu2res(mem_alu2res),
    .mem_pc(mem_pc),
    .mem_write_data(mem_write_data),
    .mem_ALUres(mem_ALUres),
    .mem_ALUzero(mem_ALUzero),
    .mem_write_register(mem_write_register),//32
    .mem_pc_src(mem_pc_src),//2
    .mem_reg_write(mem_reg_write),//1
    .mem_mem_reg(mem_mem_reg),//2
    .mem_mem_write(mem_mem_write),//1
    .mem_b_type(mem_b_type), //1
    .mem_bubble_clear(mem_bubble_clear),
    .mem_addrCSR(mem_addrCSR),
    .mem_csr_read(mem_csr_read),
    .mem_csr_write(mem_csr_write),
    .mem_csr_dout(mem_csr_dout),
    .mem_ecall(mem_ecall),
    .mem_mcause(mem_mcause),
    .mem_readcsraddr(mem_readcsraddr),
    .cache_stall(cache_stall),
    .mem_mem_valid(mem_mem_valid)
);

//---------------MEM start line------------------

    assign addr_out = mem_ALUres;
    assign data_out = mem_write_data;
    assign mem_write = mem_mem_write;
    assign mem_valid = mem_mem_valid;
    assign mem_read_data = data_in;
    
    
//---------------MEM end line------------------


MEM_WB mem_wb(
    .clk(clk),
    .rst(rst),
    .mem_pc(mem_pc),
    .mem_reg_write(mem_reg_write),
    .mem_write_register(mem_write_register),
    .mem_read_data(mem_read_data),
    .mem_ALUres(mem_ALUres),
    .mem_mem_reg(mem_mem_reg),
    .mem_addrCSR(mem_addrCSR),
    .mem_csr_read(mem_csr_read),
    .mem_csr_write(mem_csr_write),
    .mem_alu2res(mem_alu2res),
    .mem_bubble_clear(mem_bubble_clear),

    .wb_pc(wb_pc),
    .wb_reg_write(wb_reg_write),
    .wb_alu2res(wb_alu2res),
    .wb_write_register(wb_write_register),
    .wb_read_data(wb_read_data),
    .wb_ALUres(wb_ALUres),
    .wb_mem_reg(wb_mem_reg),
    .wb_bubble_clear(wb_bubble_clear),
    .wb_addrCSR(wb_addrCSR),
    .wb_csr_read(wb_csr_read),
    .wb_csr_write(wb_csr_write),
    .cache_stall(cache_stall)
);

//---------------WB start line------------------
mux2 mux2(
   // 2'b00 表示写回rd的数据来自ALU, 2'b01写回pc+imm,
   // 2'b10表示数据来自pc+4, 2'b11 表示数据来自data memory
   .s(wb_mem_reg),
   .I0(wb_ALUres),//alures
   .I1(wb_alu2res),
   .I2(wb_pc+4),
   .I3(wb_read_data),
   .o(wb_write_data)
);
   
assign register_write = wb_write_data;
//---------------WB end line------------------
  
endmodule
