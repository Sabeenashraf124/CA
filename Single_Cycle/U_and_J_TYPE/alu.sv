`include "rv_dec.svh"

module alu #(
    parameter BUS_WIDTH = 32
) (
    input [BUS_WIDTH-1:0] operand_a_i,
    input  [BUS_WIDTH-1:0] operand_b_i,
    input  [9:0] opselect_i,
    input [6:0] opcode,
    input [BUS_WIDTH-1:0] two_way,
    output logic [BUS_WIDTH-1:0] result_o 
);

all_opcodes [6:0] opcode_alu; 

assign opcode_alu = all_opcodes'(opcode[6:0]);

always_comb begin
    case (opcode_alu)
        R_TYPE: begin 
            case (opselect_i)
            10'b000_0000000: result_o = operand_a_i + operand_b_i;//ADD             
            10'b000_0100000: result_o = operand_a_i - operand_b_i;//SUB
            10'b001_0000000: result_o = operand_a_i << operand_b_i;//SLL
            10'b010_0000000: result_o = $signed(operand_a_i) < $signed(operand_b_i); //STL
            10'b011_0000000: result_o = operand_a_i < operand_b_i;// SLTU
            10'b100_0000000: result_o = operand_a_i ^ operand_b_i;// XOR
            10'b101_0000000: result_o = operand_a_i >> operand_b_i; // SRL
            10'b101_0100000: result_o = $signed(operand_a_i) >>> $signed(operand_b_i);// SR_Aritmatic 
            10'b110_0000000: result_o = operand_a_i | operand_b_i; //OR
            10'b111_0000000: result_o = operand_a_i & operand_b_i; //AND
            default: begin 
                result_o = 32'b0 ;
            end        
            endcase
        end
        I_TYPE : begin 
            case (opselect_i[9:7])
            3'b000: result_o = operand_a_i + operand_b_i;//ADD                       
            3'b001: result_o = operand_a_i << operand_b_i;//SLL          
            3'b010: result_o = $signed(operand_a_i) < $signed(operand_b_i);
            3'b011: result_o = operand_a_i < operand_b_i;// SLTU          
            3'b100: result_o = operand_a_i ^ operand_b_i;// XOR          
            3'b101: begin 
                if (operand_b_i[31:25] == 7'b0) begin
                    result_o = operand_a_i >> operand_b_i; //SRL
                    end
                else if (operand_b_i[31:25] == 7'b0100000) begin
                    result_o = $signed(operand_a_i) >>> $signed(operand_b_i); // SR_Arthimatic
                end
                else begin
                    result_o = 32'b0;
                end    
            end        
            3'b110: result_o = operand_a_i | operand_b_i; //OR          
            3'b111: result_o = operand_a_i & operand_b_i; //AND
            default: begin
                result_o = 32'b0;
            end
            endcase
        end
       I_LOAD : result_o = operand_a_i + operand_b_i;
       I_JALR : result_o = operand_a_i + operand_b_i;
       S_TYPE : result_o = operand_a_i + operand_b_i;
       B_TYPE : result_o = operand_a_i + operand_b_i;
       U_LUI : result_o = operand_b_i;
       U_AUIPC : result_o = operand_b_i + {21'b0,(two_way[10:0] - 11'd4)};
       J_TYPE : result_o = operand_a_i + operand_b_i;
    endcase
end

endmodule