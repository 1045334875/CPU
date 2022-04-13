`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/17 17:20:20
// Design Name: 
// Module Name: extend
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


module Extend(
    input [31:0] inst,
    output [31:0] instruction
    );
     
    reg [31:0] extend;
    wire [31:0] hahaha;
    assign instruction = extend;   
    wire [31:0] Immgen;
    wire [31:0] Smmgen;
    wire [31:0] Bmmgen;
    wire [31:0] Jmmgen;
    wire [31:0] Ummgen;
    
    Iextend Iextend(
    .i(inst[31:20]),
    .o(Immgen)
    );
    Sextend Sextend(
    .i({inst[31:25],inst[11:7]}),
    .o(Smmgen)
    );
    Bextend Bextend(
    .i({inst[31],inst[7],inst[30:25],inst[11:8]}),
    .o(Bmmgen)
    );
    Jextend Jextend(
    .i({inst[31],inst[19:12],inst[20],inst[30:21]}),
    .o(Jmmgen)
    );
    Uextend Uextend(
    .i(inst[31:12]),
    .o(Ummgen)
    );

    always @(*)
        case (inst[6:0])
            7'b0010011: extend <= Immgen;//addi R
            7'b0110011: extend <= Immgen;//add
            7'b0000011: extend <= Immgen;//lw I
            7'b0100011: extend <= Smmgen;//sw S
            7'b1100011: extend <= Bmmgen;//beq B
            7'b1100111: extend <= Immgen;//jalr I
            7'b1101111: extend <= Jmmgen;//jal J
            7'b0110111: extend <= Ummgen;//lui U
            7'b0010111: extend <= Ummgen;//U
            default: extend = 0;
        endcase
       
endmodule
