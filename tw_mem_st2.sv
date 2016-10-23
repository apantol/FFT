`timescale 1ns / 1ps

module tw_mem_st2(
    input                      clk,
    input                      rst,
    input [1:0]                addr,
    output logic signed [11:0] twiddle_re,
    output logic signed [11:0] twiddle_im
    );
    
    always @(posedge clk)
    begin
        if(rst) begin
            twiddle_re <= 12'h0;
        end else begin
            case(addr)
                3'b00: twiddle_re <= 2047;
                3'b01: twiddle_re <= 1447;
                3'b10: twiddle_re <= 0;
                3'b11: twiddle_re <= -1447;
            endcase
        end
    
    end
    
    always @(posedge clk)
    begin
        if(rst) begin
            twiddle_im <= 12'h0;
        end else begin
            case(addr)
                3'b00: twiddle_im <= 0;
                3'b01: twiddle_im <= -1447;
                3'b10: twiddle_im <= -2047;
                3'b11: twiddle_im <= -1447;
            endcase
        end 
    end
    
    
endmodule