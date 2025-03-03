module reg_32bit_16(
    input [4:0] wr_addr,rd_addr_1,rd_addr_2,
    input [31:0] data_in,
    input write_en,
    output logic [31:0] data_out_a,data_out_b
);

logic [31:0] reg_file [0:31];

// initial begin 
//     $readmemh("C:/Users/DELL/Desktop/MeDS_LAB/R_TYPE/reg_data.hex", reg_file);
// end

//assign reg_file[0] = 32'b0;

always_comb begin
    if (write_en) begin
        reg_file[wr_addr] = data_in;
    end
end

assign data_out_a = (rd_addr_1==5'b00000) ? 32'b0 : reg_file[rd_addr_1];
assign data_out_b = (rd_addr_2==5'b00000) ? 32'b0 : reg_file[rd_addr_2];
    
endmodule