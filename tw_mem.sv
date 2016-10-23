`timescale 1ns / 1ps

module tw_mem_st1(
    input                      clk,
    input                      rst,
    input [2:0]                addr,
    output logic signed [11:0] twiddle_re,
    output logic signed [11:0] twiddle_im
    );
    
    always @(posedge clk)
    begin
        if(rst) begin
            twiddle_re <= 12'h0;
        end else begin
            case(addr)
                3'b000: twiddle_re <= 2047;
                3'b001: twiddle_re <= 1891;
                3'b010: twiddle_re <= 1447;
                3'b011: twiddle_re <= 783;
                3'b100: twiddle_re <= 0;
                3'b101: twiddle_re <= -783;
                3'b110: twiddle_re <= -1447;
                3'b111: twiddle_re <= -1891;
            endcase
        end
    end
    
    always @(posedge clk)
    begin
        if(rst) begin
            twiddle_im <= 12'h0;
        end else begin
            case(addr)
                3'b000: twiddle_im <= 0;
                3'b001: twiddle_im <= -783;
                3'b010: twiddle_im <= -1447;
                3'b011: twiddle_im <= -1891;
                3'b100: twiddle_im <= -2047;
                3'b101: twiddle_im <= -1891;
                3'b110: twiddle_im <= -1447;
                3'b111: twiddle_im <= -783;
            endcase
        end
    end
    
    
endmodule
