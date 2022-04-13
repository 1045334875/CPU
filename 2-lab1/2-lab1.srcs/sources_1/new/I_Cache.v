`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/19 13:09:18
// Design Name: 
// Module Name: Cache
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


module I_Cache(
    input clk,
    input rst,
    input [10:0] icache_req_addr,//流水线读写地址
    input [31:0] icache_req_data,//流水线写数据
    input icache_req_wen,    //cache要写
    input icache_req_valid,  //是否要读写
    input iset_dirty,      //写入数据之后将dirty置1
    output [31:0] icache_resp_data,//给流水线的数据
    
    output [10:0] imem_req_addr,//给memory的读写地址
    output [31:0] imem_req_data,//memory写数据
    
    input [31:0] imem_resp_data,//memory读取的数据返回
    input imem_resp_valid,    //数据是否有效
    
    output ihit,
    output idirty_out,
    output imiss
);
integer i;
reg [31:0] data [0:127]; 
reg [3:0] tags [0:127];
reg dirty [0:127];
reg valid [0:127];

wire [6:0] index;
wire [3:0] tag;

assign index = icache_req_addr[6:0];//输入的地址index
assign tag = icache_req_addr[10:7];//输入的地址tag

assign ihit = icache_req_valid ? ((valid[index] == 1) && (tag == tags[index])):1'b0;//hit
assign imiss = icache_req_valid ? ((valid[index] == 1'b0) || (tag != tags[index])):1'b0;//miss
assign idirty_out = icache_req_valid ? dirty[index] : 1'b0;//当要往里写的时候才会看会不会

assign imem_req_data = data[index];//要存入memory中的数据
wire [10:0] last_addr ;
assign last_addr = { tags[index], index};
assign imem_req_addr =(idirty_out ? last_addr: icache_req_addr[10:0]);//要存入memory的地址
assign icache_resp_data = data[index];//读出的数值

always @(posedge clk or posedge rst) begin
    if(rst) begin
        for (i = 0; i <= 127; i = i + 1) begin
            data[i] <= 0; // reset
            tags[i] <= 4'b0;
            valid[i] <= 1'b0;
            dirty[i] <= 1'b0;
        end
    end
    else if(iset_dirty) dirty[index] <= 1'b1;
    else if(icache_req_wen) begin //写入数据时不管要不要存回memory都是把cpu的值写入cache
        data[index] <= icache_req_data;
        tags[index] <= tag;
        dirty[index] <= 1'b1;
        valid[index] <= 1'b1;
    end
    else if(imem_resp_valid) begin
        data[index] <= imem_resp_data;//读出数据时是从memory读出写入，数据存入
        tags[index] <= tag;
        dirty[index] <= 1'b0;
        valid[index] <= 1'b1;
    end
end
endmodule
