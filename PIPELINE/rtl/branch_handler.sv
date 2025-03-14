`include "rv_dec.svh"
module branch_handler(
    input logic [31:0] operand_1,operand_2,
    input logic [6:0] opcode,
    input logic [2:0] func3,
    output logic br_taken
);

all_opcodes [6:0] opcode_br;

assign opcode_br = all_opcodes'(opcode[6:0]);

always_comb begin
    case (opcode_br)
        B_TYPE : begin 
            case (func3)
                3'b000 : br_taken = (operand_1 == operand_2); //beq
                3'b001 : br_taken = (operand_1 != operand_2); //bne
                3'b100 : br_taken = ($signed(operand_1) < $signed(operand_2)); //blt
                3'b101 : br_taken = ($signed(operand_1) >= $signed(operand_2)); //bge
                3'b110 : br_taken = (operand_1 < operand_2); //bltu
                3'b111 : br_taken = (operand_1 >= operand_2); //bgeu
                default: begin
                    br_taken = 1'b0;
                end
            endcase
        end
        J_TYPE : br_taken = 1'b1;
        I_JALR : br_taken = 1'b1; 
        default: begin
            br_taken = 1'b0;
        end
    endcase
end
    
 endmodule