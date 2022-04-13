

module EX_MEM(
input clk,
input rst,
input [31:0] ex_pc,
input [31:0] ex_alu2res,
input [31:0] ex_write_data,
input [31:0] ex_ALUres,
input ex_ALUzero,
input [2:0] ex_pc_src,
input ex_reg_write,
input [1:0] ex_mem_reg,
input ex_mem_write,
input [1:0] ex_b_type,
input [4:0] ex_write_register,
input ex_bubble_clear,
input jmp_clear,

output reg [31:0] mem_alu2res,
output reg [31:0] mem_write_data,
output reg [31:0] mem_ALUres,
output reg mem_ALUzero,
output reg [31:0] mem_pc,
output reg [4:0] mem_write_register,
output reg [2:0] mem_pc_src,
output reg mem_reg_write,
output reg [1:0] mem_mem_reg,
output reg mem_mem_write,
output reg [1:0] mem_b_type,
output reg mem_bubble_clear,

input [2:0] ex_addrCSR,
input ex_csr_read,
input ex_csr_write,
input [31:0] ex_csr_dout,
input [2:0] ex_ecall,
input [31:0] ex_mcause,
input [2:0] ex_readcsraddr,
output reg [2:0] mem_addrCSR,
output reg mem_csr_read,
output reg mem_csr_write,
output reg [31:0] mem_csr_dout,
output reg [2:0] mem_ecall,
output reg [31:0] mem_mcause,
output reg [2:0] mem_readcsraddr,
input cache_stall,
input ex_mem_valid,
output reg mem_mem_valid
);
reg run ;
always @(posedge clk or posedge rst) begin
    if(rst) begin
        mem_pc <= 32'b0;
        mem_alu2res <= 32'b0;
        mem_ALUres <= 32'b0;
        mem_write_data <= 32'b0;
        mem_write_register <= 5'b0;
        mem_pc_src <= 3'b000;
        mem_reg_write <= 1'b0;
        mem_mem_reg <= 2'b00;
        mem_mem_write <= 1'b0;
        mem_b_type <= 2'b00;
        mem_ALUzero <= 1'b0;
        mem_bubble_clear <= 1'b0;
        mem_addrCSR <=3'b0;
        mem_csr_read <= 1'b0;
        mem_csr_write <=1'b0;
        mem_csr_dout <= 32'b0;
        mem_ecall <= 3'b0;
        mem_mcause <= 32'b0;
        mem_readcsraddr <= 3'b111;
        mem_mem_valid <= 1'b0;
    end
    else if(cache_stall) begin end
    else if(jmp_clear) begin
        mem_pc <= ex_pc;
        mem_alu2res <= 32'b0;
        mem_ALUres <= 32'b0;
        mem_write_data <= 32'b0;
        mem_write_register <= 5'b0;
        mem_pc_src <= 3'b000;
        mem_reg_write <= 1'b0;
        mem_mem_reg <= 2'b00;
        mem_mem_write <= 1'b0;
        mem_b_type <= 2'b00;
        mem_ALUzero <= 1'b0;
        mem_bubble_clear <= 1'b0;
        mem_addrCSR <=3'b0;
        mem_csr_read <= 1'b0;
        mem_csr_write <=1'b0;
        mem_csr_dout <=32'b0;
        mem_ecall <= 3'b0;
        mem_mcause<=32'b0;
        mem_readcsraddr<=3'b111;
        mem_mem_valid <= 1'b0;
    end
    else begin
        mem_pc <= ex_pc;
        mem_alu2res <= ex_alu2res;
        mem_ALUres <= ex_ALUres;
        mem_write_data <= ex_write_data;
        mem_write_register <= ex_write_register;
        mem_pc_src <= ex_pc_src;
        mem_reg_write <= ex_reg_write;
        mem_mem_reg <= ex_mem_reg;
        mem_mem_write <= ex_mem_write;
        mem_b_type <= ex_b_type;
        mem_ALUzero <= ex_ALUzero;
        mem_bubble_clear <= ex_bubble_clear;
        mem_addrCSR <= ex_addrCSR;
        mem_csr_read <= ex_csr_read;
        mem_csr_write <=ex_csr_write;
        mem_csr_dout <= ex_csr_dout;
        mem_ecall <= ex_ecall;
        mem_mcause<= ex_mcause;
        mem_readcsraddr<=ex_readcsraddr;
        mem_mem_valid <= ex_mem_valid;
    end
end

endmodule
