`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/10/28 10:19:06
// Design Name: 
// Module Name: stallControl
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


module stallControl(
input clk,
input rst,
input ex_is_ld,
//input jmp_clear,
//input [2:0] mem_pc_src,
//input zero;
input [4:0] id_read_reg_1,
input  id_reg1_read,
input ex_reg_write,
input id_reg2_read,
input [4:0] id_read_reg_2,
input [4:0] ex_write_register,
input [2:0] readcsraddr,
output wire bubble_stop
);

reg [31:0] bubble;    
wire hazard, pc_valid, stall_valid,valid1,valid2;


//assign pc_valid = (bubble_stop==1'b1 ? 1'b0 : (mem_pc_src == 3'b000)? 1'b1:1'b0);
assign valid1 = (/*ex_reg_write&&id_reg1_read && */id_read_reg_1 ==ex_write_register)? 1'b1:1'b0;
assign valid2 = (/*ex_reg_write&&id_reg2_read &&*/ id_read_reg_2 ==ex_write_register)? 1'b1:1'b0;

assign hazard = valid1||valid2;
assign  stall_valid = (ex_is_ld && hazard) ? 1'b1:1'b0 ;
assign bubble_stop = (readcsraddr==3'b111) ? stall_valid:1'b0;
//assign bubble_stop = (bubble==32'b0)?1'b0:1'b1;

/*
always @(posedge clk) begin
    if(stall_valid)  bubble <= 1;
    else if(bubble) bubble <= bubble - 1;
    else bubble<= 32'b0;
end*/
endmodule
