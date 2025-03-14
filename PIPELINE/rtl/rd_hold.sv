module rd_hold(
    input reset_n,clk,
    input [4:0] in,
    output logic [4:0] out
);

always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        out <= 5'b0;
    end
    else begin
        out <= in;
    end
end
    
endmodule