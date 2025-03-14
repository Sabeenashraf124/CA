`include "rv_dec.svh"

module d_mem_ls(
    input [10:0] addr,
    input [31:0] wdata,
    input [2:0] func3,
    input rd_en,clk,wr_en,
    output logic [31:0]rdata
);

logic [7:0] mem [0:2047];

logic [7:0] byte_read;

logic [15:0] half_word;

func3_ls_use [2:0] func3_h;

assign func3_h = func3_ls_use'(func3[2:0]);

func3_ls_use_1 [2:0] func3_s;

assign func3_s = func3_ls_use_1'(func3[2:0]);

initial begin 
    $readmemh("C:\Users\uet\Documents\PIPELINE\temp_data_mem.hex",mem);
end

always_comb begin
    if (rd_en==1'b1) begin
        case (func3_h)
            LB : begin 
                byte_read = mem[addr]; 
                rdata = {{24{byte_read[7]}},byte_read}; 
                end
            LH : begin half_word = {mem[addr+1],mem[addr]};
                rdata = {{16{half_word[15]}},half_word}; 
                end
            LW : begin
                rdata = {mem[addr+3],mem[addr+2],mem[addr+1],mem[addr]};
                end
            LBU : begin 
                byte_read = mem[addr]; 
                rdata = {24'b0,byte_read}; 
                end
            LHU : begin 
                half_word = {mem[addr+1],mem[addr]};
                rdata = {16'b0,half_word}; 
                end             
            default: begin
                rdata = 32'b0;
            end
        endcase
    end
    else begin
        rdata = 32'b0;
    end
end

always @(negedge clk) begin
    if (wr_en == 1'b1) begin
        case (func3_s)
            SB : mem[addr] = wdata[7:0];

            SH : begin 
                mem[addr] = wdata[7:0];
                mem[addr+1]= wdata[15:8];
            end
            SW : begin 
                mem[addr] = wdata[7:0];
                mem[addr+1] = wdata[15:8];
                mem[addr+2] = wdata[23:16];
                mem[addr+3] = wdata[31:24];
            end
        endcase

        $writememh("C:\Users\uet\Documents\PIPELINE\temp_data_mem.hex",mem);

    end
    else begin
        mem = mem;
    end
end
    
endmodule