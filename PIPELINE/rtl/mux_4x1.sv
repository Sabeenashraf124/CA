module mux_4x1(
    input [31:0] wbsel_line1,wbsel_line2,wbsel_line3,wbsel_line4,
    input [1:0] wb_sel,
    output logic [31:0] web_sel_rwb
);

always_comb begin
    case (wb_sel)
        2'b00 : web_sel_rwb = wbsel_line1;
        2'b01 : web_sel_rwb = wbsel_line2;
        2'b10 : web_sel_rwb = wbsel_line3;
        2'b11 : web_sel_rwb = wbsel_line4;
    endcase
end
    
endmodule