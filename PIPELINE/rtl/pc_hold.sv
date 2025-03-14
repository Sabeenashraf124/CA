module pc_hold(
    input reset_n,clk,
    input [31:0] in,
    output logic [31:0] out
);

always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        out <= 32'b0;
    end
    else begin
        out <= in;
    end
end
    
endmodule