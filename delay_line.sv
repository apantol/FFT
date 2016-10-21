`timescale 1ns / 1ps


module delay_line#(
    parameter DW  = 12,
    parameter LEN = 8)
    (
        input                 clk,
        input                 rst,
        input                 valid_in,
        input        [DW-1:0] data_in,
        output logic          valid_out,
        output logic [DW-1:0] data_out
    );
    
    
    logic [LEN-1:0][DW-1:0] FIFO;
    
    always @(posedge clk) begin
        valid_out <= valid_in;
    end
    
    always @(posedge clk) begin
        if(rst) begin
            for(int i = 0; i < LEN; i++) begin
                FIFO[i] <= {DW{1'b0}};
            end
        end else begin
            if(valid_in) begin
                for(int i = 0; i < LEN; i++) begin
                    FIFO[i] <= FIFO[i-1];
                end
            end
        end
    end
    
    assign data_out = FIFO[LEN-1];
    
endmodule
