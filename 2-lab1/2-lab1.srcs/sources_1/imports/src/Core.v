`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/28 18:08:36
// Design Name: 
// Module Name: Core
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
module Core(
    input  wire        clk,
    input  wire        aresetn,
    input  wire        step,
    input  wire        debug_mode,
    // input  wire [4:0]  debug_reg_addr, // register address

    output wire [31:0] address,
    output wire [31:0] data_out,
    input  wire [31:0] data_in,
    input  wire [4:0]  debug_reg_addr,
    input  wire [6:0]  debug_index,
    input  wire [31:0] chip_debug_in,
    output wire [31:0] chip_debug_out0,
    output wire [31:0] chip_debug_out1,
    output wire [31:0] chip_debug_out2,
    output wire [31:0] chip_debug_out3
);

//wire [4:0] debug_reg_addr = 5'b10100;
//wire [6:0] debug_index1 = 7'b0000100;

   `include "AluOp.vh" 

    wire rst, mem_write, mem_clk, cpu_clk;
    wire [31:0] inst, core_data_in, addr_out, core_data_out, cpu_pc_out;
    wire [31:0] register_write,TAread_data;//测试变量
    wire [31:0] debug_out_data,debug_out_sig;
    
//-------------------------  D-Cache wires-----------------------------------------
    wire cache_req_valid, cpu_data_write, cpu_data_valid, cache_req_wen;
    reg  [31:0] clk_div;
    wire [31:0] cpu_data;
    wire [10:0] mem_req_addr, cpu_data_addr,  mem_req_addr_new;
    wire [31:0] cpu_out_addr;
    wire [31:0] cache_resp_data,  mem_req_data;
    wire cache_resp_stall, mem_req_wen, mem_req_valid, mem_resp_valid;
    wire [31:0] mem_resp_data;
    wire clk_latency_out, set_dirty;
    wire cache_stall;
        wire [31:0] cache_write_data ;
//-------------------------  I-Cache wires-----------------------------------------
    wire icache_req_valid, icpu_data_write, icpu_data_valid, icache_req_wen;
    wire [31:0] icpu_data;
    wire [10:0] imem_req_addr, imem_req_addr_new;
    wire [31:0] icache_resp_data,  imem_req_data;
    wire icache_resp_stall, imem_req_wen, imem_req_valid, imem_resp_valid;
    wire [31:0] imem_resp_data;
    wire iclk_latency_out, iset_dirty;
    wire ihit, idirty, imiss;
    reg [2:0] istate;
    
    assign rst = ~aresetn;
SCPU cpu(
    .clk(cpu_clk),
    .rst(rst),
    .if_inst(inst),
    .data_in(cache_resp_data),      // data from data memory从memory里面读出来的值
    
    //output under
    .addr_out(cpu_out_addr),         // data memory address读memory地址
    .data_out(cpu_data),    // data to data memory写入memory的值
    .pc_out(cpu_pc_out),             // connect to instruction memory读inst地址
    .mem_write(cpu_data_write),       //是否写数据，一位的信号
    .mem_valid(cpu_data_valid),
    .register_write(register_write),
    .debug_reg_addr(debug_reg_addr),
    .TAread_data(TAread_data),

    .cache_stall(cache_stall) //等cache   
);
    assign cache_stall = cache_resp_stall || icache_resp_stall;

    assign cpu_data_addr = cpu_out_addr[12:2];//将地址变为11位
    
always @(posedge clk) begin
    if(rst) clk_div <= 0;
    else clk_div <= clk_div + 1;
end

    assign mem_clk = clk_div[0]; // 50mhz
    assign cpu_clk = ~(debug_mode ? clk_div[2] : step);
   
//--------------------Cache control module----------------
    wire hit, dirty, miss;
    reg [2:0] state;

Cache Cache(
// CPU in 
    .clk(cpu_clk),
    .rst(rst),
    .cache_req_addr(cpu_data_addr),
    .cache_req_data(cpu_data),
    .cache_req_wen(cache_req_wen),
    .cache_req_valid(cpu_data_valid),
    .set_dirty(set_dirty),
//CPU out
    .cache_resp_data(cache_resp_data),
    
// memory 中读出的
    .mem_resp_data(cache_write_data),
    .mem_resp_valid(mem_resp_valid),
//给memory的数据和地址
    .mem_req_addr(mem_req_addr),//给memory的读写地址
    .mem_req_data(mem_req_data),//memory写数据
    
    .hit(hit),
    .dirty_out(dirty),
    .miss(miss),
    
    .debug_index(debug_index),
    .debug_out_data(debug_out_data),
    .debug_out_sig(debug_out_sig)
);
    
parameter  S_IDLE = 3'b000,
            S_BACK = 3'b001,
            S_BACK_WAIT = 3'b010,
            S_FILL = 3'b011,
            S_FILL_WAIT = 3'b100;
wire undirty;
assign undirty = ~dirty; 

always @(posedge cpu_clk or posedge rst ) begin
    if(rst) state <= S_IDLE;
    else if(state == S_BACK && clk_latency_out) begin
        state <= S_BACK_WAIT;
    end
    else if(state == S_FILL && clk_latency_out) begin
         state <= S_FILL_WAIT;
    end
    else if(cpu_data_valid==1'b1) begin
        case(state)
            S_IDLE: begin
                if(hit) state <= S_IDLE;
                else if(miss && dirty) state <= S_BACK;
                else if(miss && undirty) state <= S_FILL;
                end
            S_BACK_WAIT: state <= S_FILL;
            S_FILL_WAIT: state <= S_IDLE;
        endcase
    end
end

    assign mem_req_addr_new = (state == S_BACK)?mem_req_addr:((state == S_FILL)?cpu_data_addr:10'b0);//先用cache地址写入，再用cpu信号读出
    assign mem_req_wen = (state == S_BACK) ? 1'b1:1'b0;//memory要写
    assign mem_req_valid = (state==S_BACK||state == S_FILL) ? 1'b1:1'b0;//是否要读写
    assign cache_resp_stall = miss?1'b1:((state == S_IDLE) ? 1'b0:1'b1);//流水线stall信号
    assign mem_resp_valid = (state==S_FILL ) ? 1'b1: 1'b0;//数据是否有效
    assign cache_req_wen = (state==S_FILL || (miss==1'b0 && state==S_IDLE) ) ? cpu_data_write : 1'b0;
    assign cache_req_valid = cpu_data_valid;
    assign set_dirty = (state == S_FILL_WAIT && cache_req_wen == 1'b1) ? cache_req_valid:1'b0;

    assign cache_write_data = ( cpu_data_write )?  cpu_data :  mem_resp_data ;
    // TODO: 连接Data Memory
LatencyMemory LatencyMemory(
    .clk(cpu_clk),
    .rst(rst),
    .en(mem_req_valid),//控制相应写入和读出端口的数据，为高是正常写入或读出，为低时写入为0，读出为0
    .we(mem_req_wen),// 是否写数据
    .addr(mem_req_addr_new), // 地址输入
    .data_in(mem_req_data),// 写数据输入
    .data_out(mem_resp_data),// 读数据输出
    .clk_latency_out(clk_latency_out)
);

//--------------------------------------------------------------------------------


assign inst = icache_resp_data;

I_Cache I_Cache(
// CPU in 
  .clk(cpu_clk),
  .rst(rst),
  .icache_req_addr(cpu_pc_out[12:2]),
  .icache_req_data(cpu_data),
  .icache_req_wen(icache_req_wen),
  .icache_req_valid(icache_req_valid),
  .iset_dirty(iset_dirty),
//CPU out
  .icache_resp_data(icache_resp_data),
  
// memory 中读出的
  .imem_resp_data(imem_resp_data),
  .imem_resp_valid(imem_resp_valid),
//给memory的数据和地址
  .imem_req_addr(imem_req_addr),//给memory的读写地址
  .imem_req_data(imem_req_data),//memory写数据
  
  .ihit(ihit),
  .idirty_out(idirty),
  .imiss(imiss)
);
  
          
wire iundirty;
assign iundirty = ~idirty; 

always @(posedge cpu_clk or posedge rst ) begin
  if(rst) istate <= S_IDLE;
  else if(istate == S_BACK && iclk_latency_out) begin
      istate <= S_BACK_WAIT;
  end
  else if(istate == S_BACK_WAIT && iclk_latency_out) begin 
    istate <= S_FILL;
   end
  else if(istate == S_FILL && iclk_latency_out) begin
       istate <= S_FILL_WAIT;
  end
  else  begin
      case(istate)
          S_IDLE: begin
              if(ihit) istate <= S_IDLE;
              else if(imiss && idirty) istate <= S_BACK;
              else if(imiss && iundirty) istate <= S_FILL;
              end
         // S_BACK_WAIT: istate <= S_FILL;
          S_FILL_WAIT: istate <= S_IDLE;
      endcase
  end
end

assign imem_req_addr_new = (istate == S_BACK)?imem_req_addr:((istate == S_FILL)? cpu_pc_out[12:2]:10'b0);

assign imem_req_wen = (istate==S_BACK) ? 1'b1:1'b0;//memory要写
assign imem_req_valid = (istate==S_BACK||istate == S_FILL) ? 1'b1:1'b0;//是否要读写
assign icache_resp_stall = imiss?1'b1:((istate == S_IDLE) ? 1'b0:1'b1);//流水线stall信号
assign imem_resp_valid = (istate==S_FILL ) ? 1'b1:1'b0;//数据是否有效//cpu_data_write ? 1'b0:(
assign icache_req_wen =  1'b0;
assign icache_req_valid = 1'b1;
assign iset_dirty = (istate == S_FILL_WAIT && icache_req_wen == 1'b1) ? icache_req_valid:1'b0;
  
  // TODO: 连接Data Memory
iLatencyMemory iLatencyMemory(
  .clk(cpu_clk),
  .rst(rst),
  .en(imem_req_valid),//控制相应写入和读出端口的数据，为高是正常写入或读出，为低时写入为0，读出为0
  .we(imem_req_wen),// 是否写数据
  .addr(imem_req_addr_new), // 地址输入
  .data_in(imem_req_data),// 写数据输入
  .data_out(imem_resp_data),// 读数据输出
  .clk_latency_out(iclk_latency_out)
);    


assign chip_debug_out0 = cpu_pc_out;
assign chip_debug_out1 = TAread_data;
assign chip_debug_out2 = debug_out_data;
assign chip_debug_out3 = debug_out_sig;
assign address = cpu_out_addr;
endmodule
