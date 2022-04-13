`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/18 00:37:08
// Design Name: 
// Module Name: mux2
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


module pcmux(
input [2:0] s,
input [1:0] b_byte,
input [31:0] I0,
input [31:0] I1,
input [31:0] I2,
input [31:0] I3,
input [31:0] I4,
input [2:0] ecall,
input zero,
input bubble,
output clear_out,
output reg [31:0] o
    );
    
reg [1:0] clear;    
// 2'b00 表示pc的数据来自pc+4, 2'b01 表示数据来自JALR跳转地址, 
// 2'b10表示数据来自JAL跳转地址(包括branch). 
//branch 跳转根据条件决定,2'b11表示bne，看不为0就跳
 assign clear_out = (clear==2'b10)?1'b1:1'b0;
 
wire [31:0] I0in;
assign I0in=(bubble==1'b0)?I0:I0-4;
//如果不跳转那就看看是不是buble，跳转优先，是bubble就不跳转了

wire bgeu=(!I1)|zero;//小于为1
//j优先，bubble之后
    always @(*) 
    
    case(s)
    3'b000: begin o <= I0in;
        if(clear!=0) clear=clear-1;
        else clear <= 2'b00; 
    end
    3'b001: begin o <= I1; clear <= 2'b10; end
    3'b010: begin o <= I2; clear <= 2'b10; end
    3'b100: begin o <= I4; clear <= 2'b10; end
    3'b011: begin  
         if(b_byte==2'b00 && zero == 1'b1) begin o <= I3; clear <= 2'b10; end//beq
         else if(b_byte==2'b01 && zero == 1'b0) begin o <= I3; clear <= 2'b10; end//bne
         else if(b_byte==2'b10 && bgeu) begin o <= I3; clear <= 2'b10; end//bgeu
         else o <= I0in;
    end
    
    endcase

endmodule
