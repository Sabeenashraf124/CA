`include "rv_dec.svh"

module imm_gen(
    input [11:0] imm,
    input [19:0] imm_u,
    input [6:0] opcode,
    input [2:0] func3,
    output logic [31:0] imm_gen
);

all_opcodes [6:0] opcode_imm;

assign opcode_imm = all_opcodes'(opcode[6:0]);

always_comb begin  
    case (opcode_imm)
        R_TYPE :
            imm_gen = 32'b0 ;
        I_TYPE : begin
            case (func3)
                3'b001 : imm_gen = {27'b0,imm[4:0]};
                3'b101 : imm_gen = {27'b0,imm[4:0]};
                default: begin
                    imm_gen = {{20{imm[11]}},imm[11:0]};
                end
            endcase 
        end
        I_LOAD : imm_gen = {{20{imm[11]}},imm[11:0]};
        I_JALR : imm_gen = {{20{imm[11]}},imm[11:0]};
        S_TYPE : imm_gen = {{20{imm[11]}},imm[11:0]};
        B_TYPE : imm_gen = {{19{imm[11]}},imm[11:0],1'b0};
        U_LUI : imm_gen = {imm_u[19:0],12'b0};
        U_AUIPC: imm_gen = {imm_u[19:0],12'b0};
        J_TYPE : imm_gen = {{11{imm_u[19]}},imm_u[19:0],1'b0};
    endcase 
end
endmodule