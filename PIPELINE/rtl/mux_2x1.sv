module mux_2x1(
    input logic [31:0]a,b,
    input s,
    output logic [31:0]out
);

assign out = (s)?b:a;
    
endmodule