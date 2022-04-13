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
    input [10:0] icache_req_addr,//��ˮ�߶�д��ַ
    input [31:0] icache_req_data,//��ˮ��д����
    input icache_req_wen,    //cacheҪд
    input icache_req_valid,  //�Ƿ�Ҫ��д
    input iset_dirty,      //д������֮��dirty��1
    output [31:0] icache_resp_data,//����ˮ�ߵ�����
    
    output [10:0] imem_req_addr,//��memory�Ķ�д��ַ
    output [31:0] imem_req_data,//memoryд����
    
    input [31:0] imem_resp_data,//memory��ȡ�����ݷ���
    input imem_resp_valid,    //�����Ƿ���Ч
    
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

assign index = icache_req_addr[6:0];//����ĵ�ַindex
assign tag = icache_req_addr[10:7];//����ĵ�ַtag

assign ihit = icache_req_valid ? ((valid[index] == 1) && (tag == tags[index])):1'b0;//hit
assign imiss = icache_req_valid ? ((valid[index] == 1'b0) || (tag != tags[index])):1'b0;//miss
assign idirty_out = icache_req_valid ? dirty[index] : 1'b0;//��Ҫ����д��ʱ��Żῴ�᲻��

assign imem_req_data = data[index];//Ҫ����memory�е�����
wire [10:0] last_addr ;
assign last_addr = { tags[index], index};
assign imem_req_addr =(idirty_out ? last_addr: icache_req_addr[10:0]);//Ҫ����memory�ĵ�ַ
assign icache_resp_data = data[index];//��������ֵ

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
    else if(icache_req_wen) begin //д������ʱ����Ҫ��Ҫ���memory���ǰ�cpu��ֵд��cache
        data[index] <= icache_req_data;
        tags[index] <= tag;
        dirty[index] <= 1'b1;
        valid[index] <= 1'b1;
    end
    else if(imem_resp_valid) begin
        data[index] <= imem_resp_data;//��������ʱ�Ǵ�memory����д�룬���ݴ���
        tags[index] <= tag;
        dirty[index] <= 1'b0;
        valid[index] <= 1'b1;
    end
end
endmodule
