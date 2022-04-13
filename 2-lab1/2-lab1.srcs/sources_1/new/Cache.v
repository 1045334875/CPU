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


module Cache(
    input clk,
    input rst,
    input [10:0] cache_req_addr,//流水线读写地址
    input [31:0] cache_req_data,//流水线写数据
    input cache_req_wen,    //cache要写
    input cache_req_valid,  //是否要读写
    input set_dirty,      //写入数据之后将dirty置1
    output [31:0] cache_resp_data,//给流水线的数据
    
    output [10:0] mem_req_addr,//给memory的读写地址
    output [31:0] mem_req_data,//memory写数据
    
    input [31:0] mem_resp_data,//memory读取的数据返回
    input mem_resp_valid,    //数据是否有效
    
    output hit,
    output dirty_out,
    output miss,
    
    input [6:0] debug_index,
    output [31:0] debug_out_data,
    output [31:0] debug_out_sig
);
integer i;
reg [31:0] data [0:127]; 
reg [3:0] tags [0:127];
reg dirty [0:127];
reg valid [0:127];

wire [6:0] index;
wire [3:0] tag;

assign index = cache_req_addr[6:0];//输入的地址index
assign tag = cache_req_addr[10:7];//输入的地址tag

wire tag_equal = (tag == tags[index]);
assign hit = cache_req_valid ? ((valid[index] == 1) && tag_equal):1'b0;//hit
assign miss = cache_req_valid ? ((valid[index] == 1'b0) || (tag != tags[index])):1'b0;//miss
assign dirty_out = cache_req_valid ? dirty[index] : 1'b0;//当要往里写的时候才会看会不会

assign mem_req_data = data[index];//要存入memory中的数据
wire [10:0] last_addr ;
assign last_addr = {tags[index], index};
assign mem_req_addr =(dirty_out ? last_addr: cache_req_addr[10:0]);//要存入memory的地址
assign cache_resp_data = data[index];//读出的数值

assign debug_out_data = data[debug_index];

wire dirty_debug_index = dirty[debug_index];
wire valid_debug_index = valid[debug_index];
wire [3:0] tags_debug_index = tags[debug_index];
assign debug_out_sig = {dirty_debug_index, valid_debug_index,19'b0,tags_debug_index , debug_index};


always @(posedge clk or posedge rst) begin
    if(rst) begin
        for (i = 0; i <= 127; i = i + 1) begin
            data[i] <= 0; // reset
            tags[i] <= 4'b0;
            valid[i] <= 1'b0;
            dirty[i] <= 1'b0;
        end
    end
    else if(set_dirty) dirty[index] <= 1'b1;
    else if(cache_req_wen) begin //写入数据时不管要不要存回memory都是把cpu的值写入cache
        data[index] <= cache_req_data;
        tags[index][3:0] <= tag[3:0];
        dirty[index] <= 1'b1;
        valid[index] <= 1'b1;
    end
    else if(mem_resp_valid) begin
        data[index] <= mem_resp_data;//读出数据时是从memory读出写入，数据存入
        tags[index][3:0] <= tag[3:0];
        dirty[index] <= 1'b0;
        valid[index] <= 1'b1;
    end
end
endmodule
