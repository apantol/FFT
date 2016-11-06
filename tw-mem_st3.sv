`timescale 1ns / 1ps

module tw_mem_st3(
    input                      clk,
    input                      rst,
    input  [3:0]               addr,
    input                      valid,
    output logic signed [11:0] twiddle_re,
    output logic signed [11:0] twiddle_im
    );
    
    always @(posedge clk)
    begin
        if(rst) begin
            twiddle_re <= 1'b0;
        end else begin
            if(valid) begin
                case(addr)
                    4'b1100: twiddle_re <= 2047;
                    4'b1101: twiddle_re <= 0;
                    default: twiddle_re <= 0;
                endcase
            end
        end
    end
    
    always @(posedge clk)
    begin
        if(rst) begin
            twiddle_im <= 1'b0;
        end else begin
            if(valid) begin
                case(addr)
                    4'b1100: twiddle_im <= 0;
                    4'b1101: twiddle_im <= -2047;
                    default: twiddle_im <= 0;
                endcase
            end
        end
    end
    
    
endmodule