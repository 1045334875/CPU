`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/12/28 23:33:55
// Design Name: 
// Module Name: CSR
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


module CSR(
    input clk,
    input rst,
    input [2:0] read_addrCSR,
    input  csr_read,
    input [2:0] write_addrCSR,
    input  csr_write,
    input [31:0] mcause,
    input [31:0] din,
    input [2:0] readcsraddr,
    input [31:0] ex_pc,
    output [31:0] dout
    );
    
    
reg [31:0] csr [0:7];//mtvec,mtval,mcause, mstatus,mepc;
integer i;
assign dout = csr_read ? csr[read_addrCSR]:32'b0;

always @(negedge clk or posedge rst) begin 
    if (rst == 1) for (i = 0; i <= 7; i = i + 1) csr[i] <= 32'b0; // reset
    else begin 
        if(mcause!=0) csr[3]<=mcause;
        if (csr_write != 0) csr[write_addrCSR] <= din;
        if(readcsraddr!=3'b111) csr[2]<=ex_pc;
    end
end

endmodule
