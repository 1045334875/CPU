

module EX_MEM(
input clk,
input rst,
input [31:0] ex_pc,
input [31:0] ex_alu2res,
input [31:0] ex_read_data_2,
input [31:0] ex_ALUres,
input ex_ALUzero,
input [2:0] ex_pc_src,
input ex_reg_write,
input [1:0] ex_mem_reg,
input ex_mem_write,
input ex_b_byte,

output reg [31:0] mem_alu2res,
output reg [31:0] mem_write_data,
output reg [31:0] mem_ALUres,
output reg [31:0] mem_pc,
output reg [4:0] mem_write_register,
output reg [2:0] mem_pc_src,
output reg mem_reg_write,
output reg [1:0] mem_mem_reg,
output reg mem_mem_write,
output reg mem_b_byte
);

always @(posedge clk or posedge rst) begin
    if(rst) begin
    ex_pc <= 32'b0;
    end
    else begin
    mem_pc <= ex_pc;
    mem_alu2res <= ex_alu2res;
    mem_ALUres <= ex_ALUres;
    mem_write_data <= ex_read_data_2;
    mem_write_register <= ex_write_register;
    mem_pc_src <= ex_pc_src;
    mem_reg_write <= ex_reg_write;
    mem_mem_reg <= ex_mem_reg;
    mem_mem_write <= ex_mem_write;
    mem_b_byte <= ex_b_byte;
    end
end

endmodule
