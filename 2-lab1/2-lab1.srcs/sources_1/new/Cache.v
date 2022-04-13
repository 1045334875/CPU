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
    input [10:0] cache_req_addr,//��ˮ�߶�д��ַ
    input [31:0] cache_req_data,//��ˮ��д����
    input cache_req_wen,    //cacheҪд
    input cache_req_valid,  //�Ƿ�Ҫ��д
    input set_dirty,      //д������֮��dirty��1
    output [31:0] cache_resp_data,//����ˮ�ߵ�����
    
    output [10:0] mem_req_addr,//��memory�Ķ�д��ַ
    output [31:0] mem_req_data,//memoryд����
    
    input [31:0] mem_resp_data,//memory��ȡ�����ݷ���
    input mem_resp_valid,    //�����Ƿ���Ч
    
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

assign index = cache_req_addr[6:0];//����ĵ�ַindex
assign tag = cache_req_addr[10:7];//����ĵ�ַtag

wire tag_equal = (tag == tags[index]);
assign hit = cache_req_valid ? ((valid[index] == 1) && tag_equal):1'b0;//hit
assign miss = cache_req_valid ? ((valid[index] == 1'b0) || (tag != tags[index])):1'b0;//miss
assign dirty_out = cache_req_valid ? dirty[index] : 1'b0;//��Ҫ����д��ʱ��Żῴ�᲻��

assign mem_req_data = data[index];//Ҫ����memory�е�����
wire [10:0] last_addr ;
assign last_addr = {tags[index], index};
assign mem_req_addr =(dirty_out ? last_addr: cache_req_addr[10:0]);//Ҫ����memory�ĵ�ַ
assign cache_resp_data = data[index];//��������ֵ

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
    else if(cache_req_wen) begin //д������ʱ����Ҫ��Ҫ���memory���ǰ�cpu��ֵд��cache
        data[index] <= cache_req_data;
        tags[index][3:0] <= tag[3:0];
        dirty[index] <= 1'b1;
        valid[index] <= 1'b1;
    end
    else if(mem_resp_valid) begin
        data[index] <= mem_resp_data;//��������ʱ�Ǵ�memory����д�룬���ݴ���
        tags[index][3:0] <= tag[3:0];
        dirty[index] <= 1'b0;
        valid[index] <= 1'b1;
    end
end
endmodule
