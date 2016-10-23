`timescale 1ns / 1ps

module tw_mem_st3(
    input                      clk,
    input                      rst,
    input                      addr,
    output logic signed [11:0] twiddle_re,
    output logic signed [11:0] twiddle_im
    );
    
    always @(posedge clk)
    begin
        if(rst) begin
            twiddle_re <= 1'b0;
        end else begin
            case(addr)
                1'b0: twiddle_re <= 2047;
                1'b1: twiddle_re <= 0;
            endcase
        end
    end
    
    always @(posedge clk)
    begin
        if(rst) begin
            twiddle_im <= 1'b0;
        end else begin
            case(addr)
                1'b0: twiddle_im <= 0;
                1'b1: twiddle_im <= -2047;
            endcase
        end
    end
    
    
endmodule