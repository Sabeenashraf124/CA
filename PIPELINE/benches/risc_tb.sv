module risc_tb(
    
);

logic clk = 0;
logic reset_n;
logic [31:0] instruction_i;
logic [31:0] result_o;

datapath TEST1(.clk(clk),.reset_n(reset_n),.instruction_i(instruction_i),.result_o(result_o));

always begin #5 clk = ~clk ; end

initial begin 
    
    reset_n = 0;

    #20;

    reset_n = 1;

    #200  $stop;   
end
    
endmodule