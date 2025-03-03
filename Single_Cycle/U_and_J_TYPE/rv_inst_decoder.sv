`include "rv_dec.svh"

module rv_inst_decoder(
    input [31:0] instruction_i,
    output logic [6:0] opcode,
    output logic [2:0] func3,
    output logic [6:0] func7,
    output logic [4:0] rd,
    output logic [4:0] rs1,
    output logic [4:0] rs2,
    output logic [11:0] imm,
    output logic[19:0] imm_u,
    output logic reg_wr,sel_B,rd_en,wr_en,sel_A,
    output logic [1:0] wb_sel 
);

all_opcodes [6:0] opcode_inc;

assign opcode_inc = all_opcodes'(instruction_i[6:0]);

//logic [11:0] imm_dec_in;

always_comb begin
    case (opcode_inc)
        R_TYPE : begin
            opcode=instruction_i[6:0];
            func3=instruction_i[14:12];
            func7=instruction_i[31:25];
            rd=instruction_i[11:7];
            rs1=instruction_i[19:15];
            rs2=instruction_i[24:20];
            imm= 0;
            imm_u= 0;
            reg_wr = 1'b1;
            sel_B = 1'b0;
            sel_A = 1'b1;
            rd_en = 1'b0;
            wb_sel = 2'b01;
            wr_en = 1'b0;

        end    
        I_TYPE : begin
            opcode=instruction_i[6:0];
            func3=instruction_i[14:12];
            func7=0;
            rd=instruction_i[11:7];
            rs1=instruction_i[19:15];
            rs2=0;
            imm= instruction_i[31:20];
            imm_u= 0;
            reg_wr = 1'b1;
            sel_A = 1'b1;
            sel_B = 1'b1;
            rd_en =1'b0;
            wb_sel = 2'b01;
            wr_en = 1'b0;
        end
        I_JALR : begin
            opcode=instruction_i[6:0];
            func3=instruction_i[14:12];
            func7=0;
            rd=instruction_i[11:7];
            rs1=instruction_i[19:15];
            rs2=0;
            imm= instruction_i[31:20];
            imm_u= 0;
            reg_wr = 1'b1;
            sel_A = 1'b0;
            sel_B = 1'b1;
            rd_en =1'b0;
            wb_sel = 2'b00;
            wr_en = 1'b0;
        end    
        I_LOAD: begin
            opcode=instruction_i[6:0];
            func3=instruction_i[14:12];
            func7=0;
            rd=instruction_i[11:7];
            rs1=instruction_i[19:15];
            rs2=0;
            imm= instruction_i[31:20];
            imm_u= 0;
            reg_wr = 1'b1;
            sel_A = 1'b1;
            sel_B = 1'b1;
            rd_en =1'b1;
            wb_sel = 2'b10;
            wr_en = 1'b0;
        end        
        S_TYPE:begin
            opcode=instruction_i[6:0];
            func3=instruction_i[14:12];
            func7=0;
            rd=0;
            rs1=instruction_i[19:15];
            rs2=instruction_i[24:20];
            imm= {instruction_i[31:25],instruction_i[11:7]};
            imm_u= 0;
            reg_wr = 1'b0;
            sel_A = 1'b1;
            sel_B = 1'b1;
            rd_en =1'b0;
            wb_sel = 2'b10;
            wr_en = 1'b1;
        end    
        U_AUIPC,U_LUI: begin
            opcode=instruction_i[6:0];
            func3=0;
            func7=0;
            rd=instruction_i[11:7];
            rs1=0;
            rs2=0;
            imm= 0;
            imm_u= instruction_i[31:12];
            reg_wr = 1'b1;
            sel_B = 1'b1;
            sel_A = 1'b1;
            rd_en = 1'b0;
            wb_sel = 2'b01;
            wr_en = 1'b0;
        end
        B_TYPE:begin
            opcode=instruction_i[6:0];
            func3=instruction_i[14:12];
            func7=0;
            rd=0;
            rs1=instruction_i[19:15];
            rs2=instruction_i[24:20];
            imm = {instruction_i[31], instruction_i[7], instruction_i[30:25], instruction_i[11:8]};
            imm_u= 0;
            reg_wr = 1'b0;
            sel_B = 1'b1;
            sel_A = 1'b0;
            rd_en = 1'b0;
            wb_sel = 2'b10;
            wr_en = 1'b0;
        end    
        J_TYPE: begin
            opcode=instruction_i[6:0];
            func3=0;
            func7=0;
            rd=instruction_i[11:7];
            rs1=0;
            rs2=0;
            imm= 0;
            imm_u = {instruction_i[31], instruction_i[19:12], instruction_i[20], instruction_i[30:21]};
            reg_wr = 1'b1;
            sel_B = 1'b1;
            sel_A = 1'b0;
            rd_en = 1'b0;
            wb_sel = 2'b00;
            wr_en = 1'b0;
        end
        default: begin
            opcode=0;
            func3=0;
            func7=0;
            rd=0;
            rs1=0;
            rs2=0;
            imm= 0;
            imm_u= 0;
            reg_wr = 1'b0;
            sel_A = 1'b1;
            sel_B = 1'b0;
            rd_en =1'b0;
            wr_en = 1'b0;
        end
    endcase
end

endmodule