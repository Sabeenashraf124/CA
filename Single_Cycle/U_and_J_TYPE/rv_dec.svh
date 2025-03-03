`ifndef rv_dec
`define rv_dec
typedef enum logic [6:0] {  
    R_TYPE = 7'b011_0011,
    I_TYPE = 7'b001_0011,
    I_LOAD = 7'b000_0011,
    I_JALR = 7'b110_0111,
    S_TYPE = 7'b010_0011,
    U_AUIPC = 7'b001_0111,
    U_LUI = 7'b011_0111,
    B_TYPE = 7'b110_0011,
    J_TYPE = 7'b110_1111
} all_opcodes;

typedef enum logic [2:0] {  
    LB  = 3'b000,
    LH  = 3'b001,
    LW  = 3'b010,
    LBU = 3'b100,
    LHU = 3'b101
} func3_ls_use;

typedef enum logic [2:0] {  
    SB  = 3'b000,
    SH  = 3'b001,
    SW  = 3'b010
} func3_ls_use_1;


`endif