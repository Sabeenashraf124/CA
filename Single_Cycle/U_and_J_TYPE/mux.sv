module mux_special(
    input [10:0] a,
    input [31:0] b,
    input s,
    output logic [31:0] out 
);

assign out = (s)?b:{21'b0,a[10:0]};
    
endmodule
