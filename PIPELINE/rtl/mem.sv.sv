module wa_ba_mem(
    //input clk, write_en,
    input [10:0] address,
    //input [7:0] data_in,
    output [31:0] data_out
);
    
// 2KB memory, word-aligned and byte-addressable
// Case 1: I can use same file for read and write opertaion in sense I know.
// Case 2: I Use here ditinict files for both.

reg [7:0] ram [0:2047];

initial begin
    $readmemh("C:\Users\uet\Documents\PIPELINE\memory_read.hex", ram);
end


/*always @(posedge clk) begin
    if (write_en) begin
        ram[address] <= data_in;
    end
end */

assign data_out = {ram[address],ram[address+1],ram[address+2],ram[address+3]};

/*always @(posedge clk) begin
    if (write_en) begin
        $writememh("C:\Users\uet\Documents\PIPELINE\memory_write.hex", ram,0,2047);
    end
end*/

endmodule