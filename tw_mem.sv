`timescale 1ns / 1ps

module tw_mem_st1(
    input                      clk,
    input                      rst,
    input [3:0]                addr,
    input                      valid,
    output logic signed [11:0] twiddle_re,
    output logic signed [11:0] twiddle_im
    );
    
    always @(posedge clk)
    begin
        if(rst) begin
            twiddle_re <= 12'h0;
        end else begin
            if(valid) begin
                case(addr)
                    4'b0000: twiddle_re <= 2047;
                    4'b0001: twiddle_re <= 1891;
                    4'b0010: twiddle_re <= 1447;
                    4'b0011: twiddle_re <= 783;
                    4'b0100: twiddle_re <= 0;
                    4'b0101: twiddle_re <= -783;
                    4'b0110: twiddle_re <= -1447;
                    4'b0111: twiddle_re <= -1891;
                    default: twiddle_re <= 0;
                endcase
            end
        end
    end
    
    always @(posedge clk)
    begin
        if(rst) begin
            twiddle_im <= 12'h0;
        end else begin
            if(valid) begin
                case(addr)
                    4'b0000: twiddle_im <= 0;
                    4'b0001: twiddle_im <= -783;
                    4'b0010: twiddle_im <= -1447;
                    4'b0011: twiddle_im <= -1891;
                    4'b0100: twiddle_im <= -2047;
                    4'b0101: twiddle_im <= -1891;
                    4'b0110: twiddle_im <= -1447;
                    4'b0111: twiddle_im <= -783;
                    default: twiddle_im <= 0;
                endcase
        end
        end
    end
    
    
endmodule
