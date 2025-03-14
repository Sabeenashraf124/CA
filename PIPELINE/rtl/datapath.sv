module datapath(
    input clk,reset_n,
    output logic [31:0] instruction_i,result_o

);
//Before Pipeline 
parameter BUS_WIDTH = 32;
logic [31:0] count_out;
logic [6:0] opcode;
logic [2:0] func3;
logic [6:0] func7;
logic [4:0] rd;
logic [4:0] rs1;
logic [4:0] rs2;
logic [11:0] imm;
logic[19:0] imm_u;
logic reg_wr,rd_en,sel_B,wr_en,sel_A,br_taken;
logic [1:0] wb_sel;
logic [31:0] operand_a_i,operand_b_i,operand_b_i_imm,operand_b_i_mux,wbsel_line3,web_sel_rwb;
logic [31:0] two_way,operand_a_i_mux;
//After Pipeline
logic [31:0] instruction_i_buff,from_pc_to_alu,result_oMW,operand_b_iMW,alu_to_last_mux;
logic reg_wrMw,rd_enMW,wr_enMW;
logic [1:0] wb_selMW; 
logic [2:0] func3MW;
logic [4:0] rd_delay;

//1

mux_special MUX_1(.a(count_out[10:0] + 11'd4),.b(result_o),.s(br_taken),.out(two_way));

coun_32bit PC(.clk(clk),.reset_n(reset_n),.count_in(two_way),.count_out(count_out));

wa_ba_mem INST_MEM(.address(count_out[10:0]),.data_out(instruction_i_buff));

pc_hold PC_BUFF_1(.clk(clk),.reset_n(reset_n),.in(count_out),.out(from_pc_to_alu));

hold_32bit IR_BUFF(.clk(clk),.reset_n(reset_n),.in(instruction_i_buff),.out(instruction_i));

//2

rv_inst_decoder CONTRL(.instruction_i(instruction_i),.opcode(opcode),.func3(func3),.func7(func7),.rd(rd),
    .rs1(rs1),.rs2(rs2),.imm(imm),.imm_u(imm_u),.reg_wr(reg_wr),.sel_B(sel_B),.rd_en(rd_en),.wb_sel(wb_sel),.wr_en(wr_en),.sel_A(sel_A));

control_hold CONTRL_BUFF(.clk(clk),.reset_n(reset_n),.reg_wr(reg_wr),.rd_en(rd_en),.wr_en(wr_en),.wb_sel(wb_sel),.func3(func3),
    .reg_wrMw(reg_wrMw),.rd_enMW(rd_enMW),.wr_enMW(wr_enMW),.wb_selMW(wb_selMW),.func3MW(func3MW));    

imm_gen IMGEN(.imm(imm),.imm_u(imm_u),.opcode(opcode),.func3(func3),.imm_gen(operand_b_i_imm));

rd_hold RD_ADDR_BUFF(.clk(clk),.reset_n(reset_n),.in(rd),.out(rd_delay));

reg_32bit_16 REG_FILE(.wr_addr(rd_delay),.rd_addr_1(rs1),.rd_addr_2(rs2),
    .data_in(web_sel_rwb),.data_out_a(operand_a_i),.data_out_b(operand_b_i),.write_en(reg_wr));

mux_2x1 MUX_2(.a(operand_b_i),.b(operand_b_i_imm),.s(sel_B),.out(operand_b_i_mux));

mux_2x1 MUX_4(.a(from_pc_to_alu),.b(operand_a_i),.s(sel_A),.out(operand_a_i_mux));

branch_handler BR_TAKEN(.operand_1(operand_a_i),.operand_2(operand_b_i),.opcode(opcode),.func3(func3),.br_taken(br_taken));

alu #(.BUS_WIDTH(BUS_WIDTH)) ALU(.operand_a_i(operand_a_i_mux),.operand_b_i(operand_b_i_mux),.opselect_i({func3,func7}),.opcode(opcode),.two_way(two_way),.result_o(result_o));

hold_32bit ALU_BUFF(.clk(clk),.reset_n(reset_n),.in(result_o),.out(result_oMW));

hold_32bit rs2_BUFF(.clk(clk),.reset_n(reset_n),.in(operand_b_i),.out(operand_b_iMW));

pc_hold PC_BUFF_2(.clk(clk),.reset_n(reset_n),.in(from_pc_to_alu),.out(alu_to_last_mux));

//3

d_mem_ls DTMM (.addr(result_oMW[10:0]),.func3(func3MW),.rd_en(rd_enMW),.rdata(wbsel_line3),.wr_en(wr_enMW),.clk(clk),.wdata(operand_b_iMW));

mux_4x1 MUX_3(.wbsel_line1(alu_to_last_mux + 32'd4),.wbsel_line2(result_oMW),.wbsel_line3(wbsel_line3),.wbsel_line4(32'b0),.wb_sel(wb_selMW),.web_sel_rwb(web_sel_rwb));
    
endmodule