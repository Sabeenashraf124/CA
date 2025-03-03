module coun_32bit(
    input clk,reset_n,
    input [31:0] count_in,
    output logic [31:0]count_out
);

//logic [31:0] count;

always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        count_out <= 32'd0 ;
    end else begin
        count_out <= count_in;
    end
end

//assign count_out = count;

endmodule