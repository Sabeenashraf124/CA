module control_hold(
    input reg_wr,rd_en,wr_en,reset_n,clk,
    input [1:0] wb_sel,
    input [2:0] func3,
    output logic reg_wrMw,rd_enMW,wr_enMW,
    output logic [1:0] wb_selMW,
    output logic [2:0] func3MW
);

always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        reg_wrMw <= 0 ;
        rd_enMW <= 0 ;
        wr_enMW <= 0 ;
        wb_selMW <= 0 ;
        func3MW <= 3'bxxx;
    end
    else begin
        reg_wrMw <= reg_wr ;
        rd_enMW <= rd_en ;
        wr_enMW <= wr_en ;
        wb_selMW <= wb_sel ;
        func3MW <= func3 ;
    end
end
    
endmodule