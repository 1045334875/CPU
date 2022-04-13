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


module Datapath(
        input clk,
        input rst,
        input [1:0] pc_src,
        input reg_write,
        input alu_src_b,//ALUsrc
        input branch,//Branch
        input b_type,//bne/beq
        input [3:0] alu_op,
        input [1:0] mem_to_reg,
 // 2'b00 表示写回rd的数据来自ALU, 2'b01表示数据来自imm, 
 //2'b10表示数据来自pc+4, 2'b11 表示数据来自data memory
        input [31:0] inst,//instruction
        input [31:0]  data_in,
        output [31:0] addr_out,
        output [31:0] data_out,
        output [31:0] pc_out,//pcs
        output [31:0] registerdata
    );
   wire [31:0] read_data_1;
   wire [31:0] read_data_2;
   assign data_out = read_data_2;
   reg [31:0] pcc,addrr;
   reg [63:0] IF_ID;//[31:0] inst  [63:32] pc
   //ID: decode(control),register,
   reg [180:0] ID_EX;//[31:0]extend  [63:32] read data1
   // [95:64] read data2  [127:96] pc [131:127] write register 
   // [132] alu_src [136:133] alu_op [1:137
   assign pc_out = pcc;
   assign addr_out =ALUres;

   wire [31:0] nextpcc;
   wire [31:0] nextaddr;
   wire [31:0] writedata;
  assign  registerdata = writedata;
   always @(posedge clk or posedge rst) begin
       if(rst) begin
       pcc <= 32'b0;
       addrr <= 32'h00000004;
       end
       else begin
       pcc <= nextpcc;
       addrr <= nextaddr;
       end
   end
    Regs Regs(
    .clk(clk),
    .rst(rst),
    .we(reg_write),
    .read_addr_1(inst[19:15]),//4:0
    .read_addr_2(inst[24:20]),
    .write_addr(inst[11:7]),//4:0
    .write_data(writedata),//31:0
    .read_data_1(read_data_1),//output,31:0
    .read_data_2(read_data_2)
    );
    
    wire [31:0] ext;
    Extend Extend(
    .inst(inst),
    .haha(ext)
    );
    
    wire [31:0] mux1_out;
   assign  mux1_out=(alu_src_b)?ext:read_data_2;
    
    wire ALUzero;
    wire [31:0] ALUres;
    ALU alu1(
    .a(read_data_1),
    .b(mux1_out),
    .alu_op(alu_op),
    .res(ALUres),
    .zero(ALUzero)
    );
    assign nextaddr = ALUres;
    
    mux2 mux2(
    // 2'b00 表示写回rd的数据来自ALU, 2'b01表示数据来自imm, 2'b10表示数据来自pc+4, 2'b11 表示数据来自data memory
    .s(mem_to_reg),
    .I0(nextaddr),
    .I1(ext),
    .I2(pcc+4),
    .I3(data_in),
    .o(writedata)
    );
    
    wire [31:0] alu2res;
    assign alu2res = pcc+ext;
    wire [31:0] mux3res;
    mux3 mux3(
    .s(pc_src),
    .zero(ALUzero),
    .b_byte(b_type),
    .I0(pcc+4),
    .I1(alu2res),
    .I2(alu2res),
    .I3(alu2res),
    .o(nextpcc)
    );
    
endmodule
