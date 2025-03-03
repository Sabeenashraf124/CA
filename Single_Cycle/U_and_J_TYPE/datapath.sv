module datapath(
    input clk,reset_n,
    output logic [31:0] instruction_i,result_o

);

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


mux_special MUX_1(.a(count_out[10:0] + 11'd4),.b(result_o),.s(br_taken),.out(two_way));

coun_32bit PC(.clk(clk),.reset_n(reset_n),.count_in(two_way),.count_out(count_out));

mux_2x1 MUX_4(.a(count_out),.b(operand_a_i),.s(sel_A),.out(operand_a_i_mux));

wa_ba_mem INST_MEM(.address(count_out[10:0]),.data_out(instruction_i));

rv_inst_decoder CONTRL(.instruction_i(instruction_i),.opcode(opcode),.func3(func3),.func7(func7),.rd(rd),
    .rs1(rs1),.rs2(rs2),.imm(imm),.imm_u(imm_u),.reg_wr(reg_wr),.sel_B(sel_B),.rd_en(rd_en),.wb_sel(wb_sel),.wr_en(wr_en),.sel_A(sel_A));

imm_gen IMGEN(.imm(imm),.imm_u(imm_u),.opcode(opcode),.func3(func3),.imm_gen(operand_b_i_imm));    

reg_32bit_16 REG_FILE(.wr_addr(rd),.rd_addr_1(rs1),.rd_addr_2(rs2),
    .data_in(web_sel_rwb),.data_out_a(operand_a_i),.data_out_b(operand_b_i),.write_en(reg_wr));

mux_2x1 MUX_2(.a(operand_b_i),.b(operand_b_i_imm),.s(sel_B),.out(operand_b_i_mux));


branch_handler BR_TAKEN(.operand_1(operand_a_i),.operand_2(operand_b_i),.opcode(opcode),.func3(func3),.br_taken(br_taken));

alu #(.BUS_WIDTH(BUS_WIDTH)) ALU(.operand_a_i(operand_a_i_mux),.operand_b_i(operand_b_i_mux),.opselect_i({func3,func7}),.opcode(opcode),.two_way(two_way),.result_o(result_o));

d_mem_ls DTMM (.addr(result_o[10:0]),.func3(func3),.rd_en(rd_en),.rdata(wbsel_line3),.wr_en(wr_en),.clk(clk),.wdata(operand_b_i));

mux_4x1 MUX_3(.wbsel_line1(count_out + 32'd4),.wbsel_line2(result_o),.wbsel_line3(wbsel_line3),.wbsel_line4(32'b0),.wb_sel(wb_sel),.web_sel_rwb(web_sel_rwb));
    
endmodule