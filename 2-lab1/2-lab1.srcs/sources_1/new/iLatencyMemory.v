`timescale 1ns / 1ps

module iLatencyMemory(
    input clk,
    input rst,
    input en,
    input we,
    input [10:0] addr, 
    input [31:0] data_in,
    output [31:0] data_out,
    output clk_latency_out
);
    wire clk_latency;
	reg [31:0] clkdiv = 0; 


    assign clk_latency = clkdiv[3]; // latency memory clock

        
always @ (posedge clk )begin
    if (rst) clkdiv <= 0;
    else clkdiv <= clkdiv + 1;
end

mem_valid_sig imem_valid_sig(
    .clk_latency(clk_latency),
    .clk(clk),
    .rst(rst),
    .mem_valid(clk_latency_out)
);
  wire [31:0] out_out;
  assign data_out =  out_out ;
  // TODO: Á¬½ÓInstruction Memory

  
BRAM2 Instruction(
    .clka(clk_latency),
  //  .rsta(rst),
    .wea(we),
    .addra(addr), 
    .dina(data_in[31:0]),
    .douta(out_out[31:0])
);
endmodule
